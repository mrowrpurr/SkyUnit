scriptName SkyUnit2Test extends Quest
{Base script for all SkyUnit test scripts.

e.g.
  scriptName MyCoolTest extends SkyUnit2Test
  
  function Tests()
    Test("Pending test")
    Test("Failing test")
    Test("Passing test")
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

SkyUnit2Test function Test(string testName)
    SkyUnit2PrivateAPI.GetPrivateAPI().BeginTest(testName)
    BeforeEach()
    return self
endFunction

function Fn(bool testFunction)
    SkyUnit2PrivateAPI.GetPrivateAPI().EndTest(fnCalled = true)
endFunction

SkyUnit2Test function Not()
    SkyUnit2PrivateAPI.GetPrivateAPI().SetNotExpectation()
    return self
endFunction

SkyUnit2Test function To(bool expectationFunction, string failureMessage = "")
    SkyUnit2PrivateAPI.GetPrivateAPI().SetCustomFailureMessage(failureMessage)
    return self
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Base included Expect[Type]() functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SkyUnit2Test function ExpectString(string value)
    SkyUnit2.BeginExpectation("ExpectString")
    SkyUnit2.SetExpectationData_MainObject_String(value)
    return self
endFunction

SkyUnit2Test function ExpectInt(int value)
    SkyUnit2.BeginExpectation("ExpectInt")
    SkyUnit2.SetExpectationData_MainObject_Int(value)
    return self
endFunction

SkyUnit2Test function ExpectBool(bool value)
    SkyUnit2.BeginExpectation("ExpectBool")
    SkyUnit2.SetExpectationData_MainObject_Bool(value)
    return self
endFunction

SkyUnit2Test function ExpectFloat(float value)
    SkyUnit2.BeginExpectation("ExpectFloat")
    SkyUnit2.SetExpectationData_MainObject_Float(value)
    return self
endFunction

SkyUnit2Test function ExpectForm(Form value)
    SkyUnit2.BeginExpectation("ExpectForm")
    SkyUnit2.SetExpectationData_MainObject_Form(value)
    return self
endFunction

function Log(string text)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Base included Assertion Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function EqualString(string expected)
    ; This should be added via either Pass or Fail
    SkyUnit2.PassExpectation("EqualString")

    ; string actual = SkyUnit.GetExpectationData_Object_Text()
    ; bool not = SkyUnit.Not()
    ; if not && actual == expected
    ;     SkyUnit.FailExpectation("Expected '" + actual + "' not to equal '" + expected + "'")
    ; elseIf ! not && actual != expected
    ;     SkyUnit.FailExpectation("Expected '" + actual + "' to equal '" + expected + "'")
    ; endIf
endFunction

function EqualInt(int expected)
    SkyUnit2.PassExpectation("EqualInt")
    ; int actual = SkyUnit.GetExpectationData_Object_Text() as int
    ; bool not = SkyUnit.Not()
    ; if not && actual == expected
    ;     SkyUnit.FailExpectation("Expected " + actual + " not to equal " + expected)
    ; elseIf ! not && actual != expected
    ;     SkyUnit.FailExpectation("Expected " + actual + " to equal " + expected)
    ; endIf
endFunction

function EqualFloat(float expected)
    SkyUnit2.PassExpectation("EqualFloat")
    ; float actual = SkyUnit.GetExpectationData_Object_Text() as float
    ; bool not = SkyUnit.Not()
    ; if not && actual == expected
    ;     SkyUnit.FailExpectation("Expected " + actual + " not to equal " + expected)
    ; elseIf ! not && actual != expected
    ;     SkyUnit.FailExpectation("Expected " + actual + " to equal " + expected)
    ; endIf
endFunction

; function EqualForm(Form expected)
;     Form actual = SkyUnit.GetExpectationData_Object_Form()
;     bool not = SkyUnit.Not()
;     if not && actual == expected
;         SkyUnit.FailExpectation("Expected " + actual + " not to equal " + expected)
;     elseIf ! not && actual != expected
;         SkyUnit.FailExpectation("Expected " + actual + " to equal " + expected)
;     endIf
; endFunction

; function ContainText(string expect)
;     string actual = SkyUnit.GetExpectationData_Object_Text()
;     bool not = SkyUnit.Not()
;     if not && StringUtil.Find(actual, expect) > -1
;         SkyUnit.FailExpectation("Expected '" + actual + "' not to contain text '" + expect + "'")
;     elseIf ! not && StringUtil.Find(actual, expect) == -1
;         SkyUnit.FailExpectation("Expected '" + actual + "' to contain text '" + expect + "'")
;     endIf
; endFunction

; function BeEmpty()
;     string actual = SkyUnit.GetExpectationData_Object_Text()
;     bool not = SkyUnit.Not()
;     string type = SkyUnit.GetExpectationData_MainObjectType()
;     bool isEmpty = ! actual
;     if StringUtil.Find(type, "Array") > -1
;         isEmpty = actual == "[]"
;     endIf
;     if not && isEmpty
;         SkyUnit.FailExpectation("Expected " + type + " not to be empty but it was empty")
;     elseIf ! not && ! isEmpty
;         SkyUnit.FailExpectation("Expected " + type + " to be empty but it was not empty: " + actual)
;     endIf
; endFunction

; function HaveLength(int expectedLength)
;     string type = SkyUnit.GetExpectationData_MainObjectType()
;     bool not = SkyUnit.Not()
;     int actualLength
;     if type == "String"
;         actualLength = StringUtil.GetLength(SkyUnit.GetExpectationData_Object_String())
;     elseIf type == "StringArray"
;         actualLength = SkyUnit.GetExpectationData_Object_StringArray().Length
;     elseIf type == "IntArray"
;         actualLength = SkyUnit.GetExpectationData_Object_IntArray().Length
;     elseIf type == "FloatArray"
;         actualLength = SkyUnit.GetExpectationData_Object_FloatArray().Length
;     elseIf type == "FormArray"
;         actualLength = SkyUnit.GetExpectationData_Object_FormArray().Length
;     elseIf type == "BoolArray"
;         actualLength = SkyUnit.GetExpectationData_Object_BoolArray().Length
;     else
;         Log("HaveLength() called with unsupported type " + type + " " + SkyUnit.GetExpectationData_Object_Text())
;     endIf
;     if not && expectedLength == actualLength
;         SkyUnit.FailExpectation("Expected value not to have length " + expectedLength + ": " + SkyUnit.GetExpectationData_Object_Text())
;     elseIf ! not && expectedLength != actualLength
;         SkyUnit.FailExpectation("Expected value to have length " + expectedLength + ": " + SkyUnit.GetExpectationData_Object_Text())
;     endIf
; endFunction

; function BeTrue()
;     string type = SkyUnit.GetExpectationData_MainObjectType()
;     bool not = SkyUnit.Not()
;     bool actualValue
;     if type == "Bool"
;         actualValue = SkyUnit.GetExpectationData_Object_Bool()
;     elseIf type == "String"
;         actualValue = SkyUnit.GetExpectationData_Object_String()
;     elseIf type == "Int"
;         actualValue = SkyUnit.GetExpectationData_Object_Int()
;     elseIf type == "Float"
;         actualValue = SkyUnit.GetExpectationData_Object_Float()
;     elseIf type == "Form"
;         actualValue = SkyUnit.GetExpectationData_Object_Form()
;     elseIf type == "StringArray"
;         actualValue = SkyUnit.GetExpectationData_Object_StringArray()
;     elseIf type == "IntArray"
;         actualValue = SkyUnit.GetExpectationData_Object_IntArray()
;     elseIf type == "FloatArray"
;         actualValue = SkyUnit.GetExpectationData_Object_FloatArray()
;     elseIf type == "FormArray"
;         actualValue = SkyUnit.GetExpectationData_Object_FormArray()
;     elseIf type == "BoolArray"
;         actualValue = SkyUnit.GetExpectationData_Object_BoolArray()
;     elseIf StringUtil.Find(type, "Array") > -1
;         actualValue = SkyUnit.GetExpectationData_Object_Text() != "[]"
;     else
;         actualValue = SkyUnit.GetExpectationData_Object_Text()
;     endIf
;     if not && actualValue
;         SkyUnit.FailExpectation("Expected value not to be true: " + actualValue)
;     elseIf ! not && ! actualValue
;         SkyUnit.FailExpectation("Expected value to be true: " + actualValue)
;     endIf
; endFunction

; function BeFalse()
;     string type = SkyUnit.GetExpectationData_MainObjectType()
;     bool not = SkyUnit.Not()
;     bool actualValue
;     if type == "Bool"
;         actualValue = SkyUnit.GetExpectationData_Object_Bool()
;     elseIf type == "String"
;         actualValue = SkyUnit.GetExpectationData_Object_String()
;     elseIf type == "Int"
;         actualValue = SkyUnit.GetExpectationData_Object_Int()
;     elseIf type == "Float"
;         actualValue = SkyUnit.GetExpectationData_Object_Float()
;     elseIf type == "Form"
;         actualValue = SkyUnit.GetExpectationData_Object_Form()
;     elseIf type == "StringArray"
;         actualValue = SkyUnit.GetExpectationData_Object_StringArray()
;     elseIf type == "IntArray"
;         actualValue = SkyUnit.GetExpectationData_Object_IntArray()
;     elseIf type == "FloatArray"
;         actualValue = SkyUnit.GetExpectationData_Object_FloatArray()
;     elseIf type == "FormArray"
;         actualValue = SkyUnit.GetExpectationData_Object_FormArray()
;     elseIf type == "BoolArray"
;         actualValue = SkyUnit.GetExpectationData_Object_BoolArray()
;     elseIf StringUtil.Find(type, "Array") > -1
;         actualValue = SkyUnit.GetExpectationData_Object_Text() != "[]"
;     else
;         actualValue = SkyUnit.GetExpectationData_Object_Text()
;     endIf
;     if not && ! actualValue
;         SkyUnit.FailExpectation("Expected value not to be false: " + actualValue)
;     elseIf ! not && actualValue
;         SkyUnit.FailExpectation("Expected value to be false: " + actualValue)
;     endIf
; endFunction

; function BeNone()
;     BeFalse()
; endFunction

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
