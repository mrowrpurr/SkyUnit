scriptName SkyUnitTest extends Quest hidden
{Extend this script to create SkyUnit tests.}

; ~ Do not override ~
;
; Initializes this SkyUnit test.
;
; If you must override this, please be sure to call parent.OnInit()
event OnInit()
    SkyUnitPrivateAPI.RegisterTestSuite(self)
endEvent

; Override the `Tests()` function to define your test cases
;
; Example:
;
; ```
;   scriptName MyTests extend SkyUnitTest
;
;   function Tests()
;       ; Tests without .Fn() functions are considered "pending".
;       ; This can be useful for tracking a TODO list of tests to write.
;       Test("Pending test")
;
;       Test("My passing test").Fn(PassingTest())
;   endFunction
;
;   function PassingTest()
;       ExpectString("Hello").To(EqualString("Hello"))
;   endFunction
; ```
function Tests()
endFunction

; Defines a test in this test suite
;
; Example:
;
; ```
;   scriptName MyTests extend SkyUnitTest
;
;   function Tests()
;       ; Tests without .Fn() functions are considered "pending".
;       ; This can be useful for tracking a TODO list of tests to write.
;       Test("Pending test")
;
;       Test("My passing test").Fn(PassingTest())
;   endFunction
;
;   function PassingTest()
;       ExpectString("Hello").To(EqualString("Hello"))
;   endFunction
; ```
SkyUnitTest function Test(string testName)
    SkyUnitPrivateAPI.Test_BeginTestRun(SkyUnitPrivateAPI.ScriptDisplayName(self), testName)
    return self
endFunction

; Usage: call your test function inside of the `Fn()` parameter
;
; Example:
;
; ```
;   scriptName MyTests extend SkyUnitTest
;
;   function Tests()
;       ; Note the that function passed to Fn()
;       ; must be invoked using () parenthesis:
;       Test("My passing test").Fn(PassingTest())
;   endFunction
;
;   function PassingTest()
;       ExpectString("Hello").To(EqualString("Hello"))
;   endFunction
; ```
function Fn(bool testFunction)
    SkyUnitPrivateAPI.Fn_EndTestRun()
endFunction

; Marks this as a "not" assertion, e.g. `ExpectString("").Not().To(EqualString(""))`
SkyUnitTest function Not()
    SkyUnitExpectation.ToggleNotExpectation()
    return self
endFunction

; Provide an assertion, e.g. `ExpectString("").To(EqualString(""))`
function To(bool assertionFunction)
endFunction

; TODO
; TODO
; TODO
; TODO
function BeforeAll()
endFunction
function AfterAll()
endFunction
function BeforeEach()
endFunction
function AfterEach()
endFunction
; TODO
; TODO
; TODO
; TODO

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simple Assert() and Fail()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Simplest assertion.
; If the provided expression does not evaluate to true, this will fail.
function Assert(bool actual, string failureMessage = "")
    if actual
        Pass()
    else
        Fail(failureMessage)
    endIf
endFunction

; Fails the current test with the provided message.
; The failure message will be shown in the test results.
function Fail(string failureMessage)
    SkyUnitExpectation.BeginExpectation("Fail")
    SkyUnitExpectation.Fail("Fail", failureMessage)
endFunction

; Pass the current test (unless test has any failing expectations)
function Pass()
    SkyUnitExpectation.BeginExpectation("Pass")
    SkyUnitExpectation.Pass("Pass")
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expectation Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function ExpectString(string actual)
    SkyUnitExpectation.SetPrimaryDataType("String")
    SkyUnitExpectation.SetPrimaryDataText(actual)
    SkyUnitExpectation.SetString("_data", actual)
endFunction

function ExpectInt(int actual)
    SkyUnitExpectation.SetPrimaryDataType("Int")
    SkyUnitExpectation.SetPrimaryDataText(actual)
    SkyUnitExpectation.SetInt("_data", actual)
endFunction

function ExpectFloat(float actual)
    SkyUnitExpectation.SetPrimaryDataType("Float")
    SkyUnitExpectation.SetPrimaryDataText(actual)
    SkyUnitExpectation.SetFloat("_data", actual)
endFunction

function ExpectForm(Form actual)
    SkyUnitExpectation.SetPrimaryDataType("Form")
    SkyUnitExpectation.SetPrimaryDataText(actual)
    SkyUnitExpectation.SetForm("_data", actual)
endFunction

function ExpectBool(bool actual)
    SkyUnitExpectation.SetPrimaryDataType("Bool")
    SkyUnitExpectation.SetPrimaryDataText(actual)
    SkyUnitExpectation.SetBool("_data", actual)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Assertion Functions - Equal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function EqualString(string expected)
    string actual
    if SkyUnitExpectation.GetPrimaryDataType() == "String"
        actual = SkyUnitExpectation.GetString("_data")
    else
        actual = SkyUnitExpectation.GetString("_text")
    endIf
    bool not = SkyUnitExpectation.Not()

endFunction
