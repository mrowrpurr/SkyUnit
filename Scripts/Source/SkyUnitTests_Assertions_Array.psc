scriptName SkyUnitTests_Assertions_Array extends SkyUnitAssertionTestBase
{Tests for Array assertions, e.g. `ContainsInt(42)`}

function Tests()
    Test("ExpectStringArray").Fn(ExpectStringArray_Test())
    Test("ExpectIntArray")
    Test("ExpectBoolArray")
    Test("ExpectFloatArray")
    Test("ExpectFormArray")

    Test("EqualStringArray").Fn(EqualStringArray_Test())
    Test("EqualStringArray1")
    Test("EqualStringArray2")
    Test("EqualStringArray3")
    Test("EqualStringArray4")
    Test("EqualStringArray5")

    Test("EqualIntArray")
    Test("EqualIntArray1")
    Test("EqualIntArray2")
    Test("EqualIntArray3")
    Test("EqualIntArray4")
    Test("EqualIntArray5")

    Test("EqualBoolArray")
    Test("EqualBoolArray1")
    Test("EqualBoolArray2")
    Test("EqualBoolArray3")
    Test("EqualBoolArray4")
    Test("EqualBoolArray5")

    Test("EqualFloatArray")
    Test("EqualFloatArray1")
    Test("EqualFloatArray2")
    Test("EqualFloatArray3")
    Test("EqualFloatArray4")
    Test("EqualFloatArray5")

    Test("EqualFormArray")
    Test("EqualFormArray1")
    Test("EqualFormArray2")
    Test("EqualFormArray3")
    Test("EqualFormArray4")
    Test("EqualFormArray5")
endFunction

function ExpectStringArray_Test()
    SetupFakeTest()

    string[] myArray = new string[2]
    myArray[0] = "Hello"
    myArray[1] = "World"

    SwitchToContext_Fake()
    ExpectStringArray(myArray)
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("StringArray"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("[\"Hello\", \"World\"]"))
endFunction

function EqualStringArray_Test()
    SetupFakeTest()

    string[] myArray = new string[2]
    myArray[0] = "Hello"
    myArray[1] = "World"

    string[] sameAsMyArray = new string[2]
    sameAsMyArray[0] = "Hello"
    sameAsMyArray[1] = "World"

    string[] differentArray = new string[1]
    differentArray[0] = "Foo"

    ; Failing Case
    SwitchToContext_Fake()
    bool result = ExpectStringArray(myArray).To(EqualStringArray(differentArray))
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(false))
    ExpectBool(SkyUnitExpectation.IsNotExpectation(expectation)).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("FAILING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal("Expected StringArray [\"Hello\", \"World\"] to equal StringArray [\"Foo\"]"))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("StringArray"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("[\"Hello\", \"World\"]"))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("StringArray"))
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal("[\"Foo\"]"))
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("ExpectStringArray([\"Hello\", \"World\"]).To(EqualStringArray([\"Foo\"]))"))
    string[] actual = SkyUnitExpectation.GetActualStringArray(expectation)
    string[] expected = SkyUnitExpectation.GetExpectedStringArray(expectation)
    ExpectInt(actual.Length).To(EqualInt(2)) ; TODO custom failure messages to add context
    ExpectInt(expected.Length).To(EqualInt(1)) ; TODO custom failure messages to add context
    Expect(actual[0]).To(Equal("Hello"))
    Expect(actual[1]).To(Equal("World"))
    Expect(expected[0]).To(Equal("Foo"))

    ; Passing Case - This proves that the == for Papyrus arrays is an equality BY VALUE and not BY REFERENCE :) So we don't need to compare values ourselves.
    SwitchToContext_Fake()
    result = ExpectStringArray(myArray).To(EqualStringArray(sameAsMyArray))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(true))
    ExpectBool(SkyUnitExpectation.IsNotExpectation(expectation)).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("PASSING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal("")) ; BeEmpty
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("StringArray"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("[\"Hello\", \"World\"]"))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("StringArray"))
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal("[\"Hello\", \"World\"]"))
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("ExpectStringArray([\"Hello\", \"World\"]).To(EqualStringArray([\"Hello\", \"World\"]))"))
    actual = SkyUnitExpectation.GetActualStringArray(expectation)
    expected = SkyUnitExpectation.GetExpectedStringArray(expectation)
    ExpectInt(actual.Length).To(EqualInt(2)) ; TODO custom failure messages to add context
    ExpectInt(expected.Length).To(EqualInt(2)) ; TODO custom failure messages to add context
    Expect(actual[0]).To(Equal("Hello"))
    Expect(actual[1]).To(Equal("World"))
    Expect(expected[0]).To(Equal("Hello"))
    Expect(expected[1]).To(Equal("World"))

    ; Not() Failing Case
    SwitchToContext_Fake()
    result = ExpectStringArray(myArray).Not().To(EqualStringArray(sameAsMyArray))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(false))
    ExpectBool(SkyUnitExpectation.IsNotExpectation(expectation)).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("FAILING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal("Expected StringArray [\"Hello\", \"World\"] not to equal StringArray [\"Hello\", \"World\"]"))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("StringArray"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("[\"Hello\", \"World\"]"))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("StringArray"))
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal("[\"Hello\", \"World\"]"))
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("ExpectStringArray([\"Hello\", \"World\"]).Not().To(EqualStringArray([\"Hello\", \"World\"]))"))
    actual = SkyUnitExpectation.GetActualStringArray(expectation)
    expected = SkyUnitExpectation.GetExpectedStringArray(expectation)
    ExpectInt(actual.Length).To(EqualInt(2)) ; TODO custom failure messages to add context
    ExpectInt(expected.Length).To(EqualInt(2)) ; TODO custom failure messages to add context
    Expect(actual[0]).To(Equal("Hello"))
    Expect(actual[1]).To(Equal("World"))
    Expect(expected[0]).To(Equal("Hello"))
    Expect(expected[1]).To(Equal("World"))


    ; Not() Passing Case
    SwitchToContext_Fake()
    result = ExpectStringArray(myArray).Not().To(EqualStringArray(differentArray))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(true))
    ExpectBool(SkyUnitExpectation.IsNotExpectation(expectation)).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("PASSING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal("")) ; Passes
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("StringArray"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("[\"Hello\", \"World\"]"))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("StringArray"))
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal("[\"Foo\"]"))
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("ExpectStringArray([\"Hello\", \"World\"]).Not().To(EqualStringArray([\"Foo\"]))"))
    actual = SkyUnitExpectation.GetActualStringArray(expectation)
    expected = SkyUnitExpectation.GetExpectedStringArray(expectation)
    ExpectInt(actual.Length).To(EqualInt(2)) ; TODO custom failure messages to add context
    ExpectInt(expected.Length).To(EqualInt(1)) ; TODO custom failure messages to add context
    Expect(actual[0]).To(Equal("Hello"))
    Expect(actual[1]).To(Equal("World"))
    Expect(expected[0]).To(Equal("Foo"))
endFunction

;;;;;;;;;;

function EqualStringArray1_Test()
    SetupFakeTest()

    ; Failing Case
    SwitchToContext_Fake()
    bool result = Assert(1 == 2, "Expected something to equal something else")
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()

    ; Passing Case

    ; Not() Failing Case

    ; Not() Passing Case
endFunction
