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

; The current "tests" map which maps test names to test objects (for the current SkyUnitTest)
int _currentTestScriptTestsMap

; The current test object for the current running test
int _currentTestMap

; Name of the current test function
string _currentTestName

; The current array of expectations for the current test
int _currentExpectationsArray

; The current array of logs for the current test
int _currentLogsArray

; The current expectation
int _currentExpectationMap

; The current "data" map on the current expectation
int _currentExpectationDataMap

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Getter for "Current Test" script
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SkyUnitTest property CurrentTestScript
    SkyUnitTest function get()
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
    if _testData
        JValue.release(_testData)
    endIf
    _testData = JMap.object()
    JValue.retain(_testData)
    JMap.setObj(_testData, "testScripts", JMap.object())
endFunction

SkyUnit function GetInstance() global
    return Game.GetFormFromFile(0x800, "SkyUnit.esp") as SkyUnit
endFunction

SkyUnitTest function CurrentTest() global
    return GetInstance().CurrentTestScript
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Script and individual Test Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function BeginTestScript(SkyUnitTest test)
    Debug.Trace("[SkyUnit] Begin Test Script (" + test + ")")
    int testScripts = JMap.getObj(_testData, "testScripts")
    int testScript = JMap.object()
    JMap.setObj(testScripts, test, testScript)
    int tests = JMap.object()
    JMap.setObj(testScript, "tests", tests)
    _currentTestScriptTestsMap = tests
    _currentTestScript = test
endFunction

function BeginTest(SkyUnitTest test, string testName)
    Debug.Trace("[SkyUnit] Begin Test (" + test + ") [" + testName + "]")
    int testObj = JMap.object()
    JMap.setObj(_currentTestScriptTestsMap, testName, testObj)
    JMap.setStr(testObj, "name", testName)
    int expectations = JArray.object()
    JMap.setObj(testObj, "expectations", expectations)
    int logs = JArray.object()
    JMap.setObj(testObj, "logs", logs)
    _currentTestMap = testObj
    _currentExpectationsArray = expectations
    _currentLogsArray = logs
    _currentTestName = testName
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
    Debug.Trace("[SkyUnit] Begin Expectation (" + type + ") [" + object + "]")
    GetInstance().InstanceBeginExpectation(type, object)
endFunction

function InstanceBeginExpectation(string type, string object)
    int expectation = JMap.object()
    JArray.addObj(_currentExpectationsArray, expectation)
    JMap.setStr(expectation, "type", type)
    JMap.setStr(expectation, "object", object)
    int expectationData = JMap.object()
    JMap.setObj(expectation, "data", expectationData)
    _currentExpectationMap = expectation
    _currentExpectationDataMap = expectationData
endFunction

function FailExpectation(string failureMessage) global
    GetInstance().InstanceFailExpectation(failureMessage)
endFunction

function InstanceFailExpectation(string failureMessage)
    JMap.setInt(_currentExpectationMap, "failed", 1)
    JMap.setStr(_currentExpectationMap, "expectationFailureMessage", failureMessage)
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

;; Form

Form function GetExpectationObjectForm() global
    return GetExpectationForm("<object:form>")
endFunction

function SetExpectationObjectForm(Form value) global
    SetExpectationForm("<object:form>", value)
endFunction

Form function GetExpectationForm(string strKey) global
    return GetInstance().InstanceGetExpectationForm(strKey)
endFunction

Form function InstanceGetExpectationForm(string strKey)
    return JMap.getForm(_currentExpectationDataMap, strKey)
endFunction

function SetExpectationForm(string strKey, Form value) global
    GetInstance().InstanceSetExpectationForm(strKey, value)
endFunction

function InstanceSetExpectationForm(string strKey, Form value)
    JMap.setForm(_currentExpectationDataMap, strKey, value)
endFunction

;; String

string function GetExpectationObjectString() global
    return GetExpectationString("<object:string>")
endFunction

function SetExpectationObjectString(string value) global
    SetExpectationString("<object:string>", value)
endFunction

string function GetExpectationString(string strKey) global
    return GetInstance().InstanceGetExpectationString(strKey)
endFunction

string function InstanceGetExpectationString(string strKey)
    return JMap.getStr(_currentExpectationDataMap, strKey)
endFunction

function SetExpectationString(string strKey, String value) global
    GetInstance().InstanceSetExpectationString(strKey, value)
endFunction

function InstanceSetExpectationString(string strKey, String value)
    JMap.setStr(_currentExpectationDataMap, strKey, value)
endFunction

;; Int

int function GetExpectationObjectInt() global
    return GetExpectationInt("<object:int>")
endFunction

function SetExpectationObjectInt(int value) global
    SetExpectationInt("<object:int>", value)
endFunction

int function GetExpectationInt(string strKey) global
    return GetInstance().InstanceGetExpectationInt(strKey)
endFunction

int function InstanceGetExpectationInt(string strKey)
    return JMap.getInt(_currentExpectationDataMap, strKey)
endFunction

function SetExpectationInt(string strKey, Int value) global
    GetInstance().InstanceSetExpectationInt(strKey, value)
endFunction

function InstanceSetExpectationInt(string strKey, Int value)
    JMap.setInt(_currentExpectationDataMap, strKey, value)
endFunction

;; Float

float function GetExpectationObjectFloat() global
    return GetExpectationFloat("<object:float>")
endFunction

function SetExpectationObjectFloat(float value) global
    SetExpectationFloat("<object:float>", value)
endFunction

float function GetExpectationFloat(string strKey) global
    return GetInstance().InstanceGetExpectationFloat(strKey)
endFunction

float function InstanceGetExpectationFloat(string strKey)
    return JMap.getFlt(_currentExpectationDataMap, strKey)
endFunction

function SetExpectationFloat(string strKey, Float value) global
    GetInstance().InstanceSetExpectationFloat(strKey, value)
endFunction

function InstanceSetExpectationFloat(string strKey, Float value)
    JMap.setFlt(_currentExpectationDataMap, strKey, value)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lock for running one test at a time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; TODO
function GetTestLock(float waitTime = 0.1, float lock = 0.0)
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
            return
        else
            return GetTestLock(waitTime, lock)
        endIf
    else
        return GetTestLock(waitTime, lock)
    endIf
endFunction

function ReleaseTestLock()
    _testLock = 0.0
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;