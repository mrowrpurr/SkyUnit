scriptName SkyUnit
{Global interface for integrating with **SkyUnit**

For writing tests, please see `SkyUnitTest`}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Check version of SkyUnit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

float function GetVersion() global
    return 1.0
endFunction

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;; Serialize / Deserialize for Cache
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; function SaveCache(string filename) global
;     SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
;     if api.GlobalDataMap
;         JValue.writeToFile(api.GlobalDataMap, filename)
;     endIf
; endFunction

; function LoadFromCache(string filename) global
;     SkyUnit2PrivateAPI.GetPrivateAPI().GlobalDataMap = JValue.readFromFile(filename)
; endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Functions for Managing Tests
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function SwitchToTestSuite(string name) global
    SkyUnit2PrivateAPI.GetPrivateAPI().SwitchToTestSuiteByName(name)
endFunction

function UseDefaultTestSuite() global
    SkyUnit2PrivateAPI.GetPrivateAPI().SwitchToTestSuiteByName(SkyUnit.DefaultTestSuite())
endFunction

function CreateTestSuite(string suiteName, bool switchTo = false) global
    SkyUnit2PrivateAPI.GetPrivateAPI().CreateTestSuite(suiteName, switchTo)
endFunction

function DeleteTestSuite(string suiteName) global
    SkyUnit2PrivateAPI.GetPrivateAPI().DeleteTestSuite(suiteName)
endFunction

; string function GetCurrentTestSuite() global
;     SkyUnit2PrivateAPI.GetPrivateAPI().GetCurrentTestSuiteName()
; endFunction

int function GetTestSuiteCount() global
    return JMap.count(SkyUnit2PrivateAPI.GetPrivateAPI().TestSuitesMap)
endFunction

string[] function GetTestSuiteNames() global
    return JMap.allKeysPArray(SkyUnit2PrivateAPI.GetPrivateAPI().TestSuitesMap)
endFunction

function AddScriptToTestSuite(string suiteName, SkyUnitTest script) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suite = api.GetTestSuite(suiteName)
    api.AddScriptToTestSuite(script, suite)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Run Tests
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

int function RunTestScript(string suiteName, SkyUnitTest script, string filter = "") global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    api.Debug("Run Test Script " + script + " for " + suiteName)
    int suite = api.GetTestSuite(suiteName)
    return api.RunTestScript(suite, script, filter)
endFunction

int function RunTestScriptByName(string suiteName, string script) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suite = api.GetTestSuite(suiteName)
    SkyUnitTest test = GetTestSuiteScript(suiteName, script)
    return api.RunTestScript(suite, test)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Getting Test Result Info
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

string[] function GetTestSuitescriptNames(string suiteName = "") global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    if ! suiteName
        suiteName = api.DEFAULT_TEST_SUITE_NAME
    endIf
    int suite = api.GetTestSuite(suiteName)
    int suiteScriptsMap = SkyUnit2PrivateAPI.GetPrivateAPI().GetTestSuiteScriptsMap(suite)
    return JMap.allKeysPArray(suiteScriptsMap)
endFunction

int function GetTestSuiteScriptCount(string suiteName = "") global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    if ! suiteName
        suiteName = api.DEFAULT_TEST_SUITE_NAME
    endIf
    int suite = api.GetTestSuite(suiteName)
    int suiteScriptsMap = SkyUnit2PrivateAPI.GetPrivateAPI().GetTestSuiteScriptsMap(suite)
    return JMap.count(suiteScriptsMap)
endFunction

SkyUnitTest function GetTestSuiteScript(string suiteName, string script) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suite = api.GetTestSuite(suiteName)
    int suiteScriptsMap = SkyUnit2PrivateAPI.GetPrivateAPI().GetTestSuiteScriptsMap(suite)
    int scriptMap = JMap.getObj(suiteScriptsMap, script)
    int index = JMap.getInt(scriptMap, "arrayLookupSlotNumber")
    return api.GetScriptFromSlot(index)
endFunction

int function GetScriptTestResultCount(string suiteName, SkyUnitTest script) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suite = api.GetTestSuite(suiteName)
    int runsMapForThisScript = api.GetTestSuiteScriptRunsMap(suite, script)
    int totalRunCount = JMap.count(runsMapForThisScript)
    if totalRunCount > 0
        return totalRunCount - 1 ; There is a special run map key which stores the latest run
    else
        return 0
    endIf
endFunction

string[] function GetScriptTestResultKeys(string suiteName, SkyUnitTest script) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suite = api.GetTestSuite(suiteName)
    int runsMapForThisScript = api.GetTestSuiteScriptRunsMap(suite, script)
    return JMap.allKeysPArray(runsMapForThisScript)
endFunction

int function GetLatestScriptTestResult(string suiteName, SkyUnitTest script) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suite = api.GetTestSuite(suiteName)
    int runsMapForThisScript = api.GetTestSuiteScriptRunsMap(suite, script)
    return JMap.getObj(runsMapForThisScript, SpecialTestRunDuration_LatestTest())
endFunction

string[] function ScriptTestResult_GetTestNames(int scriptTestsResult) global
    int testsMap = JMap.getObj(scriptTestsResult, "tests")
    return JMap.allKeysPArray(testsMap)
endFunction

string function ScriptTestResult_GetscriptNames(int scriptTestsResult) global
    return JMap.getStr(scriptTestsResult, "name")
endFunction

int function ScriptTestResult_GetTestResult(int scriptTestsResult, string testName) global
    int testsMap = JMap.getObj(scriptTestsResult, "tests")
    return JMap.getObj(testsMap, testName)
endFunction

string function ScriptTestResult_GetScriptStatus(int scriptTestsResult) global
    return JMap.getStr(scriptTestsResult, "status")
endFunction

bool function ScriptTestResult_GetScriptPassed(int scriptTestsResult) global
    return JMap.getStr(scriptTestsResult, "status") == TestStatus_PASS()
endFunction

string function TestResult_GetTestStatus(int testResult) global
    return JMap.getStr(testResult, "status")
endFunction

float function TestResult_GetTestRuntime(int testResult) global ; TODO TEST ME
    return JMap.getFlt(testResult, "durationTime")
endFunction

int function TestResult_GetExpectationCount(int testResult) global
    int expectations = JMap.getObj(testResult, "expectations")
    return JArray.count(expectations)
endFunction

string function TestResult_GetNthExpectationName(int testResult, int index) global
    int expectations = JMap.getObj(testResult, "expectations")
    int expectation = JArray.getObj(expectations, index)
    return JMap.getStr(expectation, "expectationName")
endFunction

string function TestResult_GetNthExpectationMainObjectType(int testResult, int index) global
    int expectations = JMap.getObj(testResult, "expectations")
    int expectation = JArray.getObj(expectations, index)
    int data = JMap.getObj(expectation, "data")
    int mainData = JMap.getObj(data, "main")
    return JMap.getStr(mainData, "type")
endFunction

string function TestResult_GetNthExpectationMainObjectText(int testResult, int index) global
    int expectations = JMap.getObj(testResult, "expectations")
    int expectation = JArray.getObj(expectations, index)
    int data = JMap.getObj(expectation, "data")
    int mainData = JMap.getObj(data, "main")
    return JMap.getStr(mainData, "text")
endFunction

bool function TestResult_GetNthExpectationPassed(int testResult, int index) global
    int expectations = JMap.getObj(testResult, "expectations")
    int expectation = JArray.getObj(expectations, index)
    return JMap.getInt(expectation, "failed") != 1
endFunction

string function TestResult_GetNthExpectationType(int testResult, int index) global
    int expectations = JMap.getObj(testResult, "expectations")
    int expectation = JArray.getObj(expectations, index)
    return JMap.getStr(expectation, "expectationName")
endFunction

string function TestResult_GetNthAssertionType(int testResult, int index) global
    int expectations = JMap.getObj(testResult, "expectations")
    int expectation = JArray.getObj(expectations, index)
    return JMap.getStr(expectation, "assertionName")
endFunction

string function TestResult_GetNthAssertionFailureMessage(int testResult, int index) global
    int expectations = JMap.getObj(testResult, "expectations")
    int expectation = JArray.getObj(expectations, index)
    return JMap.getStr(expectation, "failureMessage")
endFunction

string function TestResult_GetNthExpectationAssertionName(int testResult, int index) global
    int expectations = JMap.getObj(testResult, "expectations")
    int expectation = JArray.getObj(expectations, index)
    return JMap.getStr(expectation, "assertionName")
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Functions for Expectations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SkyUnitTest function CurrentTest() global
    return SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningTest
endFunction

bool function Not() global
    return SkyUnit2PrivateAPI.GetPrivateAPI().GetNotExpectation()
endFunction

function BeginExpectation(string expectationName) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    api.BeginExpectation(expectationName)
endFunction

bool function PassExpectation(string assertionName) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    api.PassExpectation(assertionName)
    return true
endFunction

bool function FailExpectation(string assertionName, string failureMessage) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    api.FailExpectation(assertionName, failureMessage)
    return false
endFunction

;; Data ~ "Main" Expectation data (and Text representation)

; TODO ---> This does GetFormFromFile 3x times, GetPrivateAPI() and then RE-USE IT plz :)

function SetExpectationData_MainObject_String(string value) global
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value", value)
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "type", "String")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "text", value)
endFunction

function SetExpectationData_MainObject_Bool(bool value) global
    if value
        JMap.setInt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value", 1)
    else
        JMap.setInt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value", 0)
    endIf
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "type", "Bool")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "text", value)
endFunction

function SetExpectationData_MainObject_Int(int value) global
    JMap.setInt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value", value)
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "type", "Int")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "text", value)
endFunction

function SetExpectationData_MainObject_Float(float value) global
    JMap.setFlt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value", value)
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "type", "Float")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "text", value)
endFunction

function SetExpectationData_MainObject_Form(Form value) global
    JMap.setForm(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value", value)
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "type", "Form")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "text", value)
endFunction

function SetExpectationData_MainObject_JObject(int objectID) global
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value", objectID)
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "type", "JObject")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "text", objectID)
endFunction

;; [ GETTERS ]

string function GetExpectationData_MainObject_Type() global
    return JMap.getStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "type")
endFunction

string function GetExpectationData_MainObject_Text() global
    return JMap.getStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "text")
endFunction

string function GetExpectationData_MainObject_String() global
    return JMap.getStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value")
endFunction

bool function GetExpectationData_MainObject_Bool() global
    return JMap.getInt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value") == 1
endFunction

int function GetExpectationData_MainObject_Int() global
    return JMap.getInt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value")
endFunction

float function GetExpectationData_MainObject_Float() global
    return JMap.getFlt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value")
endFunction

Form function GetExpectationData_MainObject_Form() global
    return JMap.getForm(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value")
endFunction

int function GetExpectationData_MainObject_JObject() global
    return JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value")
endFunction

;; ~ Arrays ~~

function SetExpectationData_MainObject_StringArray(string[] value) global
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "type", "StringArray")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "text", value)
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value", array)
    int i = 0
    while i < value.Length
        JArray.addStr(array, value[i])
        i += 1
    endWhile
endFunction

function SetExpectationData_MainObject_BoolArray(bool[] value) global
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "type", "BoolArray")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "text", value)
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value", array)
    int i = 0
    while i < value.Length
        JArray.addInt(array, value[i] as int)
        i += 1
    endWhile
endFunction

function SetExpectationData_MainObject_IntArray(int[] value) global
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "type", "IntArray")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "text", value)
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value", array)
    int i = 0
    while i < value.Length
        JArray.addInt(array, value[i])
        i += 1
    endWhile
endFunction

function SetExpectationData_MainObject_FloatArray(float[] value) global
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "type", "FloatArray")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "text", value)
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value", array)
    int i = 0
    while i < value.Length
        JArray.addFlt(array, value[i])
        i += 1
    endWhile
endFunction

function SetExpectationData_MainObject_FormArray(Form[] value) global
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "type", "FormArray")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "text", value)
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value", array)
    int i = 0
    while i < value.Length
        JArray.addForm(array, value[i])
        i += 1
    endWhile
endFunction

;; [ GETTERS ]

string[] function GetExpectationData_MainObject_StringArray() global
    return JArray.asStringArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value"))
endFunction

bool[] function GetExpectationData_MainObject_BoolArray() global
    int[] boolInts = JArray.asIntArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value"))
    bool[] bools = Utility.CreateBoolArray(boolInts.Length)
    int i = 0
    while i < boolInts.Length
        bools[i] = boolInts[i]
        i += 1
    endWhile
    return bools
endFunction

int[] function GetExpectationData_MainObject_IntArray() global
    return JArray.asIntArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value"))
endFunction

float[] function GetExpectationData_MainObject_FloatArray() global
    return JArray.asFloatArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value"))
endFunction

Form[] function GetExpectationData_MainObject_FormArray() global
    return JArray.asFormArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationMainDataMap, "value"))
endFunction

;; Data ~ "Custom" Expectation data (used for random things in assertions)

function SetExpectationData_String(string dataKey, string value) global
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey, value)
endFunction

function SetExpectationData_Int(string dataKey, int value) global
    JMap.setInt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey, value)
endFunction

function SetExpectationData_Float(string dataKey, float value) global
    JMap.setFlt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey, value)
endFunction

function SetExpectationData_Form(string dataKey, Form value) global
    JMap.setForm(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey, value)
endFunction

function SetExpectationData_JObject(string dataKey, int objectID) global
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey, objectID)
endFunction

; [ GETTERS ]

string function GetExpectationData_String(string dataKey) global
    return JMap.getStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey)
endFunction

int function GetExpectationData_Int(string dataKey) global
    return JMap.getInt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey)
endFunction

float function GetExpectationData_Float(string dataKey) global
    return JMap.getFlt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey)
endFunction

Form function GetExpectationData_Form(string dataKey) global
    return JMap.getForm(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey)
endFunction

int function GetExpectationData_JObject(string dataKey) global
    return JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey)
endFunction

;; ~ Arrays ~

function SetExpectationData_StringArray(string dataKey, string[] value) global
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey, array)
    int i = 0
    while i < value.Length
        JArray.addStr(array, value[i])
        i += 1
    endWhile
endFunction

function SetExpectationData_IntArray(string dataKey, int[] value) global
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey, array)
    int i = 0
    while i < value.Length
        JArray.addInt(array, value[i])
        i += 1
    endWhile
endFunction

function SetExpectationData_FloatArray(string dataKey, float[] value) global
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey, array)
    int i = 0
    while i < value.Length
        JArray.addFlt(array, value[i])
        i += 1
    endWhile
endFunction

function SetExpectationData_FormArray(string dataKey, Form[] value) global
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey, array)
    int i = 0
    while i < value.Length
        JArray.addForm(array, value[i])
        i += 1
    endWhile
endFunction

;; [ GETTERS ]

string[] function GetExpectationData_StringArray(string dataKey) global
    return JArray.asStringArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey))
endFunction

int[] function GetExpectationData_IntArray(string dataKey) global
    return JArray.asIntArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey))
endFunction

float[] function GetExpectationData_FloatArray(string dataKey) global
    return JArray.asFloatArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey))
endFunction

Form[] function GetExpectationData_FormArray(string dataKey) global
    return JArray.asFormArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationCustomDataMap, dataKey))
endFunction

;; Data ~ Assertion data (to store what was passed to an assertion)

function SetAssertionData_MainObject_String(string value) global
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value", value)
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "type", "String")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "text", value)
endFunction

function SetAssertionData_MainObject_Bool(bool value) global
    JMap.setInt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value", value as int)
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "type", "Bool")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "text", value)
endFunction

function SetAssertionData_MainObject_Int(int value) global
    JMap.setInt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value", value)
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "type", "Int")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "text", value)
endFunction

function SetAssertionData_MainObject_Float(float value) global
    JMap.setFlt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value", value)
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "type", "Float")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "text", value)
endFunction

function SetAssertionData_MainObject_Form(Form value) global
    JMap.setForm(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value", value)
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "type", "Form")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "text", value)
endFunction

function SetAssertionData_MainObject_JObject(int objectID) global
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value", objectID)
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "type", "JObject")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "text", objectID)
endFunction

;; [ GETTERS ]

string function GetAssertionData_MainObject_Type() global
    return JMap.getStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "type")
endFunction

string function GetAssertionData_MainObject_Text() global
    return JMap.getStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "text")
endFunction

string function GetAssertionData_MainObject_String() global
    return JMap.getStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value")
endFunction

bool function GetAssertionData_MainObject_Bool() global
    return JMap.getInt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value")
endFunction

int function GetAssertionData_MainObject_Int() global
    return JMap.getInt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value")
endFunction

float function GetAssertionData_MainObject_Float() global
    return JMap.getFlt(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value")
endFunction

Form function GetAssertionData_MainObject_Form() global
    return JMap.getForm(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value")
endFunction

int function GetAssertionData_MainObject_JObject() global
    return JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value")
endFunction

;; ~ Arrays ~~

function SetAssertionData_MainObject_StringArray(string[] value) global
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "type", "StringArray")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "text", value)
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value", array)
    int i = 0
    while i < value.Length
        JArray.addStr(array, value[i])
        i += 1
    endWhile
endFunction

function SetAssertionData_MainObject_BoolArray(bool[] value) global
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "type", "BoolArray")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "text", value)
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value", array)
    int i = 0
    while i < value.Length
        JArray.addInt(array, value[i] as int)
        i += 1
    endWhile
endFunction

function SetAssertionData_MainObject_IntArray(int[] value) global
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "type", "IntArray")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "text", value)
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value", array)
    int i = 0
    while i < value.Length
        JArray.addInt(array, value[i])
        i += 1
    endWhile
endFunction

function SetAssertionData_MainObject_FloatArray(float[] value) global
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "type", "FloatArray")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "text", value)
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value", array)
    int i = 0
    while i < value.Length
        JArray.addFlt(array, value[i])
        i += 1
    endWhile
endFunction

function SetAssertionData_MainObject_FormArray(Form[] value) global
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "type", "FormArray")
    JMap.setStr(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "text", value)
    int array = JArray.object()
    JMap.setObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value", array)
    int i = 0
    while i < value.Length
        JArray.addForm(array, value[i])
        i += 1
    endWhile
endFunction

;; [ GETTERS ]

string[] function GetAssertionData_MainObject_StringArray() global
    return JArray.asStringArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value"))
endFunction

bool[] function GetAssertionData_MainObject_BoolArray() global
    int[] boolInts = JArray.asIntArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value"))
    bool[] bools = Utility.CreateBoolArray(boolInts.Length)
    int i = 0
    while i < boolInts.Length
        bools[i] = boolInts[i]
        i += 1
    endWhile
    return bools
endFunction

int[] function GetAssertionData_MainObject_IntArray() global
    return JArray.asIntArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value"))
endFunction

float[] function GetAssertionData_MainObject_FloatArray() global
    return JArray.asFloatArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value"))
endFunction

Form[] function GetAssertionData_MainObject_FormArray() global
    return JArray.asFormArray(JMap.getObj(SkyUnit2PrivateAPI.GetPrivateAPI().CurrentlyRunningExpectationAssertionDataMap, "value"))
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Various "Enum" Values
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

string function TestStatus_PASS() global
    return "PASSED"
endFunction

string function TestStatus_FAIL() global
    return "FAILED"
endFunction

string function TestStatus_PENDING() global
    return "PENDING"
endFunction

string function TestStatus_SKIPPED() global
    return "SKIPPED"
endFunction

string function SpecialTestNameFor_BeforeAll() global
    return "[SkyUnit Test BeforeAll()]"
endFunction

string function SpecialTestNameFor_AfterAll() global
    return "[SkyUnit Test AfterAll()]"
endFunction

string function SpecialTestRunDuration_LatestTest() global
    return "[SkyUnit Latest Test Run]"
endFunction

string function DefaultTestSuite() global
    return SkyUnit2PrivateAPI.GetPrivateAPI().DEFAULT_TEST_SUITE_NAME
endFunction