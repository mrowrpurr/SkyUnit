scriptName SkyUnitTests_BuiltInBasicAssertions extends SkyUnitTests_BaseAssertionTest
{Tests for the expectations/assertions which are built in to SkyUnitTest}

import ArrayAssertions

function Tests()
    ; Expectations
    Test("ExpectBool").Fn(ExpectBool_Test())
    Test("ExpectInt").Fn(ExpectInt_Test())
    Test("ExpectFloat").Fn(ExpectFloat_Test())
    Test("ExpectString").Fn(ExpectString_Test())
    Test("ExpectForm").Fn(ExpectForm_Test())
    
    ; Simple Equal Assertions
    ; Test("EqualBool") ; .Fn(EqualBool_Test())
    Test("EqualInt").Fn(EqualInt_Test())
    Test("EqualFloat").Fn(EqualFloat_Test())
    Test("EqualString").Fn(EqualString_Test())
    Test("EqualForm").Fn(EqualForm_Test())

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
    Test("BeEmpty").Fn(BeEmpty_Test())
    ; Test("BeTrue")
    ; Test("BeFalse")
    ; Test("BeNone")
    ; Test("HaveLength")
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expectations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function ExpectBool_Test()
    StartNewFakeTest("ExpectBool")
    string type = SkyUnit2.GetExpectationData_MainObject_Type()
    string text = SkyUnit2.GetExpectationData_MainObject_Text()
    bool value = SkyUnit2.GetExpectationData_MainObject_Bool()

    SwitchTo_Default_TestSuite()
    ExpectString(type).To(BeEmpty())
    ExpectString(text).To(BeEmpty())
    ExpectBool(value).To(EqualBool(false)) ; default

    SwitchTo_Fake_TestSuite()
    ExpectBool(true)
    type = SkyUnit2.GetExpectationData_MainObject_Type()
    text = SkyUnit2.GetExpectationData_MainObject_Text()
    value = SkyUnit2.GetExpectationData_MainObject_Bool()

    SwitchTo_Default_TestSuite()
    ExpectString(type).To(EqualString("Bool"))
    ExpectString(text).To(EqualString("true"))
    ExpectBool(value).To(EqualBool(true))
endFunction

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
    bool expectationPassed
    string failureMessage

    ; EQUALS - PASS
    StartNewFakeTest("EqualInt Pass")
    ExpectInt(42).To(EqualInt(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    ; EndFakeTest()

    ; EQUALS - FAIL
    StartNewFakeTest("EqualInt Fail")
    ExpectInt(42).To(EqualInt(123456))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected 42 to equal 123456"))

    ; Not() EQUALS - PASS
    StartNewFakeTest("Not EqualInt Pass")
    ExpectInt(42).Not().To(EqualInt(123456))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    ; EndFakeTest()

    ; Not() EQUALS - FAIL
    StartNewFakeTest("Not EqualInt Pass")
    ExpectInt(42).Not().To(EqualInt(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected 42 not to equal 42"))
endFunction

function EqualFloat_Test()
    bool expectationPassed
    string failureMessage

    ; EQUALS - PASS
    StartNewFakeTest("EqualFloat Pass")
    ExpectFloat(4.2).To(EqualFloat(4.2))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    ; EndFakeTest()

    ; EQUALS - FAIL
    StartNewFakeTest("EqualFloat Fail")
    ExpectFloat(4.2).To(EqualFloat(123.456))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(ContainText("Expected 4.2"))
    ExpectString(failureMessage).To(ContainText("to equal 123.456"))

    ; Not() EQUALS - PASS
    StartNewFakeTest("Not EqualFloat Pass")
    ExpectFloat(4.2).Not().To(EqualFloat(123.456))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    ; EndFakeTest()

    ; Not() EQUALS - FAIL
    StartNewFakeTest("Not EqualFloat Pass")
    ExpectFloat(4.2).Not().To(EqualFloat(4.2))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(ContainText("Expected 4.2"))
    ExpectString(failureMessage).To(ContainText("not to equal 4.2"))
endFunction

function EqualString_Test()
    bool expectationPassed
    string failureMessage

    ; EQUALS - PASS
    StartNewFakeTest("EqualString Pass")
    ExpectString("Hello, world!").To(EqualString("Hello, world!"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    ; EndFakeTest()

    ; EQUALS - FAIL
    StartNewFakeTest("EqualString Fail")
    ExpectString("Hello, world!").To(EqualString("This string is not Hello, world!"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected 'Hello, world!' to equal 'This string is not Hello, world!'"))

    ; Not() EQUALS - PASS
    StartNewFakeTest("Not EqualString Pass")
    ExpectString("Hello, world!").Not().To(EqualString("This string is not Hello, world!"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    ; EndFakeTest()

    ; Not() EQUALS - FAIL
    StartNewFakeTest("Not EqualString Pass")
    ExpectString("Hello, world!").Not().To(EqualString("Hello, world!"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected 'Hello, world!' not to equal 'Hello, world!'"))
endFunction

function EqualForm_Test()
    Form gold = Game.GetForm(0xf)
    Form lockpick = Game.GetForm(0xa)

    bool expectationPassed
    string failureMessage

    ; EQUALS - PASS
    StartNewFakeTest("EqualForm Pass")
    ExpectForm(gold).To(EqualForm(gold))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    ; EndFakeTest()

    ; EQUALS - FAIL
    StartNewFakeTest("EqualForm Fail")
    ExpectForm(gold).To(EqualForm(lockpick))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(ContainText("Expected Gold"))
    ExpectString(failureMessage).To(ContainText("to equal Lockpick"))

    ; Not() EQUALS - PASS
    StartNewFakeTest("Not EqualForm Pass")
    ExpectForm(gold).Not().To(EqualForm(lockpick))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    ; EndFakeTest()

    ; Not() EQUALS - FAIL
    StartNewFakeTest("Not EqualForm Pass")
    ExpectForm(gold).Not().To(EqualForm(gold))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(ContainText("Expected Gold"))
    ExpectString(failureMessage).To(ContainText("not to equal Gold"))
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other Assertions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function BeEmpty_Test()
    string[] emptyStringArray
    string[] notEmptyStringArray = new string[1]
    notEmptyStringArray[0] = "Hello, I am not empty"

    bool expectationPassed
    string failureMessage

    ; EMPTY - PASS
    StartNewFakeTest("EqualForm Pass")
    ; String
    ExpectString("").To(BeEmpty())
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    ; StringArray
    SwitchTo_Fake_TestSuite()
    ExpectStringArray(emptyStringArray).To(BeEmpty())
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())

    ; EMPTY - FAIL
    StartNewFakeTest("EqualForm Fail")
    ; String
    ExpectString("I am not empty").To(BeEmpty())
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected String 'I am not empty' to be empty"))
    ; StringArray
    SwitchTo_Fake_TestSuite()
    ExpectStringArray(notEmptyStringArray).To(BeEmpty())
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected StringArray [\"Hello, I am not empty\"] to be empty"))

    ; ; Not() EMPTY - PASS
    StartNewFakeTest("Not() EqualForm Pass")
    ; String
    ExpectString("I am not empty").Not().To(BeEmpty())
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    ; StringArray
    SwitchTo_Fake_TestSuite()
    ExpectStringArray(notEmptyStringArray).Not().To(BeEmpty())
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())

    ; ; Not() EMPTY - FAIL
    StartNewFakeTest("Not() EqualForm Fail")
    ; String
    ExpectString("").Not().To(BeEmpty())
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected String '' not to be empty"))
    ; StringArray
    SwitchTo_Fake_TestSuite()
    ExpectStringArray(emptyStringArray).Not().To(BeEmpty())
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected StringArray [] not to be empty"))
endFunction

; Test("BeEmpty")

; Test("BeTrue")

; Test("BeFalse")

; Test("BeNone")

; Test("HaveLength")