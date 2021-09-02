scriptName SkyUnit2TestSuite extends Quest hidden
{Represents a suite of **SkyUnit** tests

Each test suite stores all of the `SkyUnitTest` scripts
associated with it and all of the results of test runs.

To add tests to a test suite, simply define a `SkyUnitTest`
and it will be automatically added to the default test suite.

Usually you will not need to configure multiple test suites
yourself, this is done by the **SkyUnit** test runner tools for you.

See `SkyUnitTest` for more information.
}

int _suiteID

int function GetSuiteID()
    return _suiteID
endFunction

function SetSuiteID(int suiteID)
    _suiteID = suiteID
endFunction

string function GetName()
    ; Override default GetName()
    return GetSuiteName()
endFunction

string function GetSuiteName()
    return JMap.getStr(_suiteID, "name")
endFunction

SkyUnit2TestSuite function GetForID(int suiteID) global
    SkyUnit2TestSuite testSuite = Game.GetFormFromFile(0x800, "SkyUnit2.esp") as SkyUnit2TestSuite
    testSuite.SetSuiteID(suiteID)
    return testSuite
endFunction


