scriptName SkyUnitTests_BaseAssertionTest extends SkyUnitTests_BaseTest
{Test base with helpers for specifically testing expectations / assertions}

SkyUnitTests_ExampleForAssertionTests _exampleTestForAssertions

SkyUnitTests_ExampleForAssertionTests property ExampleTestForAssertions
    SkyUnitTests_ExampleForAssertionTests function get()
        if ! _exampleTestForAssertions
            _exampleTestForAssertions = Game.GetFormFromFile(0x801, "SkyUnitTests.esp") as SkyUnitTests_ExampleForAssertionTests
        endIf
        return _exampleTestForAssertions
    endFunction
endProperty

; Get you setup with an open test on an open script so you can make assertions:
function BeforeEach()
    parent.BeforeEach()
    ResetAssertionTests()
endFunction

function AfterEach()
    SwitchTo_Default_TestSuite()
    parent.AfterEach()
endFunction

function ResetAssertionTests()
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    int suiteID = api.GetTestSuite(FAKE_TEST_SUITE_NAME)
    api.RemoveScriptFromTestSuite(ExampleTestForAssertions, suiteID) ; Remove the script (and its test data etc)
    SkyUnit2.AddScriptToTestSuite(FAKE_TEST_SUITE_NAME, ExampleTestForAssertions) ; Re-add the script (new test data etc)
endFunction

string property CurrentFakeTestName auto
int property CurrentTestRunID auto

int function StartNewFakeTest(string name = "")
    if name
        name = name + "_" 
    endIf
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    CurrentFakeTestName = "FakeTest_" + name + Utility.RandomInt(1, 1000) + "_" + Utility.RandomInt(1, 1000)
    int suite = api.GetTestSuite(FAKE_TEST_SUITE_NAME)

    SwitchTo_Fake_TestSuite()
    CurrentTestRunID = api.BeginTestRun(suite, ExampleTestForAssertions)
    api.BeginTest(CurrentFakeTestName)
endFunction

function EndFakeTest()
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    SwitchTo_Fake_TestSuite()
    api.EndTest(fnCalled = true) ; Pretend that a Fn() was defined
endFunction

function SaveFakeTestResults(string filename = "", bool verbose = true)
    if ! filename
        filename = CurrentFakeTestName + ".json"
    endIf
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    ; By pass the lock (currently owned by the actually running test)
    SwitchTo_Fake_TestSuite()
    EndFakeTest()
    Debug.Trace("[SkyUnit Tests] Running Test Script to get its result...")
    SwitchTo_Default_TestSuite()
    JValue.writeToFile(CurrentTestRunID, filename)
    if verbose
        Debug.Trace("Wrote file " + filename)
        Debug.Notification("Wrote file " + filename)
    endIf
endFunction

function AssertExceptionFailed()
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    SwitchTo_Fake_TestSuite()
    bool failed = api.IsCurrentlyRunningExpectationFailed
    SwitchTo_Default_TestSuite()
    ExpectBool(failed).To(EqualBool(true), "Expected currently running exception to be failed")
endFunction

function AssertExceptionPassed()
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    SwitchTo_Fake_TestSuite()
    bool failed = api.IsCurrentlyRunningExpectationFailed
    SwitchTo_Default_TestSuite()
    ExpectBool(failed).To(EqualBool(false), "Expected currently running exception not to be failed")
endFunction
