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
    SkyUnitPrivateAPI.BeginExpectation()
    expectationCount = JArray.count(SkyUnitPrivateAPI.SkyUnitData_CurrentExpectationsArray())
    string[] expectationDataKeys = JMap.allKeysPArray(SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectationDataMap())

    SwitchToContext_Real()
    Assert(expectationCount == 1, "Expected test to have 1 expectation")
    Assert(expectationDataKeys.Length == 0, "Expected new expectation not to have any data yet")


endFunction
