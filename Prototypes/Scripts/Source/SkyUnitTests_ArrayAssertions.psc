scriptName SkyUnitTests_ArrayAssertions extends SkyUnitTests_BaseAssertionTest

import ArrayAssertions

function Tests()
    Test("ExpectBoolArray").Fn(ExpectBoolArray_Test())
    Test("ExpectIntArray").Fn(ExpectIntArray_Test())
    Test("ExpectFloatArray").Fn(ExpectFloatArray_Test())
    Test("ExpectStringArray").Fn(ExpectStringArray_Test())
    Test("ExpectFormArray").Fn(ExpectFormArray_Test())

    ; Contain Assertions
    Test("ContainBool").Fn(ContainBool_Test())
    Test("ContainInt").Fn(ContainInt_Test())
    Test("ContainFloat").Fn(ContainFloat_Test())
    Test("ContainString").Fn(ContainString_Test())
    Test("ContainForm").Fn(ContainForm_Test())

    ; Equal Assertions
    Test("EqualStringArray").Fn(EqualStringArray_Test())
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expectations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function ExpectBoolArray_Test()
    bool expectationPassed
    string failureMessage

    bool[] oneItemArray = new bool[1]
    oneItemArray[0] = true

    bool[] threeItemArray = new bool[3]
    threeItemArray[0] = true
    threeItemArray[1] = false
    threeItemArray[2] = true

    StartNewFakeTest("ExpectBoolArray - One")
    ExpectBoolArray(oneItemArray).To(HaveLength(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected BoolArray [true] to have length 42"))

    StartNewFakeTest("ExpectBoolArray - Two")
    ExpectBoolArray(threeItemArray).To(HaveLength(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected BoolArray [true, false, true] to have length 42"))
endFunction

function ExpectIntArray_Test()
    bool expectationPassed
    string failureMessage

    int[] oneItemArray = new int[1]
    oneItemArray[0] = 42

    int[] threeItemArray = new int[3]
    threeItemArray[0] = 1
    threeItemArray[1] = 2
    threeItemArray[2] = 3

    StartNewFakeTest("ExpectIntArray - One")
    ExpectIntArray(oneItemArray).To(HaveLength(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected IntArray [42] to have length 42"))

    StartNewFakeTest("ExpectIntArray - Two")
    ExpectIntArray(threeItemArray).To(HaveLength(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected IntArray [1, 2, 3] to have length 42"))
endFunction

function ExpectFloatArray_Test()
    bool expectationPassed
    string failureMessage

    float[] oneItemArray = new float[1]
    oneItemArray[0] = 4.2

    float[] threeItemArray = new float[3]
    threeItemArray[0] = 1.2
    threeItemArray[1] = 2.3
    threeItemArray[2] = 3.4

    StartNewFakeTest("ExpectFloatArray - One")
    ExpectFloatArray(oneItemArray).To(HaveLength(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(ContainText("Expected FloatArray [4.2"))
    ExpectString(failureMessage).To(ContainText("to have length 42"))

    StartNewFakeTest("ExpectFloatArray - Two")
    ExpectFloatArray(threeItemArray).To(HaveLength(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(ContainText("Expected FloatArray [1.2"))
    ExpectString(failureMessage).To(ContainText("to have length 42"))
endFunction

function ExpectStringArray_Test()
    bool expectationPassed
    string failureMessage

    string[] oneItemArray = new string[1]
    oneItemArray[0] = "abc"

    string[] threeItemArray = new string[3]
    threeItemArray[0] = "abc"
    threeItemArray[1] = "def"
    threeItemArray[2] = "xyz"

    StartNewFakeTest("ExpectStringArray - One")
    ExpectStringArray(oneItemArray).To(HaveLength(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected StringArray [\"abc\"] to have length 42"))

    StartNewFakeTest("ExpectStringArray - Two")
    ExpectStringArray(threeItemArray).To(HaveLength(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected StringArray [\"abc\", \"def\", \"xyz\"] to have length 42"))
endFunction

function ExpectFormArray_Test()
    bool expectationPassed
    string failureMessage

    Form[] oneItemArray = new Form[1]
    oneItemArray[0] = Game.GetPlayer()

    Form[] threeItemArray = new Form[3]
    threeItemArray[0] = Game.GetPlayer()
    threeItemArray[1] = Game.GetForm(0xf)
    threeItemArray[2] = Game.GetForm(0xa)

    StartNewFakeTest("ExpectFormArray - One")
    ExpectFormArray(oneItemArray).To(HaveLength(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected FormArray [[Actor < (00000014)>]] to have length 42"))

    StartNewFakeTest("ExpectFormArray - Two")
    ExpectFormArray(threeItemArray).To(HaveLength(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected FormArray [[Actor < (00000014)>], [MiscObject < (0000000F)>], [MiscObject < (0000000A)>]] to have length 42"))
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Contain Assertions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function ContainBool_Test()
    bool expectationPassed
    string failureMessage

    bool[] boolArray = new bool[1]
    boolArray[0] = false

    ; PASS
    StartNewFakeTest("EqualIntArray - Pass")
    ExpectBoolArray(boolArray).To(ContainBool(false))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    
    ; FAIL
    StartNewFakeTest("EqualIntArray - Fail")
    ExpectBoolArray(boolArray).To(ContainBool(true))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected BoolArray [false] to contain true"))

    ; NOT PASS
    StartNewFakeTest("EqualIntArray - Pass")
    ExpectBoolArray(boolArray).Not().To(ContainBool(true))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())

    ; NOT FAIL
    StartNewFakeTest("EqualIntArray - Fail")
    ExpectBoolArray(boolArray).Not().To(ContainBool(false))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected BoolArray [false] not to contain false"))
endFunction

function ContainInt_Test()
    bool expectationPassed
    string failureMessage

    int[] intArray = new int[2]
    intArray[0] = 123
    intArray[1] = 42

    ; ; PASS
    StartNewFakeTest("EqualIntArray - Pass")
    ExpectIntArray(intArray).To(ContainInt(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    
    ; FAIL
    StartNewFakeTest("EqualIntArray - Fail")
    ExpectIntArray(intArray).To(ContainInt(123456))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected IntArray [123, 42] to contain 123456"))

    ; NOT PASS
    StartNewFakeTest("EqualIntArray - Pass")
    ExpectIntArray(intArray).Not().To(ContainInt(123456))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())

    ; NOT FAIL
    StartNewFakeTest("EqualIntArray - Fail")
    ExpectIntArray(intArray).Not().To(ContainInt(42))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected IntArray [123, 42] not to contain 42"))
endFunction

function ContainFloat_Test()
    bool expectationPassed
    string failureMessage

    float[] floatArray = new float[2]
    floatArray[0] = 1.23
    floatArray[1] = 4.2

    ; ; PASS
    StartNewFakeTest("EqualFloatArray - Pass")
    ExpectFloatArray(floatArray).To(ContainFloat(4.2))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    
    ; FAIL
    StartNewFakeTest("EqualFloatArray - Fail")
    ExpectFloatArray(floatArray).To(ContainFloat(123.456))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(ContainText("Expected FloatArray [1.23"))
    ExpectString(failureMessage).To(ContainText("to contain 123.456"))

    ; NOT PASS
    StartNewFakeTest("EqualFloatArray - Pass")
    ExpectFloatArray(floatArray).Not().To(ContainFloat(123.456))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())

    ; NOT FAIL
    StartNewFakeTest("EqualFloatArray - Fail")
    ExpectFloatArray(floatArray).Not().To(ContainFloat(4.2))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(ContainText("Expected FloatArray [1.23"))
    ExpectString(failureMessage).To(ContainText("not to contain 4.2"))
endFunction

function ContainString_Test()
    bool expectationPassed
    string failureMessage

    string[] stringArray = new string[2]
    stringArray[0] = "hello"
    stringArray[1] = "wassup"

    ; ; PASS
    StartNewFakeTest("EqualStringArray - Pass")
    ExpectStringArray(stringArray).To(ContainString("wassup"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    
    ; FAIL
    StartNewFakeTest("EqualStringArray - Fail")
    ExpectStringArray(stringArray).To(ContainString("this is not what you're looking for"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected StringArray [\"hello\", \"wassup\"] to contain 'this is not what you're looking for'"))

    ; NOT PASS
    StartNewFakeTest("EqualStringArray - Pass")
    ExpectStringArray(stringArray).Not().To(ContainString("this is not what you're looking for"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())

    ; NOT FAIL
    StartNewFakeTest("EqualStringArray - Fail")
    ExpectStringArray(stringArray).Not().To(ContainString("wassup"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected StringArray [\"hello\", \"wassup\"] not to contain 'wassup'"))
endFunction

function ContainForm_Test()
    bool expectationPassed
    string failureMessage

    Form gold = Game.GetForm(0xf)
    Form lockpick = Game.GetForm(0xa)
    Form ironDagger = Game.GetForm(0x1397e)

    Form[] theFormArray = new Form[2]
    theFormArray[0] = gold
    theFormArray[1] = lockpick

    ; ; PASS
    StartNewFakeTest("EqualFormArray - Pass")
    ExpectFormArray(theFormArray).To(ContainForm(gold))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    
    ; FAIL
    StartNewFakeTest("EqualFormArray - Fail")
    ExpectFormArray(theFormArray).To(ContainForm(ironDagger))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected FormArray [[MiscObject < (0000000F)>], [MiscObject < (0000000A)>]] to contain Iron Dagger [Weapon < (0001397E)>]"))

    ; NOT PASS
    StartNewFakeTest("EqualFormArray - Pass")
    ExpectFormArray(theFormArray).Not().To(ContainForm(ironDagger))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())

    ; NOT FAIL
    StartNewFakeTest("EqualFormArray - Fail")
    ExpectFormArray(theFormArray).Not().To(ContainForm(gold))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected FormArray [[MiscObject < (0000000F)>], [MiscObject < (0000000A)>]] not to contain gold [MiscObject < (0000000F)>]"))
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Equality Assertions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function EqualStringArray_Test()
    bool expectationPassed
    string failureMessage

    string[] stringArrayOne = new string[1]
    stringArrayOne[0] = "abc"
    
    string[] stringArrayTwo = new string[2]
    stringArrayTwo[0] = "abc"
    stringArrayTwo[1] = "def"

    string[] stringArrayThree = new string[3]
    stringArrayThree[0] = "abc"
    stringArrayThree[1] = "def"
    stringArrayThree[2] = "xyz"

    ; PASS
    StartNewFakeTest("EqualStringArray - Pass")
    ExpectStringArray(stringArrayOne).To(EqualStringArray1("abc"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    SwitchTo_Fake_TestSuite()
    ExpectStringArray(stringArrayTwo).To(EqualStringArray2("abc", "def"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    SwitchTo_Fake_TestSuite()
    ExpectStringArray(stringArrayThree).To(EqualStringArray3("abc", "def", "xyz"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    
    ; FAIL
    StartNewFakeTest("EqualStringArray - Fail")
    ExpectStringArray(stringArrayOne).To(EqualStringArray1("not abc"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected StringArray [\"abc\"] to equal StringArray [\"not abc\"]"))
    SwitchTo_Fake_TestSuite()
    ExpectStringArray(stringArrayTwo).To(EqualStringArray2("not abc", "def"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected StringArray [\"abc\", \"def\"] to equal StringArray [\"not abc\", \"def\"]"))
    SwitchTo_Fake_TestSuite()
    ExpectStringArray(stringArrayThree).To(EqualStringArray3("not abc", "def", "xyz"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected StringArray [\"abc\", \"def\", \"xyz\"] to equal StringArray [\"not abc\", \"def\", \"xyz\"]"))

    ; NOT PASS
    StartNewFakeTest("EqualStringArray - Not - Pass")
    ExpectStringArray(stringArrayOne).Not().To(EqualStringArray1("qwerty"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    SwitchTo_Fake_TestSuite()
    ExpectStringArray(stringArrayTwo).Not().To(EqualStringArray2("qwerty", "def"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())
    SwitchTo_Fake_TestSuite()
    ExpectStringArray(stringArrayThree).Not().To(EqualStringArray3("qwerty", "def", "xyz"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeTrue())
    ExpectString(failureMessage).To(BeEmpty())

    ; NOT FAIL
    StartNewFakeTest("EqualStringArray - Not - Fail")
    ExpectStringArray(stringArrayOne).Not().To(EqualStringArray1("abc"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected StringArray [\"abc\"] not to equal StringArray [\"abc\"]"))
    SwitchTo_Fake_TestSuite()
    ExpectStringArray(stringArrayTwo).Not().To(EqualStringArray2("abc", "def"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected StringArray [\"abc\", \"def\"] not to equal StringArray [\"abc\", \"def\"]"))
    SwitchTo_Fake_TestSuite()
    ExpectStringArray(stringArrayThree).Not().To(EqualStringArray3("abc", "def", "xyz"))
    expectationPassed = GetAssertExceptionPassed()
    failureMessage = GetAssertionFailureMessage()
    SwitchTo_Default_TestSuite()
    ExpectBool(expectationPassed).To(BeFalse())
    ExpectString(failureMessage).To(EqualString("Expected StringArray [\"abc\", \"def\", \"xyz\"] not to equal StringArray [\"abc\", \"def\", \"xyz\"]"))
endFunction
