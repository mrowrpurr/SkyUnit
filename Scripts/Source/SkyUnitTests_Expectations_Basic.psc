scriptName SkyUnitTests_Expectations_Basic extends SkyUnitAssertionTestBase
{Tests for `Expect*()` functions and assocaited `Equal*()` functions
Ensures that each of these functions stores the provided argument(s) as expected.}

function Tests()
    Test("Expectation Data Basics").Fn(ExpectationDataBasics_Test())
    
    Test("Assert")
    Test("Refute")

    Test("Expect").Fn(Expect_Test())
    Test("ExpectString").Fn(ExpectString_Test())
    Test("ExpectInt").Fn(ExpectInt_Test())
    Test("ExpectFloat").Fn(ExpectFloat_Test())
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

    ; Failing Case
    SwitchToContext_Fake()
    bool result = ExpectString("Hello").To(EqualString("Not Hello"))
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing strings 'Hello' and 'Not Hello' to return false")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Fail Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "Expected String \"Hello\" to equal String \"Not Hello\"", "[Fail Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "String", "[Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "Hello", "[Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualString(expectation) == "Hello", "[Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "String", "[Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "Not Hello", "[Fail Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedString(expectation) == "Not Hello", "[Fail Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectString(\"Hello\").To(EqualString(\"Not Hello\"))", "[Fail Example] Checking description")

    ; Passing Case
    SwitchToContext_Fake()
    result = ExpectString("Hi there").To(EqualString("Hi there"))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing strings 'Hi there' and 'Hi there' to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "String", "[Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "Hi there", "[Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualString(expectation) == "Hi there", "[Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "String", "[Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "Hi there", "[Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedString(expectation) == "Hi there", "[Pass Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectString(\"Hi there\").To(EqualString(\"Hi there\"))", "[Pass Example] Checking description")

    ; Not() Failing Case 
    SwitchToContext_Fake()
    result = ExpectString("Hi there").Not().To(EqualString("Hi there"))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing strings 'Hi there' and 'Hi there' not to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Not Fail Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "Expected String \"Hi there\" not to equal String \"Hi there\"", "[Not Fail Example] Checking failure message, actual: " + SkyUnitExpectation.GetFailureMessage(expectation))
    Assert(SkyUnitExpectation.GetActualType(expectation) == "String", "[Not Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "Hi there", "[Not Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualString(expectation) == "Hi there", "[Not Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "String", "[Not Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "Hi there", "[Not Fail Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedString(expectation) == "Hi there", "[Not Fail Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectString(\"Hi there\").Not().To(EqualString(\"Hi there\"))", "[Not Fail Example] Checking description")

    ; Not() Passing Case 
    SwitchToContext_Fake()
    result = ExpectString("Hello").Not().To(EqualString("Not Hello"))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing strings 'Hello' and 'Not Hello' not to equal to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Not Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Not Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "String", "[Not Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "Hello", "[Not Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualString(expectation) == "Hello", "[Not Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "String", "[Not Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "Not Hello", "[Not Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedString(expectation) == "Not Hello", "[Not Pass Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectString(\"Hello\").Not().To(EqualString(\"Not Hello\"))", "[Not Pass Example] Checking description")
endFunction

function Expect_Test()
    SetupFakeTest()

    ; Failing Case
    SwitchToContext_Fake()
    bool result = Expect("Hello").To(Equal("Not Hello"))
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing strings 'Hello' and 'Not Hello' to return false")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Fail Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "Expected String \"Hello\" to equal String \"Not Hello\"", "[Fail Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "String", "[Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "Hello", "[Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualString(expectation) == "Hello", "[Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "String", "[Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "Not Hello", "[Fail Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedString(expectation) == "Not Hello", "[Fail Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "Expect(\"Hello\").To(Equal(\"Not Hello\"))", "[Fail Example] Checking description")

    ; Passing Case
    SwitchToContext_Fake()
    result = Expect("Hi there").To(Equal("Hi there"))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing strings 'Hi there' and 'Hi there' to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "String", "[Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "Hi there", "[Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualString(expectation) == "Hi there", "[Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "String", "[Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "Hi there", "[Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedString(expectation) == "Hi there", "[Pass Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "Expect(\"Hi there\").To(Equal(\"Hi there\"))", "[Pass Example] Checking description")

    ; Not() Failing Case 
    SwitchToContext_Fake()
    result = Expect("Hi there").Not().To(Equal("Hi there"))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing strings 'Hi there' and 'Hi there' not to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Not Fail Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "Expected String \"Hi there\" not to equal String \"Hi there\"", "[Not Fail Example] Checking failure message, actual: " + SkyUnitExpectation.GetFailureMessage(expectation))
    Assert(SkyUnitExpectation.GetActualType(expectation) == "String", "[Not Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "Hi there", "[Not Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualString(expectation) == "Hi there", "[Not Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "String", "[Not Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "Hi there", "[Not Fail Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedString(expectation) == "Hi there", "[Not Fail Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "Expect(\"Hi there\").Not().To(Equal(\"Hi there\"))", "[Not Fail Example] Checking description")

    ; Not() Passing Case 
    SwitchToContext_Fake()
    result = Expect("Hello").Not().To(Equal("Not Hello"))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing strings 'Hello' and 'Not Hello' not to equal to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Not Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Not Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "String", "[Not Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "Hello", "[Not Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualString(expectation) == "Hello", "[Not Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "String", "[Not Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "Not Hello", "[Not Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedString(expectation) == "Not Hello", "[Not Pass Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "Expect(\"Hello\").Not().To(Equal(\"Not Hello\"))", "[Not Pass Example] Checking description")
endFunction

function ExpectInt_Test()
    SetupFakeTest()

    ; Failing Case
    SwitchToContext_Fake()
    bool result = ExpectInt(42).To(EqualInt(12345))
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing Ints 42 and 12345 to return false")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Fail Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "Expected Int 42 to equal Int 12345", "[Fail Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Int", "[Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == 42, "[Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualInt(expectation) == 42, "[Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Int", "[Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == 12345, "[Fail Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedInt(expectation) == 12345, "[Fail Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectInt(42).To(EqualInt(12345))", "[Fail Example] Checking description")

    ; Passing Case
    SwitchToContext_Fake()
    result = ExpectInt(789).To(EqualInt(789))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing Ints 789 and 789 to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Int", "[Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == 789, "[Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualInt(expectation) == 789, "[Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Int", "[Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == 789, "[Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedInt(expectation) == 789, "[Pass Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectInt(789).To(EqualInt(789))", "[Pass Example] Checking description")

    ; Not() Failing Case 
    SwitchToContext_Fake()
    result = ExpectInt(789).Not().To(EqualInt(789))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing Ints 789 and 789 not to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Not Fail Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "Expected Int 789 not to equal Int 789", "[Not Fail Example] Checking failure message, actual: " + SkyUnitExpectation.GetFailureMessage(expectation))
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Int", "[Not Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == 789, "[Not Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualInt(expectation) == 789, "[Not Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Int", "[Not Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == 789, "[Not Fail Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedInt(expectation) == 789, "[Not Fail Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectInt(789).Not().To(EqualInt(789))", "[Not Fail Example] Checking description")

    ; Not() Passing Case 
    SwitchToContext_Fake()
    result = ExpectInt(42).Not().To(EqualInt(12345))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing Ints 42 and 12345 not to equal to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Not Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Not Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Int", "[Not Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == 42, "[Not Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualInt(expectation) == 42, "[Not Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Int", "[Not Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == 12345, "[Not Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedInt(expectation) == 12345, "[Not Pass Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectInt(42).Not().To(EqualInt(12345))", "[Not Pass Example] Checking description")
endFunction

function ExpectFloat_Test()
    SetupFakeTest()

    ; Failing Case
    SwitchToContext_Fake()
    bool result = ExpectFloat(4.2).To(EqualFloat(123.45))
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing Floats 4.2 and 123.45 to return false")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Fail Example] Checking status")
    Assert(StringUtil.Find(SkyUnitExpectation.GetFailureMessage(expectation), "Expected Float 4.2") > -1, "[Fail Example] 1 Checking failure message: " + SkyUnitExpectation.GetFailureMessage(expectation))
    Assert(StringUtil.Find(SkyUnitExpectation.GetFailureMessage(expectation), "to equal Float 123.4") > -1, "[Fail Example] 2 Checking failure message: " + SkyUnitExpectation.GetFailureMessage(expectation))
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Float", "[Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == 4.2, "[Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualFloat(expectation) == 4.2, "[Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Float", "[Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == 123.45, "[Fail Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedFloat(expectation) == 123.45, "[Fail Example] Checking expected value")
    Assert(StringUtil.Find(SkyUnitExpectation.GetDescription(expectation), "ExpectFloat(4.2") > -1, "[Fail Example] Checking description")
    Assert(StringUtil.Find(SkyUnitExpectation.GetDescription(expectation), "To(EqualFloat(123.4") > -1, "[Fail Example] Checking description")

    ; Passing Case
    SwitchToContext_Fake()
    result = ExpectFloat(7.89).To(EqualFloat(7.89))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing Floats 7.89 and 7.89 to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Float", "[Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == 7.89, "[Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualFloat(expectation) == 7.89, "[Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Float", "[Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == 7.89, "[Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedFloat(expectation) == 7.89, "[Pass Example] Checking expected value")
    Assert(StringUtil.Find(SkyUnitExpectation.GetDescription(expectation), "ExpectFloat(7.8") > -1, "[Pass Example] Checking description")
    Assert(StringUtil.Find(SkyUnitExpectation.GetDescription(expectation), ".To(EqualFloat(7.89") > -1, "[Pass Example] Checking description")

    ; Not() Failing Case 
    SwitchToContext_Fake()
    result = ExpectFloat(7.89).Not().To(EqualFloat(7.89))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing Floats 7.89 and 7.89 not to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Not Fail Example] Checking status")
    Assert(StringUtil.Find(SkyUnitExpectation.GetFailureMessage(expectation), "Expected Float 7.89") > -1, "[Not Fail Example] 1 Checking failure message, actual: " + SkyUnitExpectation.GetFailureMessage(expectation))
    Assert(StringUtil.Find(SkyUnitExpectation.GetFailureMessage(expectation), "not to equal Float 7.89") > -1, "[Not Fail Example] 2 Checking failure message, actual: " + SkyUnitExpectation.GetFailureMessage(expectation))
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Float", "[Not Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == 7.89, "[Not Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualFloat(expectation) == 7.89, "[Not Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Float", "[Not Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == 7.89, "[Not Fail Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedFloat(expectation) == 7.89, "[Not Fail Example] Checking expected value")
    Assert(StringUtil.Find(SkyUnitExpectation.GetDescription(expectation), "ExpectFloat(7.8") > -1, "[Not Fail Example] Checking description")
    Assert(StringUtil.Find(SkyUnitExpectation.GetDescription(expectation), ".Not().To(EqualFloat(7.8") > -1, "[Not Fail Example] Checking description")

    ; Not() Passing Case 
    SwitchToContext_Fake()
    result = ExpectFloat(4.2).Not().To(EqualFloat(123.45))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing Floats 4.2 and 123.45 not to equal to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Not Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Not Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Float", "[Not Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == 4.2, "[Not Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualFloat(expectation) == 4.2, "[Not Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Float", "[Not Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == 123.45, "[Not Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedFloat(expectation) == 123.45, "[Not Pass Example] Checking expected value")
    Assert(StringUtil.Find(SkyUnitExpectation.GetDescription(expectation), "ExpectFloat(4.2") > -1, "[Not Pass Example] Checking description")
    Assert(StringUtil.Find(SkyUnitExpectation.GetDescription(expectation), ".Not().To(EqualFloat(123.4") > -1, "[Not Pass Example] Checking description")
endFunction
