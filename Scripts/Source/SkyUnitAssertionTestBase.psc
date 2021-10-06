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

Actor _player
Actor property Player
    Actor function get()
        if ! _player
            _player = Game.GetPlayer()
        endIf
        return _player
    endFunction
endProperty

string _currentTestScriptName

string property CurrentFakeTestName auto
int    property CurrentFakeExpectationId auto
bool   property CurrentFakeExpectationResult auto

; Helper alias for CurrentFakeExpectationId
int property ExpectationID
    int function get()
        return CurrentFakeExpectationId
    endFunction
endProperty

function BeforeEach()
    _currentTestScriptName = ""
    CurrentFakeTestName = SetupFakeTest()
endFunction

function AfterEach()
    CurrentFakeTestName = ""
    CurrentFakeExpectationId = 0
    CurrentFakeExpectationResult = false
    SwitchToContext_Real()
endFunction

; Switches to a "fake" test context.
; This will create the test suite if it does not already exist.
; Use this to create fake test suites and tests to run your assertions.
;
; See the documentation on SkyUnitAssertionTestBase for example usage.
function SwitchToContext_Fake()
    if ! SkyUnitPrivateAPI.ContextExists("fake")
        SkyUnitPrivateAPI.CreateContext("fake")
    endIf
    SkyUnitPrivateAPI.SwitchToContext("fake")
endFunction

; Switches back to the "real" test context.
; The one that's actually running your tests!
function SwitchToContext_Real()
    SkyUnitPrivateAPI.SwitchToContext("default")
endFunction

; Begin a test suite. This registers a name with no associated script (for testing).
; If you want this to be fake, be sure to SwitchToContext_Fake() first.
function CreateTestSuite(string testScriptName)
    _currentTestScriptName = testScriptName
    ;;
    ;; TODO FIX THIS
    ;;;
    ; SkyUnitPrivateAPI.RegisterTestSuite(None, _currentTestScriptName)
    SkyUnitPrivateAPI.RegisterTestSuite(SkyUnitTestExamples.GetExampleTest1(), _currentTestScriptName)
endFunction

; Begin a test suite. This registers an actual script.
; If you want this to be fake, be sure to SwitchToContext_Fake() first.
function CreateTestSuiteForScript(SkyUnitTest testScript)
    _currentTestScriptName = SkyUnitPrivateAPI.ScriptDisplayName(testScript)
    SkyUnitPrivateAPI.RegisterTestSuite(testScript)
endFunction

; Begin a test for test suite created using CreateTestSuite().
; If you want this to be fake, be sure to SwitchToContext_Fake() first.
function CreateTest(string testName)
    SkyUnitPrivateAPI.Test_BeginTestRun(_currentTestScriptName, testName)
endFunction

; End the current test.
; Should only be called after using CreateTest().
; If you want this to be fake, be sure to SwitchToContext_Fake() first.
function EndTest()
    SkyUnitPrivateAPI.Fn_EndTestRun()
endFunction

; Sets up a new fake test.
; If no suite has been used yet for this test, a new one is created.
; This does not require SwitchToContext_Fake(), it automatically creates the test in the fake context.
string function SetupFakeTest(string testName = "")
    string currentContext = SkyUnitPrivateAPI.CurrentContext()
    SwitchToContext_Fake()
    if ! _currentTestScriptName
        ; CreateTestSuite("FakeTestScriptName") ; TODO get rid of being able to pass no script!
        CreateTestSuiteForScript(SkyUnitTestExamples.GetExampleTest1())
    endIf
    if ! testName
        testName = "FakeTest_" + Utility.RandomInt(1, 10000) + "_" + Utility.RandomInt(1, 10000)
    endIf
    CreateTest(testName)
    SkyUnitPrivateAPI.SwitchToContext(currentContext)
    return testName
endFunction

; Same as SetupFakeTest() except it also begins an expectation.
; This will always setup a new test.
; It will only setup a new test suite if one is not already setup.
; This does not require SwitchToContext_Fake(), it automatically creates the test in the fake context.
function SetupFakeExpectation(string testName = "")
    string currentContext = SkyUnitPrivateAPI.CurrentContext()
    SwitchToContext_Fake()
    if ! _currentTestScriptName
        CreateTestSuite("FakeTestScriptName")
    endIf
    if ! testName
        testName = "FakeTest_" + Utility.RandomInt(1, 10000) + "_" + Utility.RandomInt(1, 10000)
    endIf
    CreateTest(testName)
    SkyUnitExpectation.BeginExpectation("MyExpectation")
    SkyUnitPrivateAPI.SwitchToContext(currentContext)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expectation Testing DSL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Switches to the Fake context and returns self. Used for testing DSL: `TestExpectation.Define( ExpectX().To(Y()) )
SkyUnitAssertionTestBase function ExpectExpectation()
    SwitchToContext_Fake()
    return self 
endFunction

; For DSL: `TestExpectation.Define( ExpectX().To(Y()) )
; Automatically switches to Fake context and then switches back
function ToPass(bool expectationResult)
    CurrentFakeExpectationResult = expectationResult
    CurrentFakeExpectationId = SkyUnitExpectation.LatestExpectationID()
    SwitchToContext_Real()
    ExpectBool(expectationResult).To(BeTrue(), "Expected expectation to pass: " + SkyUnitExpectation.GetDescription(CurrentFakeExpectationId) + " Failure message: " + SkyUnitExpectation.GetFailureMessage(CurrentFakeExpectationId))
    ExpectString(SkyUnitExpectation.GetStatus(CurrentFakeExpectationId)).To(EqualString("PASSING"))
    Assert(SkyUnitExpectation.GetFailureMessage(CurrentFakeExpectationId) == "", "Expected failure message to be empty but was: " + SkyUnitExpectation.GetFailureMessage(CurrentFakeExpectationId))
endFunction

; For DSL: `TestExpectation.Define( ExpectX().To(Y()) )
; Automatically switches to Fake context and then switches back
function ToFail(bool expectationResult)
    CurrentFakeExpectationResult = expectationResult
    CurrentFakeExpectationId = SkyUnitExpectation.LatestExpectationID()
    SwitchToContext_Real()
    ExpectBool(expectationResult).To(BeFalse(), "Expected expectation to fail: " + SkyUnitExpectation.GetDescription(CurrentFakeExpectationId))
    ExpectString(SkyUnitExpectation.GetStatus(CurrentFakeExpectationId)).To(EqualString("FAILING"))
endFunction

function ExpectFailureMessage(string expectedFailureMessage)
    Expect(SkyUnitExpectation.GetFailureMessage(CurrentFakeExpectationId)).To(Equal(expectedFailureMessage))
endFunction

; Update to ContainText
function ExpectFailureMessageContains(string expectedFailureMessageText)
    Assert(StringUtil.Find(SkyUnitExpectation.GetFailureMessage(CurrentFakeExpectationId), expectedFailureMessageText) > -1, "Expected failure message to contain text '" + expectedFailureMessageText + "' but was: " + SkyUnitExpectation.GetFailureMessage(CurrentFakeExpectationId))
endFunction

function ExpectDescription(string expectedDescription)
    Expect(SkyUnitExpectation.GetDescription(CurrentFakeExpectationId)).To(Equal(expectedDescription))
endFunction

; Update to ContainText
function ExpectDescriptionContains(string expectedDescriptionText)
    Assert(StringUtil.Find(SkyUnitExpectation.GetDescription(CurrentFakeExpectationId), expectedDescriptionText) > -1, "Expected expectation desription to contain text '" + expectedDescriptionText+ "' but was: " + SkyUnitExpectation.GetDescription(CurrentFakeExpectationId))
endFunction

function ExpectActual(string type, string text)
    Expect(SkyUnitExpectation.GetActualType(ExpectationID)).To(Equal(type))
    Expect(SkyUnitExpectation.GetActualText(ExpectationID)).To(Equal(text))
endFunction

function ExpectExpected(string type, string text)
    Expect(SkyUnitExpectation.GetExpectedType(ExpectationID)).To(Equal(type))
    Expect(SkyUnitExpectation.GetExpectedText(ExpectationID)).To(Equal(text))
endFunction