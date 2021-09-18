scriptName SkyUnitTests_Expectations extends SkyUnitAssertionTestBase
{Tests for Expect*() functions.
Ensures that each of these functions stores the provided argument(s) as expected.}

function Tests()
    Test("Expectation Data Basics").Fn(ExpectationDataBasics_Test())
    
    Test("Assert")
    Test("Refute")

    Test("ExpectString").Fn(ExpectString_Test())
    Test("Expect") ; Alias for ExpectString
    Test("ExpectInt") ;.Fn(ExpectInt_Test())
    Test("ExpectFloat")
    Test("ExpectBool")
    Test("ExpectForm")

    Test("ExpectIntArray")
    Test("ExpectFloatArray")
    Test("ExpectBoolArray")
    Test("ExpectStringArray")
    Test("ExpectFormArray")

    Test("ExpectPlayer")
    Test("ExpectActor")
    Test("ExpectSpell")
    Test("ExpectObject")
endFunction

function ExpectationDataBasics_Test()
    SwitchToContext_Fake()
    CreateTestSuite("MyTests")
    CreateTest("MyTest")
    int expectationCount = JArray.count(SkyUnitPrivateAPI.SkyUnitData_CurrentExpectationsArray())

    SwitchToContext_Real()
    Assert(expectationCount == 0, "Expected new test not to have any expectations")

    SwitchToContext_Fake()
    SkyUnitExpectation.BeginExpectation("MyExpectation")
    expectationCount = JArray.count(SkyUnitPrivateAPI.SkyUnitData_CurrentExpectationsArray())
    string actualValueType = SkyUnitExpectation.GetActualType()

    SwitchToContext_Real()
    Assert(expectationCount == 1, "Expected test to have 1 expectation")
    Assert(actualValueType == "", "Expected new expectation not to have any data type yet for the 'actual' value")

    SwitchToContext_Fake()
    SkyUnitExpectation.SetActualInt(42)
    actualValueType = SkyUnitExpectation.GetActualType()
    string actualValueText = SkyUnitExpectation.GetActualText()
    int actualValueInt = SkyUnitExpectation.GetActualInt()

    SwitchToContext_Real()
    Assert(expectationCount == 1, "Expected test to have 1 expectation")
    Assert(actualValueType == "Int", "Expected actual value type to be Int")
    Assert(actualValueText == "42", "Expected actual value text to be 42")
    Assert(actualValueInt == 42, "Expected actual value to equal 42")
endFunction

function ExpectString_Test()
    SetupFakeTest()
    SwitchToContext_Fake()
    bool result = ExpectString("Hello").To(EqualString("Not Hello"))
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(! result, "Expected comparing strings 'Hello' and 'Not Hello' to return false")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Fail Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "Expected String \"Hello\" to equal String \"Not Hello\"", "[Fail Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "String", "[Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "String", "[Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualString(expectation) == "Hello", "[Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "String", "[Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "String", "[Fail Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedString(expectation) == "Not Hello", "[Fail Example] Checking expected value")

    SwitchToContext_Fake()
    result = ExpectString("Hi there").To(EqualString("Hi there"))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing strings 'Hi there' and 'Hi there' to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "String", "[Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "String", "[Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualString(expectation) == "Hi there", "[Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "String", "[Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "String", "[Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedString(expectation) == "Hi there", "[Pass Example] Checking expected value")

    ; Now a NOT example! 2 of them!
endFunction
