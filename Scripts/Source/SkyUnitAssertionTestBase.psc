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

function AfterEach()
    SwitchToSuite_Real()
endFunction

SkyUnitTest _currentTestScript

; Switches to a "fake" test suite.
; This will create the test suite if it does not already exist.
; Use this to create fake test suites and tests to run your assertions.
;
; See the documentation on SkyUnitAssertionTestBase for example usage.
function SwitchToSuite_Fake()
    if ! SkyUnitAPI.ContextExists("fake")
        SkyUnitAPI.CreateContext("fake")
    endIf
    SkyUnitAPI.SwitchToContext("fake")
endFunction

; Switches back to the "real" test suite.
; The one that's actually running your tests!
function SwitchToSuite_Real()
    SkyUnitAPI.SwitchToContext("default")
endFunction

; Begin a test suite.
; If you want this to be fake, be sure to SwitchToSuite_Fake() first.
function CreateTestSuite(SkyUnitTest testScript)
    _currentTestScript = testScript
    SkyUnitAPI.RegisterTestSuite(_currentTestScript)
endFunction

; Begin a test for test suite created using CreateTestSuite().
; If you want this to be fake, be sure to SwitchToSuite_Fake() first.
function CreateTest(string testName)
    SkyUnitAPI.Test_BeginTestRun(_currentTestScript, testName)
endFunction

; End the current test.
; Should only be called after using CreateTest().
; If you want this to be fake, be sure to SwitchToSuite_Fake() first.
function EndTest()
    SkyUnitAPI.Fn_EndTestRun()
endFunction
