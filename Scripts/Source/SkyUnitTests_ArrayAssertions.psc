scriptName SkyUnitTests_ArrayAssertions extends SkyUnitTests_BaseAssertionTest

import ArrayAssertions

function Tests()
    Test("ExpectBoolArray").Fn(ExpectBoolArray_Test())
    Test("ExpectIntArray").Fn(ExpectIntArray_Test())
    Test("ExpectFloatArray").Fn(ExpectFloatArray_Test())
    Test("ExpectStringArray").Fn(ExpectStringArray_Test())
    Test("ExpectFormArray").Fn(ExpectFormArray_Test())
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
;; Assertions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
