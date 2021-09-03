scriptName SkyUnit2TestSuite extends Quest hidden
{Represents a suite of **SkyUnit** tests

Each test suite stores all of the `SkyUnit2Test` scripts
associated with it and all of the results of test runs.

To add tests to a test suite, simply define a `SkyUnit2Test`
and it will be automatically added to the default test suite.

Usually you will not need to configure multiple test suites
yourself, this is done by the **SkyUnit** test runner tools for you.

See `SkyUnit2Test` for more information.
}

int _suiteID

int function GetSuiteID()
    return _suiteID
endFunction

function SetSuiteID(int suiteID)
    _suiteID = suiteID
endFunction

string function GetName()
    ; Overrides SKSE Form.GetName()
    return JMap.getStr(_suiteID, "name")
endFunction

SkyUnit2TestSuite function GetForID(int suiteID) global
    SkyUnit2TestSuite testSuite = Game.GetFormFromFile(0x800, "SkyUnit2.esp") as SkyUnit2TestSuite
    testSuite.SetSuiteID(suiteID)
    return testSuite
endFunction

function AddScript(SkyUnit2Test script)
    Debug.Trace("~ [Sky Unit 2] ~ Adding Script ..." + " and the API is: " + SkyUnit2PrivateAPI.GetPrivateAPI())
    SkyUnit2PrivateAPI.GetPrivateAPI().AddScriptToTestSuite(script, _suiteID)
endFunction

int property ScriptCount
    int function get()
        return JMap.count(SkyUnit2PrivateAPI.GetPrivateAPI().GetTestSuiteScriptsMap(_suiteID))
    endFunction
endProperty

string[] property ScriptNames
    string[] function get()
        return JMap.allKeysPArray(SkyUnit2PrivateAPI.GetPrivateAPI().GetTestSuiteScriptsMap(_suiteID))
    endFunction
endProperty
