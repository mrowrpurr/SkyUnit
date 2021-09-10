scriptName SkyUnitTests_BuiltInBasicAssertions extends SkyUnitTests_BaseAssertionTest
{Tests for the expectations/assertions which are built in to SkyUnitTest}

function Tests()
    ; Expectations
    ; Test("ExpectBool").Fn(ExpectBool_Test())
    Test("ExpectInt").Fn(ExpectInt_Test())
    Test("ExpectFloat").Fn(ExpectFloat_Test())
    Test("ExpectString").Fn(ExpectString_Test())
    Test("ExpectForm").Fn(ExpectForm_Test())
    
    ; Simple Equal Assertions
    ; Test("EqualBool") ; .Fn(EqualBool_Test())
    ; Test("EqualInt") ; .Fn(EqualInt_Test())
    ; Test("EqualFloat") ; .Fn(EqualFloat_Test())
    ; Test("EqualString") ; .Fn(EqualString_Test())
    ; Test("EqualForm") ; .Fn(EqualForm_Test())

    ; Cross-Type Equality Assertions
    ; Test("EqualInt when provided a Float")
    ; Test("EqualFloat when provided an Int")
    ; Test("EqualInt when provided a Form")
    ; Test("EqualForm when provided an Int")
    ; Test("EqualString when provided an Int")
    ; Test("EqualString when provided an Float")
    ; Test("EqualString when provided an Form")
    ; Test("EqualString when provided an Bool")

    ; Other Assertions
    ; Test("ContainText")
    ; Test("BeEmpty")
    ; Test("BeTrue")
    ; Test("BeFalse")
    ; Test("BeNone")
    ; Test("HaveLength")
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expectations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
    ExpectString(text).To(EqualString("42"))
    ExpectInt(value).To(EqualInt(42))
endFunction

function ExpectFloat_Test()
    StartNewFakeTest("ExpectFloat")
    string type = SkyUnit2.GetExpectationData_MainObject_Type()
    string text = SkyUnit2.GetExpectationData_MainObject_Text()
    float value = SkyUnit2.GetExpectationData_MainObject_Float()

    SwitchTo_Default_TestSuite()
    ExpectString(type).To(BeEmpty())
    ExpectString(text).To(BeEmpty())
    ExpectFloat(value).To(EqualFloat(0))

    SwitchTo_Fake_TestSuite()
    ExpectFloat(4.2)
    type = SkyUnit2.GetExpectationData_MainObject_Type()
    text = SkyUnit2.GetExpectationData_MainObject_Text()
    value = SkyUnit2.GetExpectationData_MainObject_Float()

    SwitchTo_Default_TestSuite()
    ExpectString(type).To(EqualString("Float"))
    ExpectString(text).To(ContainText("4.2"))
    ExpectFloat(value).To(EqualFloat(4.2))
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
    ExpectString(value).To(EqualString("Hello, String!"))
endFunction

function ExpectForm_Test()
    StartNewFakeTest("ExpectForm")
    string type = SkyUnit2.GetExpectationData_MainObject_Type()
    string text = SkyUnit2.GetExpectationData_MainObject_Text()
    Form value = SkyUnit2.GetExpectationData_MainObject_Form()

    SwitchTo_Default_TestSuite()
    ExpectString(type).To(BeEmpty())
    ExpectString(text).To(BeEmpty())
    ExpectForm(value).To(BeNone())

    Form theForm = Game.GetPlayer()

    SwitchTo_Fake_TestSuite()
    ExpectForm(theForm)
    type = SkyUnit2.GetExpectationData_MainObject_Type()
    text = SkyUnit2.GetExpectationData_MainObject_Text()
    value = SkyUnit2.GetExpectationData_MainObject_Form()

    SwitchTo_Default_TestSuite()
    ExpectString(type).To(EqualString("Form"))
    ExpectString(text).To(ContainText("Actor"))
    ExpectString(text).To(ContainText("00000014"))
    ExpectForm(value).To(EqualForm(theForm))
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Assertions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
