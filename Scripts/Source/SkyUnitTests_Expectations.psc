scriptName SkyUnitTests_Expectations extends SkyUnitAssertionTestBase
{Tests for Expect*() functions.
Ensures that each of these functions stores the provided argument(s) as expected.}

function Tests()
    Test("Expectation Data Basics").Fn(ExpectationDataBasics_Test())
    
    Test("ExpectInt")
    Test("ExpectFloat")
    Test("ExpectBool")
    Test("ExpectString")
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
