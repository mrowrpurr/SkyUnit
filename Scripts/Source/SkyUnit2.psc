scriptName SkyUnit2
{Global interface for integrating with SkyUnit.

For writing tests, please see SkyUnitTest.

To access functionality, use SkyUnit.DefaultTestSuite()
which will give you back a SkyUnit test suite instance with all
of the lovely functions you want for interacting with test suites!

Note: there can be multiple SkyUnit test suites at the same
time. Each stores its own test suite, e.g. SkyUniTest scripts etc.
To get an existing or new instance, see these functions:

  SkyUnitTestSuite testSuite = SkyUnit.CreateTestSuite("<name your test suite>")
  SkyUnitTestSuite testSuite = SkyUnit.GetTestSuite("<name of test suite>")
}

float function GetVersion() global
    return 1.0
endFunction

SkyUnit2Test function CurrentTest() global
    return SkyUnit2PrivateAPI.GetPrivateAPI().CurrrentlyRunningTest
endFunction

function CreateTestSuite(string suiteName) global
    SkyUnit2PrivateAPI.GetPrivateAPI().CreateTestSuite(suiteName)
endFunction

function DeleteTestSuite(string suiteName) global
    SkyUnit2PrivateAPI.GetPrivateAPI().DeleteTestSuite(suiteName)
endFunction

int function GetTestSuiteCount() global
    return JMap.count(SkyUnit2PrivateAPI.GetPrivateAPI().TestSuitesMap)
endFunction

string[] function GetTestSuiteNames() global
    return JMap.allKeysPArray(SkyUnit2PrivateAPI.GetPrivateAPI().TestSuitesMap)
endFunction

function AddScriptToTestSuite(string suiteName, SkyUnit2Test script) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suite = api.GetTestSuite(suiteName)
    api.AddScriptToTestSuite(script, suite)
endFunction

string[] function GetTestSuiteScriptNames(string suiteName) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suite = api.GetTestSuite(suiteName)
    int suiteScriptsMap = SkyUnit2PrivateAPI.GetPrivateAPI().GetTestSuiteScriptsMap(suite)
    return JMap.allKeysPArray(suiteScriptsMap)
endFunction

SkyUnit2Test function GetTestSuiteScript(string suiteName, string script) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suite = api.GetTestSuite(suiteName)
    int suiteScriptsMap = SkyUnit2PrivateAPI.GetPrivateAPI().GetTestSuiteScriptsMap(suite)
    int scriptMap = JMap.getObj(suiteScriptsMap, script)
    int index = JMap.getInt(scriptMap, "arrayLookupSlotNumber")
    return api.GetScriptFromSlot(index)
endFunction

int function RunTestScript(string suiteName, SkyUnit2Test script) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suite = api.GetTestSuite(suiteName)
    return api.RunTestScript(suite, script)
endFunction

int function GetTestResultCount(string suiteName, SkyUnit2Test script) global
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

string[] function GetTestResultKeys(string suiteName, SkyUnit2Test script) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suite = api.GetTestSuite(suiteName)
    int runsMapForThisScript = api.GetTestSuiteScriptRunsMap(suite, script)
    return JMap.allKeysPArray(runsMapForThisScript)
endFunction

int function GetTestResult(string suiteName, SkyUnit2Test script, string resultKey) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suite = api.GetTestSuite(suiteName)
    int runsMapForThisScript = api.GetTestSuiteScriptRunsMap(suite, script)
    return JMap.getObj(runsMapForThisScript, resultKey)
endFunction

int function GetLatestTestResult(string suiteName, SkyUnit2Test script) global
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suite = api.GetTestSuite(suiteName)
    int runsMapForThisScript = api.GetTestSuiteScriptRunsMap(suite, script)
    return JMap.getObj(runsMapForThisScript, SpecialTestRunDuration_LatestTest())
endFunction

string[] function TestResult_GetTestNames(int testResult) global
    int testsMap = JMap.getObj(testResult, "tests")
    return JMap.allKeysPArray(testsMap)
endFunction

string function TestResult_GetTestStatus(int testResult, string testName) global

endFunction

float function TestResult_GetTestRuntime(int testResult, string testName) global
    return 123.456 ; TODO
endFunction

int function TestResult_GetTestExpectationCount(int testResult, string testName) global

endFunction

string function TestResult_GetNthTestExpectationType(int testResult, string testName, int index) global

endFunction

string function TestResult_GetNthTestExpectationResult(int testResult, string testName, int index) global

endFunction

string function TestResult_GetNthTestExpectationMessage(int testResult, string testName, int index) global

endFunction

string function TestStatus_PASS() global
    return "PASS"
endFunction

string function TestStatus_FAIL() global
    return "FAIL"
endFunction

string function TestStatus_PENDING() global
    return "PENDING"
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