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
        endIf
    endIf
endEvent

bool function Run()
    SkyUnit sdk = SkyUnit.GetInstance()
    sdk.BeginTestScript(self)
    BeforeAll()
    Tests()
    return sdk.AllTestsPassed(self)
endFunction

function SaveResult(string filePath)
    SkyUnit sdk = SkyUnit.GetInstance()
    JValue.writeToFile(sdk.GetMapForSkyUnitTestResults(self), filePath)
endFunction

string function GetSummary()
    SkyUnit sdk = SkyUnit.GetInstance()
    return sdk.GetTestSummary(self)
endFunction

string function GetDisplayName()
    SkyUnit sdk = SkyUnit.GetInstance()
    sdk.GetTestDisplayName(self)
endFunction

function Log(string text)
    SkyUnit.GetInstance().Log(text)
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

function BeforeEach()
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Base included Expect[Type]() functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SkyUnitTest function ExpectString(string value)
    SkyUnit.BeginExpectation(type = "ExpectString", object = value)
    SkyUnit.SetExpectationData_Object_String(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectStringArray(string[] value)
    SkyUnit.BeginExpectation(type = "ExpectStringArray", object = value)
    SkyUnit.SetExpectationData_Object_StringArray(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectInt(int value)
    SkyUnit.BeginExpectation(type = "ExpectInt", object = value)
    SkyUnit.SetExpectationData_Object_Int(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectIntArray(int[] value)
    SkyUnit.BeginExpectation(type = "ExpectIntArray", object = value)
    SkyUnit.SetExpectationData_Object_IntArray(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectFloat(float value)
    SkyUnit.BeginExpectation(type = "ExpectFloat", object = value)
    SkyUnit.SetExpectationData_Object_Float(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectFloatArray(float[] value)
    SkyUnit.BeginExpectation(type = "ExpectFloatArray", object = value)
    SkyUnit.SetExpectationData_Object_FloatArray(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectForm(Form value)
    SkyUnit.BeginExpectation(type = "ExpectForm", object = value)
    SkyUnit.SetExpectationData_Object_Form(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectFormArray(Form[] value)
    SkyUnit.BeginExpectation(type = "ExpectFormArray", object = value)
    SkyUnit.SetExpectationData_Object_FormArray(value)
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
        SkyUnit.FailExpectation("Expected string '" + actual + "' not to contain expect '" + expect + "'")
    elseIf ! not && StringUtil.Find(actual, expect) == -1
        SkyUnit.FailExpectation("Expected string '" + actual + "'s to contain expect '" + expect + "'")
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

function ContainString(string expected)
    string[] actual = SkyUnit.GetExpectationData_Object_StringArray()
    if actual
        int index = 0
        while index < actual.Length
            if actual[index] == expected
                return ; Found it
            endIf
            index += 1
        endWhile
    endIf
    SkyUnit.FailExpectation("Expected " + actual + " to contain '" + expected + "'")
endFunction

function ContainInt(int expected)
    int[] actual = SkyUnit.GetExpectationData_Object_IntArray()
    if actual
        int index = 0
        while index < actual.Length
            if actual[index] == expected
                return ; Found it
            endIf
            index += 1
        endWhile
    endIf
    SkyUnit.FailExpectation("Expected " + actual + " to contain " + expected)
endFunction

function ContainFloat(float expected)
    float[] actual = SkyUnit.GetExpectationData_Object_FloatArray()
    if actual
        int index = 0
        while index < actual.Length
            if actual[index] == expected
                return ; Found it
            endIf
            index += 1
        endWhile
    endIf
    SkyUnit.FailExpectation("Expected " + actual + " to contain " + expected)
endFunction

function ContainForm(Form expected)
    Form[] actual = SkyUnit.GetExpectationData_Object_FormArray()
    if actual
        int index = 0
        while index < actual.Length
            if actual[index] == expected
                return ; Found it
            endIf
            index += 1
        endWhile
    endIf
    SkyUnit.FailExpectation("Expected " + actual + " to contain " + expected)
endFunction
