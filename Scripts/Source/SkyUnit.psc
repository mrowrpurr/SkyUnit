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
;; Debug Logs fro SkyUI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function Debug(string text)
    Debug.Trace("[SkyUnit] " + text)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Getter for "Current Test" script
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SkyUnitTest property CurrentTestScript
    SkyUnitTest function get()
        Debug("Returning Current Test Script: " + _currentTestScript)
        return _currentTestScript
    endFunction
endProperty

event OnInit()
    ResetTestData()
endEvent

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

function BeginExpectation(string type, string object) global
    SkyUnit.GetInstance().InstanceBeginExpectation(type, object)
endFunction

function InstanceBeginExpectation(string type, string object)
    Debug("Begin Expectation:" + type + " [" + object + "]")
    int expectation = JMap.object()
    JArray.addObj(_currentExpectationsArray, expectation)
    JMap.setStr(expectation, "type", type)
    JMap.setStr(expectation, "object", object)
    int expectationData = JMap.object()
    JMap.setObj(expectation, "data", expectationData)
    _currentExpectationMap = expectation
    _currentExpectationDataMap = expectationData
    Debug("Finished Setting Up Expectation")
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
    Debug("Finished Failing Expectation")
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
    return "[DEFAULT_OBJECT:" + typeName + "]"
endFunction

string function GetExpectationData_Object_Text() global
    return GetInstance().InstanceGetExpectationData_Object_Text()
endFunction

function SetExpectationData_Object_Text(string object) global
    GetInstance().InstanceSetExpectationData_Object_Text(object)
endFunction

function InstanceSetExpectationData_Object_Text(string object)
    JMap.setStr(_currentExpectationDataMap, GetExpectationData_Object_TypeKey("TEXT"), object)
endFunction

string function InstanceGetExpectationData_Object_Text()
    return GetExpectationData_String(GetExpectationData_Object_TypeKey("TEXT"))
endFunction

;; Form

Form function GetExpectationData_Object_Form() global
    return GetExpectationData_Form(GetExpectationData_Object_TypeKey("Form"))
endFunction

function SetExpectationData_Object_Form(Form value) global
    SetExpectationData_Form(GetExpectationData_Object_TypeKey("Form"), value)
endFunction

Form function GetExpectationData_Form(string dataKey) global
    return GetInstance().InstanceGetExpectationData_Form(dataKey)
endFunction

Form function InstanceGetExpectationData_Form(string dataKey)
    return JMap.getForm(_currentExpectationDataMap, dataKey)
endFunction

function SetExpectationData_Form(string dataKey, Form value) global
    GetInstance().InstanceSetExpectationData_Form(dataKey, value)
endFunction

function InstanceSetExpectationData_Form(string dataKey, Form value)
    JMap.setForm(_currentExpectationDataMap, dataKey, value)
    SetExpectationData_Object_Text(value)
endFunction

;; Form Array

Form[] function GetExpectationData_Object_FormArray() global
    return GetExpectationData_FormArray(GetExpectationData_Object_TypeKey("FormArray"))
endFunction

function SetExpectationData_Object_FormArray(Form[] value) global
    SetExpectationData_FormArray(GetExpectationData_Object_TypeKey("FormArray"), value)
endFunction

Form[] function GetExpectationData_FormArray(string dataKey) global
    return GetInstance().InstanceGetExpectationData_FormArray(dataKey)
endFunction

Form[] function InstanceGetExpectationData_FormArray(string dataKey)
    return JArray.asFormArray(JMap.getObj(_currentExpectationDataMap, dataKey))
endFunction

function SetExpectationData_FormArray(string dataKey, Form[] value) global
    GetInstance().InstanceSetExpectationData_FormArray(dataKey, value)
endFunction

function InstanceSetExpectationData_FormArray(string dataKey, Form[] value)
    int array = JArray.object()
    JMap.setObj(_currentExpectationDataMap, dataKey, array)
    int index = 0
    while index < value.Length
        JArray.addForm(array, value[index])
        index += 1
    endWhile
    SetExpectationData_Object_Text(value)
endFunction

;; String

string function GetExpectationData_Object_String() global
    return GetExpectationData_String(GetExpectationData_Object_TypeKey("String"))
endFunction

function SetExpectationData_Object_String(string value) global
    SetExpectationData_String(GetExpectationData_Object_TypeKey("String"), value)
endFunction

string function GetExpectationData_String(string dataKey) global
    return GetInstance().InstanceGetExpectationData_String(dataKey)
endFunction

string function InstanceGetExpectationData_String(string dataKey)
    return JMap.getStr(_currentExpectationDataMap, dataKey)
endFunction

function SetExpectationData_String(string dataKey, String value) global
    GetInstance().InstanceSetExpectationData_String(dataKey, value)
endFunction

function InstanceSetExpectationData_String(string dataKey, String value)
    JMap.setStr(_currentExpectationDataMap, dataKey, value)
    SetExpectationData_Object_Text(value)
endFunction

;; String Array

string[] function GetExpectationData_Object_StringArray() global
    return GetExpectationData_StringArray(GetExpectationData_Object_TypeKey("StringArray"))
endFunction

function SetExpectationData_Object_StringArray(string[] value) global
    SetExpectationData_StringArray(GetExpectationData_Object_TypeKey("StringArray"), value)
endFunction

string[] function GetExpectationData_StringArray(string dataKey) global
    return GetInstance().InstanceGetExpectationData_StringArray(dataKey)
endFunction

string[] function InstanceGetExpectationData_StringArray(string dataKey)
    return JArray.asStringArray(JMap.getObj(_currentExpectationDataMap, dataKey))
endFunction

function SetExpectationData_StringArray(string dataKey, string[] value) global
    GetInstance().InstanceSetExpectationData_StringArray(dataKey, value)
endFunction

function InstanceSetExpectationData_StringArray(string dataKey, string[] value)
    int array = JArray.object()
    JMap.setObj(_currentExpectationDataMap, dataKey, array)
    int index = 0
    while index < value.Length
        JArray.addStr(array, value[index])
        index += 1
    endWhile
    SetExpectationData_Object_Text(value)
endFunction

;; Int

int function GetExpectationData_Object_Int() global
    return GetExpectationData_Int(GetExpectationData_Object_TypeKey("Int"))
endFunction

function SetExpectationData_Object_Int(int value) global
    SetExpectationData_Int(GetExpectationData_Object_TypeKey("Int"), value)
endFunction

int function GetExpectationData_Int(string dataKey) global
    return GetInstance().InstanceGetExpectationData_Int(dataKey)
endFunction

int function InstanceGetExpectationData_Int(string dataKey)
    return JMap.getInt(_currentExpectationDataMap, dataKey)
endFunction

function SetExpectationData_Int(string dataKey, Int value) global
    GetInstance().InstanceSetExpectationData_Int(dataKey, value)
endFunction

function InstanceSetExpectationData_Int(string dataKey, Int value)
    JMap.setInt(_currentExpectationDataMap, dataKey, value)
    SetExpectationData_Object_Text(value)
endFunction

;; Int Array

int[] function GetExpectationData_Object_IntArray() global
    return GetExpectationData_IntArray(GetExpectationData_Object_TypeKey("IntArray"))
endFunction

function SetExpectationData_Object_IntArray(int[] value) global
    SetExpectationData_IntArray(GetExpectationData_Object_TypeKey("IntArray"), value)
endFunction

int[] function GetExpectationData_IntArray(string dataKey) global
    return GetInstance().InstanceGetExpectationData_IntArray(dataKey)
endFunction

int[] function InstanceGetExpectationData_IntArray(string dataKey)
    return JArray.asIntArray(JMap.getObj(_currentExpectationDataMap, dataKey))
endFunction

function SetExpectationData_IntArray(string dataKey, int[] value) global
    GetInstance().InstanceSetExpectationData_IntArray(dataKey, value)
endFunction

function InstanceSetExpectationData_IntArray(string dataKey, int[] value)
    int array = JArray.object()
    JMap.setObj(_currentExpectationDataMap, dataKey, array)
    int index = 0
    while index < value.Length
        JArray.addInt(array, value[index])
        index += 1
    endWhile
    SetExpectationData_Object_Text(value)
endFunction

;; Float

float function GetExpectationData_Object_Float() global
    return GetExpectationData_Float(GetExpectationData_Object_TypeKey("Float"))
endFunction

function SetExpectationData_Object_Float(float value) global
    SetExpectationData_Float(GetExpectationData_Object_TypeKey("Float"), value)
endFunction

float function GetExpectationData_Float(string dataKey) global
    return GetInstance().InstanceGetExpectationData_Float(dataKey)
endFunction

float function InstanceGetExpectationData_Float(string dataKey)
    return JMap.getFlt(_currentExpectationDataMap, dataKey)
endFunction

function SetExpectationData_Float(string dataKey, Float value) global
    GetInstance().InstanceSetExpectationData_Float(dataKey, value)
endFunction

function InstanceSetExpectationData_Float(string dataKey, Float value)
    JMap.setFlt(_currentExpectationDataMap, dataKey, value)
    SetExpectationData_Object_Text(value)
endFunction

;; Float Array

float[] function GetExpectationData_Object_FloatArray() global
    return GetExpectationData_FloatArray(GetExpectationData_Object_TypeKey("FloatArray"))
endFunction

function SetExpectationData_Object_FloatArray(float[] value) global
    SetExpectationData_FloatArray(GetExpectationData_Object_TypeKey("FloatArray"), value)
endFunction

float[] function GetExpectationData_FloatArray(string dataKey) global
    return GetInstance().InstanceGetExpectationData_FloatArray(dataKey)
endFunction

float[] function InstanceGetExpectationData_FloatArray(string dataKey)
    return JArray.asFloatArray(JMap.getObj(_currentExpectationDataMap, dataKey))
endFunction

function SetExpectationData_FloatArray(string dataKey, float[] value) global
    GetInstance().InstanceSetExpectationData_FloatArray(dataKey, value)
endFunction

function InstanceSetExpectationData_FloatArray(string dataKey, float[] value)
    int array = JArray.object()
    JMap.setObj(_currentExpectationDataMap, dataKey, array)
    int index = 0
    while index < value.Length
        JArray.addFlt(array, value[index])
        index += 1
    endWhile
    SetExpectationData_Object_Text(value)
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
            Utility.Wait(waitTime)
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