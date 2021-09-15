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
    SkyUnit.BeginExpectation("ExpectString")
    SkyUnit.SetExpectationData_MainObject_String(value)
    return self
endFunction

SkyUnitTest function ExpectInt(int value)
    SkyUnit.BeginExpectation("ExpectInt")
    SkyUnit.SetExpectationData_MainObject_Int(value)
    return self
endFunction

SkyUnitTest function ExpectBool(bool value)
    SkyUnit.BeginExpectation("ExpectBool")
    SkyUnit.SetExpectationData_MainObject_Bool(value)
    return self
endFunction

SkyUnitTest function ExpectFloat(float value)
    SkyUnit.BeginExpectation("ExpectFloat")
    SkyUnit.SetExpectationData_MainObject_Float(value)
    return self
endFunction

SkyUnitTest function ExpectForm(Form value)
    SkyUnit.BeginExpectation("ExpectForm")
    SkyUnit.SetExpectationData_MainObject_Form(value)
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
    SkyUnit.SetAssertionData_MainObject_String(expected)
    string actual = SkyUnit.GetExpectationData_MainObject_Text()
    if SkyUnit.GetExpectationData_MainObject_Type() == "String"
        actual = SkyUnit.GetExpectationData_MainObject_String()
    endIf
    bool not = SkyUnit.Not()
    if not && actual == expected
        return SkyUnit.FailExpectation("EqualString", "Expected '" + actual + "' not to equal '" + expected + "'")
    elseIf ! not && actual != expected
        return SkyUnit.FailExpectation("EqualString", "Expected '" + actual + "' to equal '" + expected + "'")
    endIf
    return SkyUnit.PassExpectation("EqualString")
endFunction

function EqualInt(int expected)
    SkyUnit.SetAssertionData_MainObject_Int(expected)
    int actual = SkyUnit.GetExpectationData_MainObject_Int()
    bool not = SkyUnit.Not()
    if not && actual == expected
        SkyUnit.FailExpectation("EqualInt", "Expected " + actual + " not to equal " + expected)
        return
    elseIf ! not && actual != expected
        SkyUnit.FailExpectation("EqualInt", "Expected " + actual + " to equal " + expected)
        return
    endIf
    SkyUnit.PassExpectation("EqualInt")
endFunction

function EqualBool(bool expected)
    SkyUnit.SetAssertionData_MainObject_Bool(expected)
    bool actual = SkyUnit.GetExpectationData_MainObject_Bool()
    bool not = SkyUnit.Not()
    if not && actual == expected
        SkyUnit.FailExpectation("EqualBool", "Expected " + actual + " not to equal " + expected)
        return
    elseIf ! not && actual != expected
        SkyUnit.FailExpectation("EqualBool", "Expected " + actual + " to equal " + expected)
        return
    endIf
    SkyUnit.PassExpectation("EqualBool")
endFunction

function EqualFloat(float expected)
    SkyUnit.SetAssertionData_MainObject_Float(expected)
    float actual = SkyUnit.GetExpectationData_MainObject_Text() as float
    bool not = SkyUnit.Not()
    if not && actual == expected
        SkyUnit.FailExpectation("EqualFloat", "Expected " + actual + " not to equal " + expected)
        return
    elseIf ! not && actual != expected
        SkyUnit.FailExpectation("EqualFloat", "Expected " + actual + " to equal " + expected)
        return
    endIf
    SkyUnit.PassExpectation("EqualFloat")
endFunction

function EqualForm(Form expected)
    SkyUnit.SetAssertionData_MainObject_Form(expected)
    Form actual = SkyUnit.GetExpectationData_MainObject_Form()
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
    bool not = SkyUnit.Not()
    if not && actual == expected
        SkyUnit.FailExpectation("EqualForm", "Expected " + actualName + " not to equal " + expectedName)
        return
    elseIf ! not && actual != expected
        SkyUnit.FailExpectation("EqualForm", "Expected " + actualName + " to equal " + expectedName)
        return
    endIf
    SkyUnit.PassExpectation("EqualForm")
endFunction

function ContainText(string expect)
    SkyUnit.SetAssertionData_MainObject_String(expect)
    string actual = SkyUnit.GetExpectationData_MainObject_Text()
    bool not = SkyUnit.Not()
    if not && StringUtil.Find(actual, expect) > -1
        SkyUnit.FailExpectation("ContainText", "Expected '" + actual + "' not to contain text '" + expect + "'")
        return
    elseIf ! not && StringUtil.Find(actual, expect) == -1
        SkyUnit.FailExpectation("ContainText", "Expected '" + actual + "' to contain text '" + expect + "'")
        return
    endIf
    SkyUnit.PassExpectation("ContainText")
endFunction

bool function BeEmpty()
    string actual = SkyUnit.GetExpectationData_MainObject_Text()
    bool not = SkyUnit.Not()
    string type = SkyUnit.GetExpectationData_MainObject_Type()
    bool isEmpty = ! actual
    if StringUtil.Find(type, "Array") > -1
        isEmpty = actual == "[]"
        if not && isEmpty
            return SkyUnit.FailExpectation("BeEmpty", "Expected " + type + " " + actual + " not to be empty")
        elseIf ! not && ! isEmpty
            return SkyUnit.FailExpectation("BeEmpty", "Expected " + type + " " + actual + " to be empty")
        endIf
    else
        if not && isEmpty
            return SkyUnit.FailExpectation("BeEmpty", "Expected " + type + " '" + actual + "' not to be empty")
        elseIf ! not && ! isEmpty
            return SkyUnit.FailExpectation("BeEmpty", "Expected " + type + " '"  + actual + "' to be empty")
        endIf
    endIf
    return SkyUnit.PassExpectation("BeEmpty")
endFunction

bool function HaveLength(int expectedLength)
    string type = SkyUnit.GetExpectationData_MainObject_Type()
    string text = SkyUnit.GetExpectationData_MainObject_Text()
    bool not = SkyUnit.Not()
    int actualLength
    if type == "String"
        text = SkyUnit.GetExpectationData_MainObject_String()
        actualLength = StringUtil.GetLength(text)
        text = "'" + text + "'"
    elseIf type == "StringArray"
        actualLength = SkyUnit.GetExpectationData_MainObject_StringArray().Length
    elseIf type == "IntArray"
        actualLength = SkyUnit.GetExpectationData_MainObject_IntArray().Length
    elseIf type == "FloatArray"
        actualLength = SkyUnit.GetExpectationData_MainObject_FloatArray().Length
    elseIf type == "FormArray"
        actualLength = SkyUnit.GetExpectationData_MainObject_FormArray().Length
    elseIf type == "BoolArray"
        actualLength = SkyUnit.GetExpectationData_MainObject_BoolArray().Length
    else
        return SkyUnit.FailExpectation("HaveLength", "HaveLength() called with unsupported type " + type + " " + text)
    endIf
    if not && expectedLength == actualLength
        return SkyUnit.FailExpectation("HaveLength", "Expected " + type + " " + text + " not to have length " + expectedLength)
    elseIf ! not && expectedLength != actualLength
        return SkyUnit.FailExpectation("HaveLength", "Expected " + type + " " + text + " to have length " + expectedLength)
    endIf
    return SkyUnit.PassExpectation("HaveLength")
endFunction

bool function BeTrue()
    string type = SkyUnit.GetExpectationData_MainObject_Type()
    string text = SkyUnit.GetExpectationData_MainObject_Text()
    bool not = SkyUnit.Not()
    bool actualValue
    if type == "Bool"
        actualValue = SkyUnit.GetExpectationData_MainObject_Bool()
    elseIf type == "String"
        actualValue = SkyUnit.GetExpectationData_MainObject_String()
        text = "'" + text + "'"
    elseIf type == "Int"
        actualValue = SkyUnit.GetExpectationData_MainObject_Int()
    elseIf type == "Float"
        actualValue = SkyUnit.GetExpectationData_MainObject_Float()
    elseIf type == "Form"
        actualValue = SkyUnit.GetExpectationData_MainObject_Form()
        if actualValue
            text = SkyUnit.GetExpectationData_MainObject_Form().GetName() + " " + SkyUnit.GetExpectationData_MainObject_Form()
        else
            text = "None"
        endIf
    elseIf type == "StringArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_StringArray()
    elseIf type == "IntArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_IntArray()
    elseIf type == "FloatArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_FloatArray()
    elseIf type == "FormArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_FormArray()
    elseIf type == "BoolArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_BoolArray()
    elseIf StringUtil.Find(type, "Array") > -1
        actualValue = SkyUnit.GetExpectationData_MainObject_Text() != "[]"
    else
        actualValue = SkyUnit.GetExpectationData_MainObject_Text()
    endIf
    if not && actualValue
        return SkyUnit.FailExpectation("BeTrue", "Expected " + type + " " + text + " not to be true")
    elseIf ! not && ! actualValue
        return SkyUnit.FailExpectation("BeTrue", "Expected " + type + " " + text + " to be true")
    endIf
    return SkyUnit.PassExpectation("BeTrue")
endFunction

bool function BeFalse()
    string type = SkyUnit.GetExpectationData_MainObject_Type()
    string text = SkyUnit.GetExpectationData_MainObject_Text()
    bool not = SkyUnit.Not()
    bool actualValue
    if type == "Bool"
        actualValue = SkyUnit.GetExpectationData_MainObject_Bool()
    elseIf type == "String"
        actualValue = SkyUnit.GetExpectationData_MainObject_String()
        text = "'" + text + "'"
    elseIf type == "Int"
        actualValue = SkyUnit.GetExpectationData_MainObject_Int()
    elseIf type == "Float"
        actualValue = SkyUnit.GetExpectationData_MainObject_Float()
    elseIf type == "Form"
        actualValue = SkyUnit.GetExpectationData_MainObject_Form()
        if actualValue
            text = SkyUnit.GetExpectationData_MainObject_Form().GetName() + " " + SkyUnit.GetExpectationData_MainObject_Form()
        else
            text = "None"
        endIf
    elseIf type == "StringArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_StringArray()
    elseIf type == "IntArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_IntArray()
    elseIf type == "FloatArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_FloatArray()
    elseIf type == "FormArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_FormArray()
    elseIf type == "BoolArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_BoolArray()
    elseIf StringUtil.Find(type, "Array") > -1
        actualValue = SkyUnit.GetExpectationData_MainObject_Text() != "[]"
    else
        actualValue = SkyUnit.GetExpectationData_MainObject_Text()
    endIf
    if not && ! actualValue
        return SkyUnit.FailExpectation("BeFalse", "Expected " + type + " " + text + " not to be false")
    elseIf ! not && actualValue
        return SkyUnit.FailExpectation("BeFalse", "Expected " + type + " " + text + " to be false")
    endIf
    return SkyUnit.PassExpectation("BeFalse")
endFunction

bool function BeNone()
    string type = SkyUnit.GetExpectationData_MainObject_Type()
    string text = SkyUnit.GetExpectationData_MainObject_Text()
    bool not = SkyUnit.Not()
    bool actualValue
    if type == "Bool"
        actualValue = SkyUnit.GetExpectationData_MainObject_Bool()
    elseIf type == "String"
        actualValue = SkyUnit.GetExpectationData_MainObject_String()
        text = "'" + text + "'"
    elseIf type == "Int"
        actualValue = SkyUnit.GetExpectationData_MainObject_Int()
    elseIf type == "Float"
        actualValue = SkyUnit.GetExpectationData_MainObject_Float()
    elseIf type == "Form"
        actualValue = SkyUnit.GetExpectationData_MainObject_Form()
        if actualValue
            text = SkyUnit.GetExpectationData_MainObject_Form().GetName() + " " + SkyUnit.GetExpectationData_MainObject_Form()
        else
            text = "None"
        endIf
    elseIf type == "StringArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_StringArray()
    elseIf type == "IntArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_IntArray()
    elseIf type == "FloatArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_FloatArray()
    elseIf type == "FormArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_FormArray()
    elseIf type == "BoolArray"
        actualValue = SkyUnit.GetExpectationData_MainObject_BoolArray()
    elseIf StringUtil.Find(type, "Array") > -1
        actualValue = SkyUnit.GetExpectationData_MainObject_Text() != "[]"
    else
        actualValue = SkyUnit.GetExpectationData_MainObject_Text()
    endIf
    if not && ! actualValue
        return SkyUnit.FailExpectation("BeNone", "Expected " + type + " " + text + " not to be None")
    elseIf ! not && actualValue
        return SkyUnit.FailExpectation("BeNone", "Expected " + type + " " + text + " to be None")
    endIf
    return SkyUnit.PassExpectation("BeNone")
endFunction


; function BeGreaterThan(float value)
;     string type = SkyUnit.GetExpectationData_MainObjectType()
;     bool not = SkyUnit.Not()
;     float actualValue
;     if type == "Int"
;         actualValue = SkyUnit.GetExpectationData_Object_Int()
;     elseIf type == "Float"
;         actualValue = SkyUnit.GetExpectationData_Object_Float()
;     else
;         SkyUnit.FailExpectation("BeGreaterThan() can only be called on Int or Float but was called on type: " + type)
;         return
;     endIf
;     if not && (actualValue > value)
;         SkyUnit.FailExpectation("Expected " + actualValue + " not to be greater than " + value)
;     elseIf ! not && ! (actualValue > value)
;         SkyUnit.FailExpectation("Expected " + actualValue + " to be greater than " + value)
;     endIf
; endFunction

; ; bool function BeGreaterThanOrEqualTo(float value)
; ; endFunction

; ; bool function BeLessThan(float value)
; ; endFunction

; ; bool function BeLessThanOrEqualTo(float value)
; ; endFunction
