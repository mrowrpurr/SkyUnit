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
