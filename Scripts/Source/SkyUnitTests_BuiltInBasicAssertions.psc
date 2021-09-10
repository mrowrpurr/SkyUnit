scriptName SkyUnitTests_BuiltInBasicAssertions extends SkyUnitTests_BaseAssertionTest
{Tests for the expectations/assertions which are built in to SkyUnitTest}

function Tests()
    ; Test("ExpectBool").Fn(ExpectBool_Test())
    Test("ExpectInt").Fn(ExpectInt_Test())
    ; Test("ExpectFloat") ; .Fn(ExpectFloat_Test())
    
    Test("ExpectString").Fn(ExpectString_Test())
    
    ; Test("ExpectForm") ; .Fn(ExpectForm_Test())
    ; Test("EqualBool") ; .Fn(EqualBool_Test())
    ; Test("EqualInt") ; .Fn(EqualInt_Test())
    ; Test("EqualFloat") ; .Fn(EqualFloat_Test())
    ; Test("EqualString") ; .Fn(EqualString_Test())
    ; Test("EqualForm") ; .Fn(EqualForm_Test())
    ; Test("ContainText")
    ; Test("BeEmpty")
    ; Test("BeTrue")
    ; Test("BeFalse")
    ; Test("BeNone")
    ; Test("HaveLength")
endFunction

; function ExpectBool_Test()
;     StartNewFakeTest("ExpectBool")
;     string type = SkyUnit2.GetExpectationData_MainObject_Type()
;     string text = SkyUnit2.GetExpectationData_MainObject_Text()
;     bool value = SkyUnit2.GetExpectationData_MainObject_Bool()
;     SwitchTo_Default_TestSuite()

;     ExpectString(type).To(BeEmpty())
;     ExpectString(text).To(BeEmpty())
;     ExpectBool(value).To(BeFalse()) ; default value for bools

;     SwitchTo_Fake_TestSuite()
;     ExpectBool(true)
;     type = SkyUnit2.GetExpectationData_MainObject_Type()
;     text = SkyUnit2.GetExpectationData_MainObject_Text()
;     value = SkyUnit2.GetExpectationData_MainObject_Bool()
;     SwitchTo_Default_TestSuite()

;     ExpectString(type).To(EqualString("Bool"))
;     ExpectString(text).To(EqualString("true"))
;     ExpectBool(value).To(BeTrue()) ; not the default!

;     SaveFakeTestResults()
; endFunction

function ExpectInt_Test()
    Debug.Trace("[SkyUnit] - RUNNING EQUAL INT TEST!")

    StartNewFakeTest("ExpectInt")
    string type = SkyUnit2.GetExpectationData_MainObject_Type()
    string text = SkyUnit2.GetExpectationData_MainObject_Text()
    int value = SkyUnit2.GetExpectationData_MainObject_Int()

    SwitchTo_Default_TestSuite()
    ExpectString(type).To(BeEmpty())
    ExpectString(text).To(BeEmpty())
    ExpectInt(value).To(EqualInt(0))

    SwitchTo_Fake_TestSuite()
    ExpectInt(42)
    type = SkyUnit2.GetExpectationData_MainObject_Type()
    text = SkyUnit2.GetExpectationData_MainObject_Text()
    value = SkyUnit2.GetExpectationData_MainObject_Int()

    SwitchTo_Default_TestSuite()
    ExpectString(type).To(EqualString("Int"))
    ExpectString(text).To(EqualString("4233"))
    ExpectInt(value).To(EqualInt(42))

    SaveFakeTestResults()
endFunction

function ExpectFloat_Test()
endFunction

function ExpectString_Test()
    StartNewFakeTest("ExpectString")
    string type = SkyUnit2.GetExpectationData_MainObject_Type()
    string text = SkyUnit2.GetExpectationData_MainObject_Text()
    string value = SkyUnit2.GetExpectationData_MainObject_String()

    SwitchTo_Default_TestSuite()
    ExpectString(type).To(BeEmpty())
    ExpectString(text).To(BeEmpty())
    ExpectString(value).To(BeEmpty())

    SwitchTo_Fake_TestSuite()
    ExpectString("Hello, String!")
    type = SkyUnit2.GetExpectationData_MainObject_Type()
    text = SkyUnit2.GetExpectationData_MainObject_Text()
    value = SkyUnit2.GetExpectationData_MainObject_String()

    SwitchTo_Default_TestSuite()
    ExpectString(type).To(EqualString("String"))
    ExpectString(text).To(EqualString("Hello, String!"))
    ExpectString(value).To("Hello, String!")

    SaveFakeTestResults()
endFunction

function ExpectForm_Test()
endFunction

function EqualBool_Test()
endFunction

function EqualInt_Test()
endFunction

function EqualFloat_Test()
endFunction

function EqualString_Test()
endFunction

function EqualForm_Test()
endFunction
