scriptName SkyUnitTest extends Quest
{Base script for all SkyUnit test scripts.

e.g.
  scriptName MyCoolTest extends SkyUnitTest
  
  function Tests()
    Test("Pending test")
    Test("Passing test").Fn(PassingTest())
    Test("Failing test").Fn(FailingTest())
  endFunction

  function BeforeEach()
    ; This code runs before each test
    ; These functions are all available:
    ;    BeforeEach()
    ;    AfterEach()
    ;    BeforeAll()
    ;    AfterAll()
  endFunction

  function FailingTest()
    ExpectInt(42).To(EqualInt(12345))
  endFunction

  function PassingTest()
    ExpectString("Hello").To(ContainText("H"))
  endFunction
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Register self on init
;;
;; This will register with the default
;; test suite.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

event OnInit()
    SkyUnit2PrivateAPi api = SkyUnit2PrivateAPI.GetPrivateAPI()
    if api.CurrentTestSuiteID
        api.AddScriptToTestSuite(self, api.CurrentTestSuiteID)
    endIf
endEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Functions meant to be overridden
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function Tests()
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
;; Main Interface for Tests
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SkyUnitTest function Test(string testName)
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()

    ; If filter provided but this test doesn't match it, return (Fn() will not run)
    if api.CurrentTestRunFilter && StringUtil.Find(testName, api.CurrentTestRunFilter) == -1
        api.Debug("Skipping test " + testName + " (filter: \"" + api.CurrentTestRunFilter + "\")")
        return None
    endIf

    api.BeginTest(testName)
    BeforeEach()
    return self
endFunction

function Fn(bool testFunction)
    SkyUnit2PrivateAPI.GetPrivateAPI().EndTest(fnCalled = true)
endFunction

SkyUnitTest function Not()
    SkyUnit2PrivateAPI.GetPrivateAPI().SetNotExpectation()
    return self
endFunction

SkyUnitTest function To(bool expectationFunction, string failureMessage = "")
    ; TODO Save the result of the expectation function :)
    SkyUnit2PrivateAPI.GetPrivateAPI().SetCustomFailureMessage(failureMessage)
    return self
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Base included Expect[Type]() functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SkyUnitTest function ExpectString(string value)
    SkyUnit2.BeginExpectation("ExpectString")
    SkyUnit2.SetExpectationData_MainObject_String(value)
    return self
endFunction

SkyUnitTest function ExpectInt(int value)
    SkyUnit2.BeginExpectation("ExpectInt")
    SkyUnit2.SetExpectationData_MainObject_Int(value)
    return self
endFunction

SkyUnitTest function ExpectBool(bool value)
    SkyUnit2.BeginExpectation("ExpectBool")
    SkyUnit2.SetExpectationData_MainObject_Bool(value)
    return self
endFunction

SkyUnitTest function ExpectFloat(float value)
    SkyUnit2.BeginExpectation("ExpectFloat")
    SkyUnit2.SetExpectationData_MainObject_Float(value)
    return self
endFunction

SkyUnitTest function ExpectForm(Form value)
    SkyUnit2.BeginExpectation("ExpectForm")
    SkyUnit2.SetExpectationData_MainObject_Form(value)
    return self
endFunction

; TODO
; function Log(string text)
; endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Base included Assertion Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; UPDATE THESE TO RETURN BOOLS!

bool function EqualString(string expected)
    SkyUnit2.SetAssertionData_MainObject_String(expected)
    string actual = SkyUnit2.GetExpectationData_MainObject_Text()
    if SkyUnit2.GetExpectationData_MainObject_Type() == "String"
        actual = SkyUnit2.GetExpectationData_MainObject_String()
    endIf
    bool not = SkyUnit2.Not()
    if not && actual == expected
        return SkyUnit2.FailExpectation("EqualString", "Expected '" + actual + "' not to equal '" + expected + "'")
    elseIf ! not && actual != expected
        return SkyUnit2.FailExpectation("EqualString", "Expected '" + actual + "' to equal '" + expected + "'")
    endIf
    return SkyUnit2.PassExpectation("EqualString")
endFunction

function EqualInt(int expected)
    SkyUnit2.SetAssertionData_MainObject_Int(expected)
    int actual = SkyUnit2.GetExpectationData_MainObject_Int()
    bool not = SkyUnit2.Not()
    if not && actual == expected
        SkyUnit2.FailExpectation("EqualInt", "Expected " + actual + " not to equal " + expected)
        return
    elseIf ! not && actual != expected
        SkyUnit2.FailExpectation("EqualInt", "Expected " + actual + " to equal " + expected)
        return
    endIf
    SkyUnit2.PassExpectation("EqualInt")
endFunction

function EqualBool(bool expected)
    SkyUnit2.SetAssertionData_MainObject_Bool(expected)
    bool actual = SkyUnit2.GetExpectationData_MainObject_Bool()
    bool not = SkyUnit2.Not()
    if not && actual == expected
        SkyUnit2.FailExpectation("EqualBool", "Expected " + actual + " not to equal " + expected)
        return
    elseIf ! not && actual != expected
        SkyUnit2.FailExpectation("EqualBool", "Expected " + actual + " to equal " + expected)
        return
    endIf
    SkyUnit2.PassExpectation("EqualBool")
endFunction

function EqualFloat(float expected)
    SkyUnit2.SetAssertionData_MainObject_Float(expected)
    float actual = SkyUnit2.GetExpectationData_MainObject_Text() as float
    bool not = SkyUnit2.Not()
    if not && actual == expected
        SkyUnit2.FailExpectation("EqualFloat", "Expected " + actual + " not to equal " + expected)
        return
    elseIf ! not && actual != expected
        SkyUnit2.FailExpectation("EqualFloat", "Expected " + actual + " to equal " + expected)
        return
    endIf
    SkyUnit2.PassExpectation("EqualFloat")
endFunction

function EqualForm(Form expected)
    SkyUnit2.SetAssertionData_MainObject_Form(expected)
    Form actual = SkyUnit2.GetExpectationData_MainObject_Form()
    string expectedName
    if expected
        expectedName = expected.GetName() + " " + expected
    else
        expectedName = "None"
    endIF
    string actualName
    if actual
        actualName = actual.GetName() + " " + actual
    else
        actualName = "None"
    endIF
    bool not = SkyUnit2.Not()
    if not && actual == expected
        SkyUnit2.FailExpectation("EqualForm", "Expected " + actualName + " not to equal " + expectedName)
        return
    elseIf ! not && actual != expected
        SkyUnit2.FailExpectation("EqualForm", "Expected " + actualName + " to equal " + expectedName)
        return
    endIf
    SkyUnit2.PassExpectation("EqualForm")
endFunction

function ContainText(string expect)
    SkyUnit2.SetAssertionData_MainObject_String(expect)
    string actual = SkyUnit2.GetExpectationData_MainObject_Text()
    bool not = SkyUnit2.Not()
    if not && StringUtil.Find(actual, expect) > -1
        SkyUnit2.FailExpectation("ContainText", "Expected '" + actual + "' not to contain text '" + expect + "'")
        return
    elseIf ! not && StringUtil.Find(actual, expect) == -1
        SkyUnit2.FailExpectation("ContainText", "Expected '" + actual + "' to contain text '" + expect + "'")
        return
    endIf
    SkyUnit2.PassExpectation("ContainText")
endFunction

bool function BeEmpty()
    string actual = SkyUnit2.GetExpectationData_MainObject_Text()
    bool not = SkyUnit2.Not()
    string type = SkyUnit2.GetExpectationData_MainObject_Type()
    bool isEmpty = ! actual
    if StringUtil.Find(type, "Array") > -1
        isEmpty = actual == "[]"
    endIf
    if not && isEmpty
        return SkyUnit2.FailExpectation("BeEmpty", "Expected " + type + " not to be empty but it was empty")
    elseIf ! not && ! isEmpty
        return SkyUnit2.FailExpectation("BeEmpty", "Expected " + type + " to be empty but it was not empty: " + actual)
    endIf
    return SkyUnit2.PassExpectation("BeEmpty")
endFunction

function HaveLength(int expectedLength)
    string type = SkyUnit2.GetExpectationData_MainObject_Type()
    bool not = SkyUnit2.Not()
    int actualLength
    if type == "String"
        actualLength = StringUtil.GetLength(SkyUnit2.GetAssertionData_MainObject_String())
    elseIf type == "StringArray"
        actualLength = SkyUnit2.GetExpectationData_MainObject_StringArray().Length
    elseIf type == "IntArray"
        actualLength = SkyUnit2.GetExpectationData_MainObject_IntArray().Length
    elseIf type == "FloatArray"
        actualLength = SkyUnit2.GetExpectationData_MainObject_FloatArray().Length
    elseIf type == "FormArray"
        actualLength = SkyUnit2.GetExpectationData_MainObject_FormArray().Length
    elseIf type == "BoolArray"
        actualLength = SkyUnit2.GetExpectationData_MainObject_BoolArray().Length
    else
        ; Log("HaveLength() called with unsupported type " + type + " " + SkyUnit2.GetAssertionData_MainObject_Text())
    endIf
    if not && expectedLength == actualLength
        SkyUnit2.FailExpectation("HaveLength", "Expected value not to have length " + expectedLength + ": " + SkyUnit2.GetAssertionData_MainObject_Text())
        return
    elseIf ! not && expectedLength != actualLength
        SkyUnit2.FailExpectation("HaveLength", "Expected value to have length " + expectedLength + ": " + SkyUnit2.GetAssertionData_MainObject_Text())
        return
    endIf
endFunction

bool function BeTrue()
    string type = SkyUnit2.GetAssertionData_MainObject_Type()
    bool not = SkyUnit2.Not()
    bool actualValue
    if type == "Bool"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "String"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "Int"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "Float"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "Form"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "StringArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "IntArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "FloatArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "FormArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "BoolArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf StringUtil.Find(type, "Array") > -1
        actualValue = SkyUnit2.GetExpectationData_MainObject_Text() != "[]"
    else
        actualValue = SkyUnit2.GetExpectationData_MainObject_Text()
    endIf
    if not && actualValue
        return SkyUnit2.FailExpectation("BeTrue", "Expected value not to be true: " + actualValue)
    elseIf ! not && ! actualValue
        return SkyUnit2.FailExpectation("BeTrue", "Expected value to be true: " + actualValue)
    endIf
    return SkyUnit2.PassExpectation("BeTrue")
endFunction

bool function BeFalse()
    string type = SkyUnit2.GetExpectationData_MainObject_Type()
    bool not = SkyUnit2.Not()
    bool actualValue
    if type == "Bool"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "String"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "Int"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "Float"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "Form"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "StringArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "IntArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "FloatArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "FormArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "BoolArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf StringUtil.Find(type, "Array") > -1
        actualValue = SkyUnit2.GetExpectationData_MainObject_Text() != "[]"
    else
        actualValue = SkyUnit2.GetExpectationData_MainObject_Text()
    endIf
    if not && ! actualValue
        return SkyUnit2.FailExpectation("BeFalse", "Expected value not to be false: " + actualValue)
    elseIf ! not && actualValue
        return SkyUnit2.FailExpectation("BeFalse", "Expected value to be false: " + actualValue)
    endIf
    return SkyUnit2.PassExpectation("BeFalse")
endFunction

bool function BeNone()
    string type = SkyUnit2.GetExpectationData_MainObject_Type()
    bool not = SkyUnit2.Not()
    bool actualValue

    if type == "Bool"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Bool()
    elseIf type == "String"
        actualValue = SkyUnit2.GetExpectationData_MainObject_String()
    elseIf type == "Int"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Int()
    elseIf type == "Float"
        actualValue = SkyUnit2.GetExpectationData_MainObject_Float()

    elseIf type == "Form"

        ; TODO put these conditionals into each branch, like so:

        ; actualValue = SkyUnit2.GetExpectationData_MainObject_Form()
        Form actualFormValue = SkyUnit2.GetExpectationData_MainObject_Form()
        if not && ! actualFormValue
            return SkyUnit2.FailExpectation("BeNone", "Expected Form not to be None: " + actualFormValue)
        elseIf ! not && actualFormValue
            return SkyUnit2.FailExpectation("BeNone", "Expected Form to be None: " + actualFormValue)
        endIf

    elseIf type == "StringArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_StringArray()
    elseIf type == "IntArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_IntArray()
    elseIf type == "FloatArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_FloatArray()
    elseIf type == "FormArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_FormArray()
    elseIf type == "BoolArray"
        actualValue = SkyUnit2.GetExpectationData_MainObject_BoolArray()
    elseIf StringUtil.Find(type, "Array") > -1
        actualValue = SkyUnit2.GetExpectationData_MainObject_Text() != "[]"
    else
        actualValue = SkyUnit2.GetExpectationData_MainObject_Text()
    endIf
    if not && ! actualValue
        return SkyUnit2.FailExpectation("BeNone", "Expected value not to be None: " + actualValue)
    elseIf ! not && actualValue
        return SkyUnit2.FailExpectation("BeNone", "Expected value to be None: " + actualValue)
    endIf

    return SkyUnit2.PassExpectation("BeNone")
endFunction

; function BeGreaterThan(float value)
;     string type = SkyUnit2.GetExpectationData_MainObjectType()
;     bool not = SkyUnit2.Not()
;     float actualValue
;     if type == "Int"
;         actualValue = SkyUnit2.GetExpectationData_Object_Int()
;     elseIf type == "Float"
;         actualValue = SkyUnit2.GetExpectationData_Object_Float()
;     else
;         SkyUnit2.FailExpectation("BeGreaterThan() can only be called on Int or Float but was called on type: " + type)
;         return
;     endIf
;     if not && (actualValue > value)
;         SkyUnit2.FailExpectation("Expected " + actualValue + " not to be greater than " + value)
;     elseIf ! not && ! (actualValue > value)
;         SkyUnit2.FailExpectation("Expected " + actualValue + " to be greater than " + value)
;     endIf
; endFunction

; ; bool function BeGreaterThanOrEqualTo(float value)
; ; endFunction

; ; bool function BeLessThan(float value)
; ; endFunction

; ; bool function BeLessThanOrEqualTo(float value)
; ; endFunction
