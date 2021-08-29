scriptName SkyUnit extends Quest hidden
{Global functions for assertions to interact with, etc}

; TODO look at doing fluent assertions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Debug: whether to write JSON test log file for each test that runs
bool _writeTestLogFiles = true

; The primary test data set
int _testData

; Variable for getting individual locks for running tests one at a time
float _testLock

; The current SkyUnitTest
SkyUnitTest _currentTestScript

; The current map for the script which stores test names and maps them top test objects (for the current SkyUnitTest)
int _currentTestScriptMap

; The current "tests" map which maps test names to test objects (for the current SkyUnitTest)
int _currentTestScriptTestsMap

; The current test object for the current running test
int _currentTestMap

; Name of the current test function
string _currentTestName

; The current array of expectations for the current test
int _currentExpectationsArray

; The current array for expectation failure messages for the current test
int _currentExpectationFailureMessagesArray

; The current array of logs for the current test
int _currentLogsArray

; The current expectation
int _currentExpectationMap

; The current "data" map on the current expectation
int _currentExpectationDataMap

; Arrays of registered test scripts which can be run
int _registeredTestScriptsLookupMap
int _registeredTestScriptsNextIndex
SkyUnitTest[] _registeredTestScripts1
SkyUnitTest[] _registeredTestScripts2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main OnInit() for mod installation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

event OnInit()
    ResetTestData()
endEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Debug Logs fro SkyUI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function Debug(string text)
    Debug.Trace("[SkyUnit] " + text)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read-only getters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SkyUnitTest property CurrentTestScript
    SkyUnitTest function get()
        Debug("Returning Current Test Script: " + _currentTestScript)
        return _currentTestScript
    endFunction
endProperty

int property CurrentExpectationDataMap
    int function get()
        return _currentExpectationDataMap
    endFunction
endProperty

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Data Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function ResetTestData()
    Debug("Reset Test Data")
    if _testData
        JValue.release(_testData)
    endIf
    _testData = JMap.object()
    JValue.retain(_testData)
    JMap.setObj(_testData, "testScripts", JMap.object())
    if ! _registeredTestScripts1
        ResetSkyUnitTestArrays()
    endIf
endFunction

function ResetSkyUnitTestArrays()
    Debug("Reset SkyUnitTest Storage Arrays")
    if _registeredTestScriptsLookupMap
        JValue.release(_registeredTestScriptsLookupMap)
    endIf
    _registeredTestScriptsLookupMap = JMap.object()
    JValue.retain(_registeredTestScriptsLookupMap)
    _registeredTestScripts1 = new SkyUnitTest[128]
    _registeredTestScripts2 = new SkyUnitTest[128]
endFunction

SkyUnit function GetInstance() global
    return Game.GetFormFromFile(0x800, "SkyUnit.esp") as SkyUnit
endFunction

SkyUnitTest function CurrentTest() global
    return GetInstance().CurrentTestScript
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Script Registration Management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function RegisterSkyUnitTest(SkyUnitTest test)
    int existingIndex = JMap.getInt(_registeredTestScriptsLookupMap, test)
    if existingIndex
        return ; Already registered
    endIf
    Debug("Register SkyUnitTest script " + test)
    JMap.setInt(_registeredTestScriptsLookupMap, test, _registeredTestScriptsNextIndex)
    if _registeredTestScriptsNextIndex < 128
        _registeredTestScripts1[_registeredTestScriptsNextIndex] = test
        _registeredTestScriptsNextIndex += 1
    elseIf _registeredTestScriptsNextIndex < 256
        _registeredTestScripts1[_registeredTestScriptsNextIndex - 128] = test
        _registeredTestScriptsNextIndex += 1
    else
        Debug("Cannot register SkyUnitTest " + test + " because 256 tests are already registered (that is currently the max)")
    endIf
endFunction

int function InstanceGetTestScriptCount()
    return _registeredTestScriptsNextIndex
endFunction

int function GetTestScriptCount() global
    return GetInstance().InstanceGetTestScriptCount()
endFunction

SkyUnitTest function InstanceGetNthTestScript(int index)
    if index < 128
        return _registeredTestScripts1[index]
    elseIf index < 256
        return _registeredTestScripts1[index - 128]
    else
        Debug("Cannot get SkyUnitTest " + index + " because 255 is the highest allowed index")
    endIf
endFunction

SkyUnitTest function GetNthTestScript(int index) global
    return GetInstance().InstanceGetNthTestScript(index)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Script and individual Test Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function BeginTestScript(SkyUnitTest test)
    Debug("Begin Test Script: " + test)
    int testScripts = JMap.getObj(_testData, "testScripts")
    int testScript = JMap.object()
    JMap.setObj(testScripts, test, testScript)
    _currentTestScriptMap = testScript
    int tests = JMap.object()
    JMap.setObj(testScript, "tests", tests)
    _currentTestScriptTestsMap = tests
    _currentTestScript = test
endFunction

function BeginTest(SkyUnitTest test, string testName)
    Debug("Begin Test: " + test + " ~ " + testName)
    int testObj = JMap.object()
    JMap.setObj(_currentTestScriptTestsMap, testName, testObj)
    JMap.setStr(testObj, "name", testName)
    int expectations = JArray.object()
    JMap.setObj(testObj, "expectations", expectations)
    int expectationFailureMessages = JArray.object()
    JMap.setObj(testObj, "expectationFailureMessages", expectationFailureMessages)
    int logs = JArray.object()
    JMap.setObj(testObj, "logs", logs)
    _currentTestMap = testObj
    _currentExpectationsArray = expectations
    _currentLogsArray = logs
    _currentTestName = testName
    _currentExpectationFailureMessagesArray = expectationFailureMessages
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Logs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function Log(string text)
    JArray.addStr(_currentLogsArray, text)
    Debug.Trace(_currentTestScript + " <" + _currentTestName + "> " + text)
endFunction

function WriteTestLogs()
    if _writeTestLogFiles
        string filename = "SkyUnit_" + Utility.RandomInt(0, 1000) + "_TestResults.json"
        JValue.writeToFile(_testData, filename)
        Debug.Notification("Saved " + filename)
    endIf
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expectations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function BeginExpectation(string expectationName) global
    SkyUnit.GetInstance().InstanceBeginExpectation(expectationName)
endFunction

function InstanceBeginExpectation(string expectationName)
    Debug("Begin Expectation:" + expectationName)
    int expectation = JMap.object()
    JArray.addObj(_currentExpectationsArray, expectation)
    JMap.setStr(expectation, "type", expectationName)
    int expectationData = JMap.object()
    JMap.setObj(expectation, "data", expectationData)
    _currentExpectationMap = expectation
    _currentExpectationDataMap = expectationData
endFunction

function FailExpectation(string failureMessage) global
    GetInstance().InstanceFailExpectation(failureMessage)
endFunction

function InstanceFailExpectation(string failureMessage)
    Debug("Fail Expectation: " + failureMessage)
    JMap.setInt(_currentExpectationMap, "failed", 1)
    JMap.setStr(_currentExpectationMap, "expectationFailureMessage", failureMessage)
    ; Total failed for Test Script
    int currentFailedExpectationCount = JMap.getInt(_currentTestScriptMap, "failedExpectations")
    JMap.setInt(_currentTestScriptMap, "failedExpectations", currentFailedExpectationCount + 1)
    ; Total Failed for Test Function
    currentFailedExpectationCount = JMap.getInt(_currentTestMap, "failedExpectations")
    JMap.setInt(_currentTestMap, "failedExpectations", currentFailedExpectationCount + 1)
    ; Add to failure messages for this test function
    JArray.addStr(_currentExpectationFailureMessagesArray, failureMessage)
endFunction

bool function Not() global
    return GetInstance().CurrentExpectationIsNotExpectation()
endFunction

function SetNotExpectation()
    JMap.setInt(_currentExpectationMap, "not", 1)
endFunction

bool function CurrentExpectationIsNotExpectation()
    return JMap.getInt(_currentExpectationMap, "not") == 1
endFunction

function SetExpectationFailureMessage(string failureMessage)
    JMap.setStr(_currentExpectationMap, "customFailureMessage", failureMessage)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expectation Data Getters and Setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

string function GetExpectationData_Object_TypeKey(string typeName) global
    return "Default Expectation Object: " + typeName
endFunction

function SetExpectationData_MainObjectType(string typeName, bool onlyIfNotSet = false) global
    if onlyIfNotSet && GetExpectationData_MainObjectType()
        return
    endIf
    JMap.setStr(GetInstance().CurrentExpectationDataMap, "Main Expectation Object Type", typeName)
endFunction

string function GetExpectationData_MainObjectType() global
    return JMap.getStr(GetInstance().CurrentExpectationDataMap, "Main Expectation Object Type")
endFunction

;; Text representation of the most recently added object for this expectation

function SetExpectationData_Object_Text(string object) global
    JMap.setStr(GetInstance().CurrentExpectationDataMap, GetExpectationData_Object_TypeKey("LastObjectSerializedAsText"), object)
endFunction

string function GetExpectationData_Object_Text() global
    return GetExpectationData_String(GetExpectationData_Object_TypeKey("LastObjectSerializedAsText"))
endFunction

;; Form

Form function GetExpectationData_Object_Form() global
    return GetExpectationData_Form(GetExpectationData_Object_TypeKey("Form"))
endFunction

function SetExpectationData_Object_Form(Form value) global
    SetExpectationData_Form(GetExpectationData_Object_TypeKey("Form"), value)
    SetExpectationData_Object_Text(value)
    SetExpectationData_MainObjectType("Form", onlyIfNotSet = true)
endFunction

Form function GetExpectationData_Form(string dataKey) global
    return JMap.getForm(GetInstance().CurrentExpectationDataMap, dataKey)
endFunction

function SetExpectationData_Form(string dataKey, Form value) global
    JMap.setForm(GetInstance().CurrentExpectationDataMap, dataKey, value)
endFunction

;; Form Array

Form[] function GetExpectationData_Object_FormArray() global
    return GetExpectationData_FormArray(GetExpectationData_Object_TypeKey("FormArray"))
endFunction

function SetExpectationData_Object_FormArray(Form[] value) global
    SetExpectationData_FormArray(GetExpectationData_Object_TypeKey("FormArray"), value)
    SetExpectationData_Object_Text(value)
    SetExpectationData_MainObjectType("FormArray", onlyIfNotSet = true)
endFunction

Form[] function GetExpectationData_FormArray(string dataKey) global
    return JArray.asFormArray(JMap.getObj(GetInstance().CurrentExpectationDataMap, dataKey))
endFunction

function SetExpectationData_FormArray(string dataKey, Form[] value) global
    int array = JArray.object()
    JMap.setObj(GetInstance().CurrentExpectationDataMap, dataKey, array)
    int index = 0
    while index < value.Length
        JArray.addForm(array, value[index])
        index += 1
    endWhile
endFunction

;; String

string function GetExpectationData_Object_String() global
    return GetExpectationData_String(GetExpectationData_Object_TypeKey("String"))
endFunction

function SetExpectationData_Object_String(string value) global
    SetExpectationData_String(GetExpectationData_Object_TypeKey("String"), value)
    SetExpectationData_Object_Text(value)
    SetExpectationData_MainObjectType("String", onlyIfNotSet = true)
endFunction

string function GetExpectationData_String(string dataKey) global
    return JMap.getStr(GetInstance().CurrentExpectationDataMap, dataKey)
endFunction

function SetExpectationData_String(string dataKey, String value) global
    JMap.setStr(GetInstance().CurrentExpectationDataMap, dataKey, value)
endFunction

;; String Array

string[] function GetExpectationData_Object_StringArray() global
    return GetExpectationData_StringArray(GetExpectationData_Object_TypeKey("StringArray"))
endFunction

function SetExpectationData_Object_StringArray(string[] value) global
    SetExpectationData_StringArray(GetExpectationData_Object_TypeKey("StringArray"), value)
    SetExpectationData_Object_Text(value)
    SetExpectationData_MainObjectType("StringArray", onlyIfNotSet = true)
endFunction

string[] function GetExpectationData_StringArray(string dataKey) global
    return JArray.asStringArray(JMap.getObj(GetInstance().CurrentExpectationDataMap, dataKey))
endFunction

function SetExpectationData_StringArray(string dataKey, string[] value) global
    int array = JArray.object()
    JMap.setObj(GetInstance().CurrentExpectationDataMap, dataKey, array)
    int index = 0
    while index < value.Length
        JArray.addStr(array, value[index])
        index += 1
    endWhile
endFunction

;; Int

int function GetExpectationData_Object_Int() global
    return GetExpectationData_Int(GetExpectationData_Object_TypeKey("Int"))
endFunction

function SetExpectationData_Object_Int(int value) global
    SetExpectationData_Int(GetExpectationData_Object_TypeKey("Int"), value)
    SetExpectationData_Object_Text(value)
    SetExpectationData_MainObjectType("Int", onlyIfNotSet = true)
endFunction

int function GetExpectationData_Int(string dataKey) global
    return JMap.getInt(GetInstance().CurrentExpectationDataMap, dataKey)
endFunction

function SetExpectationData_Int(string dataKey, Int value) global
    JMap.setInt(GetInstance().CurrentExpectationDataMap, dataKey, value)
endFunction

;; Int Array

int[] function GetExpectationData_Object_IntArray() global
    return GetExpectationData_IntArray(GetExpectationData_Object_TypeKey("IntArray"))
endFunction

function SetExpectationData_Object_IntArray(int[] value) global
    SetExpectationData_IntArray(GetExpectationData_Object_TypeKey("IntArray"), value)
    SetExpectationData_Object_Text(value)
    SetExpectationData_MainObjectType("IntArray", onlyIfNotSet = true)
endFunction

int[] function GetExpectationData_IntArray(string dataKey) global
    return JArray.asIntArray(JMap.getObj(GetInstance().CurrentExpectationDataMap, dataKey))
endFunction

function SetExpectationData_IntArray(string dataKey, int[] value) global
    int array = JArray.object()
    JMap.setObj(GetInstance().CurrentExpectationDataMap, dataKey, array)
    int index = 0
    while index < value.Length
        JArray.addInt(array, value[index])
        index += 1
    endWhile
endFunction

;; Bool

bool function GetExpectationData_Object_Bool() global
    return GetExpectationData_Bool(GetExpectationData_Object_TypeKey("Bool"))
endFunction

function SetExpectationData_Object_Bool(bool value) global
    SetExpectationData_Bool(GetExpectationData_Object_TypeKey("Bool"), value)
    SetExpectationData_Object_Text(value)
    SetExpectationData_MainObjectType("Bool", onlyIfNotSet = true)
endFunction

bool function GetExpectationData_Bool(string dataKey) global
    return JMap.getInt(GetInstance().CurrentExpectationDataMap, dataKey)
endFunction

function SetExpectationData_Bool(string dataKey, bool value) global
    JMap.setInt(GetInstance().CurrentExpectationDataMap, dataKey, value as int)
endFunction

;; Bool Array

bool[] function GetExpectationData_Object_BoolArray() global
    return GetExpectationData_BoolArray(GetExpectationData_Object_TypeKey("BoolArray"))
endFunction

function SetExpectationData_Object_BoolArray(bool[] value) global
    SetExpectationData_BoolArray(GetExpectationData_Object_TypeKey("BoolArray"), value)
    SetExpectationData_Object_Text(value)
    SetExpectationData_MainObjectType("BoolArray", onlyIfNotSet = true)
endFunction

bool[] function GetExpectationData_BoolArray(string dataKey) global
    int[] integers = JArray.asIntArray(JMap.getObj(GetInstance().CurrentExpectationDataMap, dataKey))
    bool[] bools = Utility.CreateBoolArray(integers.Length)
    int index = 0
    while index < integers.Length
        bools[index] = integers[index]
        index += 1
    endWhile
    return bools
endFunction

function SetExpectationData_BoolArray(string dataKey, bool[] value) global
    int array = JArray.object()
    JMap.setObj(GetInstance().CurrentExpectationDataMap, dataKey, array)
    int index = 0
    while index < value.Length
        JArray.addInt(array, value[index] as int)
        index += 1
    endWhile
endFunction

;; Float

float function GetExpectationData_Object_Float() global
    return GetExpectationData_Float(GetExpectationData_Object_TypeKey("Float"))
endFunction

function SetExpectationData_Object_Float(float value) global
    SetExpectationData_Float(GetExpectationData_Object_TypeKey("Float"), value)
    SetExpectationData_Object_Text(value)
    SetExpectationData_MainObjectType("Float", onlyIfNotSet = true)
endFunction

float function GetExpectationData_Float(string dataKey) global
    return JMap.getFlt(GetInstance().CurrentExpectationDataMap, dataKey)
endFunction

function SetExpectationData_Float(string dataKey, Float value) global
    JMap.setFlt(GetInstance().CurrentExpectationDataMap, dataKey, value)
endFunction

;; Float Array

float[] function GetExpectationData_Object_FloatArray() global
    return GetExpectationData_FloatArray(GetExpectationData_Object_TypeKey("FloatArray"))
endFunction

function SetExpectationData_Object_FloatArray(float[] value) global
    SetExpectationData_FloatArray(GetExpectationData_Object_TypeKey("FloatArray"), value)
    SetExpectationData_Object_Text(value)
    SetExpectationData_MainObjectType("FloatArray", onlyIfNotSet = true)
endFunction

float[] function GetExpectationData_FloatArray(string dataKey) global
    return JArray.asFloatArray(JMap.getObj(GetInstance().CurrentExpectationDataMap, dataKey))
endFunction

function SetExpectationData_FloatArray(string dataKey, float[] value) global
    int array = JArray.object()
    JMap.setObj(GetInstance().CurrentExpectationDataMap, dataKey, array)
    int index = 0
    while index < value.Length
        JArray.addFlt(array, value[index])
        index += 1
    endWhile
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lock for running one test at a time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function GetTestLock(float waitTime = 0.1, float lock = 0.0)
    Debug("GetTestLock()")
    if lock == 0.0
        lock = Utility.RandomFloat(1.0, 1000.0)
    endIf

    while _testLock != 0.0
        if waitTime
            Utility.WaitMenuMode(waitTime)
        endIf
    endWhile

    _testLock = lock

    if _testLock == lock
        if _testLock == lock
            Debug("Test Lock Acquired")
            return
        else
            return GetTestLock(waitTime, lock)
        endIf
    else
        return GetTestLock(waitTime, lock)
    endIf
endFunction

function ReleaseTestLock()
    Debug("Test Lock Released")
    _testLock = 0.0
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Result Queries
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

int function GetMapForSkyUnitTestResults(SkyUnitTest test)
    int testScripts = JMap.getObj(_testData, "testScripts")
    return JMap.getObj(testScripts, test)
endFunction

int function GetTestCount(SkyUnitTest test)
    int testsMap = JMap.getObj(GetMapForSkyUnitTestResults(test), "tests")
    return JMap.count(testsMap)
endFunction

string[] function GetTestNames(SkyUnitTest test)
    int testsMap = JMap.getObj(GetMapForSkyUnitTestResults(test), "tests")
    return JMap.allKeysPArray(testsMap)
endFunction

int function GetTestMap(SkyUnitTest test, string testName)
    int testsMap = JMap.getObj(GetMapForSkyUnitTestResults(test), "tests")
    return JMap.getObj(testsMap, testName)
endFunction

bool function TestPassed(SkyUnitTest test, string testName)
    int testMap = GetTestMap(test, testName)
    return JMap.getInt(testMap, "failedExpectations") == 0
endFunction

string[] function GetTestFailureMessages(SkyUnitTest test, string testName)
    int testMap = GetTestMap(test, testName)
    int failureMessagesArray = JMap.getObj(testMap, "expectationFailureMessages")
    return JArray.asStringArray(failureMessagesArray)
endFunction

bool function AllTestsPassed(SkyUnitTest test)
    return GetFailedExpectationCount(test) == 0
endFunction

int function GetFailedExpectationCount(SkyUnitTest test)
    int testMap = GetMapForSkyUnitTestResults(test)
    return JMap.getInt(testMap, "failedExpectations")
endFunction

string function GetTestDisplayName(SkyUnitTest test)
    string scriptNameText = test
    int spaceIndex = StringUtil.Find(scriptNameText, " ")
    return StringUtil.Substring(scriptNameText, 1, spaceIndex - 1)    
endFunction

string function GetTestSummary(SkyUnitTest test)
    string testScriptName = GetTestDisplayName(test)
    bool allTestsPassed = AllTestsPassed(test)
    string summary

    if allTestsPassed
        summary = testScriptName + " test passed\n"
    else
        summary = testScriptName + " test failed\n"
    endIf

    string[] testNames = GetTestNames(test)
    int index = 0
    while index < testNames.Length
        string testName = testNames[index]
        bool testPassed = TestPassed(test, testName)
        if testPassed
            summary += "[PASSED] " + testName + "\n"
        else
            summary += "[FAILED] " + testName + "\n"
            string[] failMessages = GetTestFailureMessages(test, testName)
            int failIndex = 0
            while failIndex < failMessages.Length
                summary += "- " + failMessages[failIndex] + "\n"
                failIndex += 1
            endWhile
        endIf
        index += 1
    endWhile

    return summary
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Filtering
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bool function ShouldRun()
    return true
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;