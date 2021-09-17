scriptName SkyUnitTest extends Quest hidden
{Extend this script to create SkyUnit tests.}

; ~ Do not override ~
;
; Initializes this SkyUnit test.
;
; If you must override this, please be sure to call parent.OnInit()
event OnInit()
    SkyUnitAPI.RegisterTestSuite(self)
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
    SkyUnitAPI.Test_BeginTestRun(SkyUnitAPI.ScriptDisplayName(self), testName)
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
    SkyUnitAPI.Fn_EndTestRun()
endFunction

; Marks this as a "not" assertion, e.g. `ExpectString("").Not.To(EqualString(""))`
SkyUnitTest property Not
    SkyUnitTest function get()
        SkyUnitAPI.SetExpectationAsNotExpectation()
        return self
    endFunction
endProperty

; Provide an assertion, e.g. `ExpectString("").To(EqualString(""))`
function To(bool assertionFunction)
endFunction

function BeforeAll()
endFunction

function AfterAll()
endFunction

function BeforeEach()
endFunction

function AfterEach()
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simple Assert() and Fail()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Simplest assertion.
; If the provided expression does not evaluate to true, this will fail.
function Assert(bool actual, string failureMessage = "")
    if ! actual
        Fail(failureMessage)
    endIf
endFunction

; Fails the current test with the provided message.
; The failure message will be shown in the test results.
function Fail(string failureMessage)
    SkyUnitAPI.BeginExpectation()
    SkyUnitAPI.FailExpectation(failureMessage)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expectation Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Assertion Functions - Equal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
