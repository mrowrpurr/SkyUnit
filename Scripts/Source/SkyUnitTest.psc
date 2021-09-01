scriptName SkyUnitTest extends Quest hidden
{Base script for implementing SkyUnit tests}

int _testData
int _currentTest
int _currentExpectation
bool _modInstalled

event OnInit()
    SkyUnit sdk = SkyUnit.GetInstance()
    sdk.RegisterSkyUnitTest(self)
    if ! _modInstalled
        _modInstalled = true
    else
        sdk.BeginTestScript(self)
        if sdk.ShouldRun()
            BeforeAll()
            Tests()
            AfterAll()
        endIf
    endIf
endEvent

bool function Run()
    SkyUnit sdk = SkyUnit.GetInstance()
    sdk.BeginTestScript(self)
    BeforeAll()
    Tests()
    AfterAll()
    return sdk.AllTestsPassed(self)
endFunction

function SaveResult(string filePath)
    SkyUnit sdk = SkyUnit.GetInstance()
    JValue.writeToFile(sdk.GetMapForSkyUnitTestResults(self), filePath)
endFunction

string function GetSummary(bool showFailureMessages = true, bool showPassingTestNames = true)
    SkyUnit sdk = SkyUnit.GetInstance()
    return sdk.GetTestSummary(self, showFailureMessages, showPassingTestNames)
endFunction

string function GetDisplayName()
    SkyUnit sdk = SkyUnit.GetInstance()
    return sdk.GetTestDisplayName(self)
endFunction

function Log(string text)
    SkyUnit.GetInstance().Log(text)
endFunction

SkyUnitTest function Example(string testName)
    return Test(testName)
endFunction

SkyUnitTest function Test(string testName)
    SkyUnit sdk = SkyUnit.GetInstance()
    sdk.GetTestLock()
    sdk.BeginTest(self, testName)
    BeforeEach()
    return self
endFunction

function Fn(bool testFunction)
    SkyUnit sdk = SkyUnit.GetInstance()
    AfterEach()
    sdk.ReleaseTestLock()
endFunction

SkyUnitTest function Not()
    SkyUnit.GetInstance().SetNotExpectation()
    return self
endFunction

SkyUnitTest function To(bool expectationFunction, string failureMessage = "")
    SkyUnit.GetInstance().SetExpectationFailureMessage(failureMessage)
    return self
endFunction

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
;; Base included Expect[Type]() functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SkyUnitTest function ExpectString(string value)
    SkyUnit.BeginExpectation("ExpectString")
    SkyUnit.SetExpectationData_Object_String(value)
    SkyUnit.SetExpectationData_MainObjectType("String")
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectInt(int value)
    SkyUnit.BeginExpectation("ExpectInt")
    SkyUnit.SetExpectationData_Object_Int(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectBool(bool value)
    SkyUnit.BeginExpectation("ExpectBool")
    SkyUnit.SetExpectationData_Object_Bool(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectFloat(float value)
    SkyUnit.BeginExpectation("ExpectFloat")
    SkyUnit.SetExpectationData_Object_Float(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectForm(Form value)
    SkyUnit.BeginExpectation("ExpectForm")
    SkyUnit.SetExpectationData_Object_Form(value)
    return SkyUnit.CurrentTest()
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Base included Assertion Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function EqualString(string expected)
    string actual = SkyUnit.GetExpectationData_Object_Text()
    bool not = SkyUnit.Not()
    if not && actual == expected
        SkyUnit.FailExpectation("Expected '" + actual + "' not to equal '" + expected + "'")
    elseIf ! not && actual != expected
        SkyUnit.FailExpectation("Expected '" + actual + "' to equal '" + expected + "'")
    endIf
endFunction

function EqualInt(int expected)
    int actual = SkyUnit.GetExpectationData_Object_Text() as int
    bool not = SkyUnit.Not()
    if not && actual == expected
        SkyUnit.FailExpectation("Expected " + actual + " not to equal " + expected)
    elseIf ! not && actual != expected
        SkyUnit.FailExpectation("Expected " + actual + " to equal " + expected)
    endIf
endFunction

function EqualFloat(float expected)
    float actual = SkyUnit.GetExpectationData_Object_Text() as float
    bool not = SkyUnit.Not()
    if not && actual == expected
        SkyUnit.FailExpectation("Expected " + actual + " not to equal " + expected)
    elseIf ! not && actual != expected
        SkyUnit.FailExpectation("Expected " + actual + " to equal " + expected)
    endIf
endFunction

function EqualForm(Form expected)
    Form actual = SkyUnit.GetExpectationData_Object_Form()
    bool not = SkyUnit.Not()
    if not && actual == expected
        SkyUnit.FailExpectation("Expected " + actual + " not to equal " + expected)
    elseIf ! not && actual != expected
        SkyUnit.FailExpectation("Expected " + actual + " to equal " + expected)
    endIf
endFunction

function ContainText(string expect)
    string actual = SkyUnit.GetExpectationData_Object_Text()
    bool not = SkyUnit.Not()
    if not && StringUtil.Find(actual, expect) > -1
        SkyUnit.FailExpectation("Expected '" + actual + "' not to contain text '" + expect + "'")
    elseIf ! not && StringUtil.Find(actual, expect) == -1
        SkyUnit.FailExpectation("Expected '" + actual + "' to contain text '" + expect + "'")
    endIf
endFunction

function BeEmpty()
    string actual = SkyUnit.GetExpectationData_Object_Text()
    bool not = SkyUnit.Not()
    string type = SkyUnit.GetExpectationData_MainObjectType()
    bool isEmpty = ! actual
    if StringUtil.Find(type, "Array") > -1
        isEmpty = actual == "[]"
    endIf
    if not && isEmpty
        SkyUnit.FailExpectation("Expected " + type + " not to be empty but it was empty")
    elseIf ! not && ! isEmpty
        SkyUnit.FailExpectation("Expected " + type + " to be empty but it was not empty: " + actual)
    endIf
endFunction

function HaveLength(int expectedLength)
    string type = SkyUnit.GetExpectationData_MainObjectType()
    bool not = SkyUnit.Not()
    int actualLength
    if type == "String"
        actualLength = StringUtil.GetLength(SkyUnit.GetExpectationData_Object_String())
    elseIf type == "StringArray"
        actualLength = SkyUnit.GetExpectationData_Object_StringArray().Length
    elseIf type == "IntArray"
        actualLength = SkyUnit.GetExpectationData_Object_IntArray().Length
    elseIf type == "FloatArray"
        actualLength = SkyUnit.GetExpectationData_Object_FloatArray().Length
    elseIf type == "FormArray"
        actualLength = SkyUnit.GetExpectationData_Object_FormArray().Length
    elseIf type == "BoolArray"
        actualLength = SkyUnit.GetExpectationData_Object_BoolArray().Length
    else
        Log("HaveLength() called with unsupported type " + type + " " + SkyUnit.GetExpectationData_Object_Text())
    endIf
    if not && expectedLength == actualLength
        SkyUnit.FailExpectation("Expected value not to have length " + expectedLength + ": " + SkyUnit.GetExpectationData_Object_Text())
    elseIf ! not && expectedLength != actualLength
        SkyUnit.FailExpectation("Expected value to have length " + expectedLength + ": " + SkyUnit.GetExpectationData_Object_Text())
    endIf
endFunction

function BeTrue()
    string type = SkyUnit.GetExpectationData_MainObjectType()
    bool not = SkyUnit.Not()
    bool actualValue
    if type == "Bool"
        actualValue = SkyUnit.GetExpectationData_Object_Bool()
    elseIf type == "String"
        actualValue = SkyUnit.GetExpectationData_Object_String()
    elseIf type == "Int"
        actualValue = SkyUnit.GetExpectationData_Object_Int()
    elseIf type == "Float"
        actualValue = SkyUnit.GetExpectationData_Object_Float()
    elseIf type == "Form"
        actualValue = SkyUnit.GetExpectationData_Object_Form()
    elseIf type == "StringArray"
        actualValue = SkyUnit.GetExpectationData_Object_StringArray()
    elseIf type == "IntArray"
        actualValue = SkyUnit.GetExpectationData_Object_IntArray()
    elseIf type == "FloatArray"
        actualValue = SkyUnit.GetExpectationData_Object_FloatArray()
    elseIf type == "FormArray"
        actualValue = SkyUnit.GetExpectationData_Object_FormArray()
    elseIf type == "BoolArray"
        actualValue = SkyUnit.GetExpectationData_Object_BoolArray()
    else
        actualValue = SkyUnit.GetExpectationData_Object_Text()
    endIf
    if not && actualValue
        SkyUnit.FailExpectation("Expected value not to be true: " + actualValue)
    elseIf ! not && ! actualValue
        SkyUnit.FailExpectation("Expected value to be true: " + actualValue)
    endIf
endFunction

function BeFalse()
    string type = SkyUnit.GetExpectationData_MainObjectType()
    bool not = SkyUnit.Not()
    bool actualValue
    if type == "Bool"
        actualValue = SkyUnit.GetExpectationData_Object_Bool()
    elseIf type == "String"
        actualValue = SkyUnit.GetExpectationData_Object_String()
    elseIf type == "Int"
        actualValue = SkyUnit.GetExpectationData_Object_Int()
    elseIf type == "Float"
        actualValue = SkyUnit.GetExpectationData_Object_Float()
    elseIf type == "Form"
        actualValue = SkyUnit.GetExpectationData_Object_Form()
    elseIf type == "StringArray"
        actualValue = SkyUnit.GetExpectationData_Object_StringArray()
    elseIf type == "IntArray"
        actualValue = SkyUnit.GetExpectationData_Object_IntArray()
    elseIf type == "FloatArray"
        actualValue = SkyUnit.GetExpectationData_Object_FloatArray()
    elseIf type == "FormArray"
        actualValue = SkyUnit.GetExpectationData_Object_FormArray()
    elseIf type == "BoolArray"
        actualValue = SkyUnit.GetExpectationData_Object_BoolArray()
    else
        actualValue = SkyUnit.GetExpectationData_Object_Text()
    endIf
    if not && ! actualValue
        SkyUnit.FailExpectation("Expected value not to be false: " + actualValue)
    elseIf ! not && actualValue
        SkyUnit.FailExpectation("Expected value to be false: " + actualValue)
    endIf
endFunction

; bool function BeGreaterThan(float value)
; endFunction

; bool function BeGreaterThanOrEqualTo(float value)
; endFunction

; bool function BeLessThan(float value)
; endFunction

; bool function BeLessThanOrEqualTo(float value)
; endFunction
