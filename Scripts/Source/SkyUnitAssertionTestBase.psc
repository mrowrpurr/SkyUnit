scriptName SkyUnitAssertionTestBase extends SkyUnitTest
{Extend this script if you want to write tests for
your own custom SkyUnit expectations/assertions!

The way it works is:
When you want to run an assertion and get its result, e.g. failure message,
you temporarily switch SkyUnit over to use a "fake" backend which is where
it stores tests/test results/etc.

You start a fake test suite, add a fake test, and add fake assertions to it.
Assertions will be executed right away and there are helpers here to get their results.

[TODO ADD EXAMPLES]
}

string _currentTestScriptName

function BeforeEach()
    _currentTestScriptName = ""
endFunction

function AfterEach()
    SwitchToContext_Real()
endFunction

; Switches to a "fake" test context.
; This will create the test suite if it does not already exist.
; Use this to create fake test suites and tests to run your assertions.
;
; See the documentation on SkyUnitAssertionTestBase for example usage.
function SwitchToContext_Fake()
    if ! SkyUnitAPI.ContextExists("fake")
        SkyUnitAPI.CreateContext("fake")
    endIf
    SkyUnitAPI.SwitchToContext("fake")
endFunction

; Switches back to the "real" test context.
; The one that's actually running your tests!
function SwitchToContext_Real()
    SkyUnitAPI.SwitchToContext("default")
endFunction

; Begin a test suite. This registers a name with no associated script (for testing).
; If you want this to be fake, be sure to SwitchToContext_Fake() first.
function CreateTestSuite(string testScriptName)
    _currentTestScriptName = testScriptName
    SkyUnitAPI.RegisterTestSuite(None, _currentTestScriptName)
endFunction

; Begin a test suite. This registers an actual script.
; If you want this to be fake, be sure to SwitchToContext_Fake() first.
function CreateTestSuiteForScript(SkyUnitTest testScript)
    _currentTestScriptName = SkyUnitAPI.ScriptDisplayName(testScript)
    SkyUnitAPI.RegisterTestSuite(testScript)
endFunction

; Begin a test for test suite created using CreateTestSuite().
; If you want this to be fake, be sure to SwitchToContext_Fake() first.
function CreateTest(string testName)
    SkyUnitAPI.Test_BeginTestRun(_currentTestScriptName, testName)
endFunction

; End the current test.
; Should only be called after using CreateTest().
; If you want this to be fake, be sure to SwitchToContext_Fake() first.
function EndTest()
    SkyUnitAPI.Fn_EndTestRun()
endFunction

; Sets up a new fake test.
; If no suite has been used yet for this test, a new one is created.
; This does not require SwitchToContext_Fake(), it automatically creates the test in the fake context.
function SetupFakeTest(string testName = "")
    string currentContext = SkyUnitAPI.CurrentContext()
    SwitchToContext_Fake()
    if ! _currentTestScriptName
        CreateTestSuite("FakeTestScriptName")
    endIf
    if ! testName
        testName = "FakeTest_" + Utility.RandomInt(1, 10000) + "_" + Utility.RandomInt(1, 10000)
    endIf
    CreateTest(testName)
    SkyUnitAPI.SwitchToContext(currentContext)
endFunction

; Same as SetupFakeTest() except it also begins an expectation.
; This will always setup a new test.
; It will only setup a new test suite if one is not already setup.
; This does not require SwitchToContext_Fake(), it automatically creates the test in the fake context.
function SetupFakeExpectation(string testName = "")
    string currentContext = SkyUnitAPI.CurrentContext()
    SwitchToContext_Fake()
    if ! _currentTestScriptName
        CreateTestSuite("FakeTestScriptName")
    endIf
    if ! testName
        testName = "FakeTest_" + Utility.RandomInt(1, 10000) + "_" + Utility.RandomInt(1, 10000)
    endIf
    CreateTest(testName)
    SkyUnitAPI.BeginExpectation()
    SkyUnitAPI.SwitchToContext(currentContext)
endFunction
