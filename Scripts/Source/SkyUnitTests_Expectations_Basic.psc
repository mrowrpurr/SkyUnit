scriptName SkyUnitTests_Expectations_Basic extends SkyUnitAssertionTestBase
{Tests for `Expect*()` functions and assocaited `Equal*()` functions
Ensures that each of these functions stores the provided argument(s) as expected.}

function Tests()
    ; Test the core, basics expectation/assertion types - Using Assert() and Refute()
    Test("Expect").Fn(Expect_Test())
    Test("ExpectString").Fn(ExpectString_Test())
    Test("ExpectInt").Fn(ExpectInt_Test())
    Test("ExpectFloat").Fn(ExpectFloat_Test())
    Test("ExpectBool").Fn(ExpectBool_Test())
    Test("ExpectForm").Fn(ExpectForm_Test())
    Test("ExpectForm with None").Fn(ExpectForm_None_Test())
    
    ; Confirm that Assert() and Refute() work (using the above expectation/assertion types)
    Test("Assert").Fn(Assert_Test())
    Test("Refute").Fn(Refute_Test())

    Test("Custom Failure Messages") ; TODO
endFunction

function Assert_Test()
    SetupFakeTest()

    ; Failing Case
    SwitchToContext_Fake()
    bool result = Assert(1 == 2, "Expected something to equal something else")
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("FAILING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal("Expected something to equal something else"))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("false"))
    ExpectBool(SkyUnitExpectation.GetActualBool(expectation)).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("")) ; There is no expected for Assert(), only actual
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal(""))
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("Assert(false)"))

    ; Passing Case
    SwitchToContext_Fake()
    result = Assert(1 == 1, "Expected something to equal something else")
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("PASSING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal(""))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("true"))
    ExpectBool(SkyUnitExpectation.GetActualBool(expectation)).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("")) ; There is no expected for Assert(), only actual
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal(""))
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("Assert(true)"))
endFunction

function Refute_Test()
    SetupFakeTest()

    ; Failing Case
    SwitchToContext_Fake()
    bool result = Refute(1 == 1, "Expected something not to equal something else")
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("FAILING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal("Expected something not to equal something else"))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("true"))
    ExpectBool(SkyUnitExpectation.GetActualBool(expectation)).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("")) ; There is no expected for Refute(), only actual
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal(""))
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("Refute(true)"))

    ; Passing Case
    SwitchToContext_Fake()
    result = Refute(1 == 2, "Expected something not to equal something else")
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("PASSING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal(""))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("false"))
    ExpectBool(SkyUnitExpectation.GetActualBool(expectation)).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("")) ; There is no expected for Refute(), only actual
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal(""))
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("Refute(false)"))
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
    Assert(SkyUnitExpectation.GetActualText(expectation) == "42", "[Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualInt(expectation) == 42, "[Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Int", "[Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "12345", "[Fail Example] Checking expected text")
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
    Assert(SkyUnitExpectation.GetActualText(expectation) == "789", "[Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualInt(expectation) == 789, "[Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Int", "[Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "789", "[Pass Example] Checking expected text")
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
    Assert(SkyUnitExpectation.GetActualText(expectation) == "789", "[Not Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualInt(expectation) == 789, "[Not Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Int", "[Not Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "789", "[Not Fail Example] Checking expected text")
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
    Assert(SkyUnitExpectation.GetActualText(expectation) == "42", "[Not Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualInt(expectation) == 42, "[Not Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Int", "[Not Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "12345", "[Not Pass Example] Checking expected text")
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
    Assert(StringUtil.Find(SkyUnitExpectation.GetActualText(expectation), "4.2") > -1, "[Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualFloat(expectation) == 4.2, "[Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Float", "[Fail Example] Checking expected type")
    Assert(StringUtil.Find(SkyUnitExpectation.GetExpectedText(expectation), "123.4") > -1, "[Fail Example] Checking expected text")
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
    Assert(StringUtil.Find(SkyUnitExpectation.GetActualText(expectation), "7.8") > -1, "[Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualFloat(expectation) == 7.89, "[Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Float", "[Pass Example] Checking expected type")
    Assert(StringUtil.Find(SkyUnitExpectation.GetExpectedText(expectation), "7.8") > -1, "[Pass Example] Checking expected text")
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
    Assert(StringUtil.Find(SkyUnitExpectation.GetActualText(expectation), "4.2") > -1, "[Not Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualFloat(expectation) == 4.2, "[Not Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Float", "[Not Pass Example] Checking expected type")
    Assert(StringUtil.Find(SkyUnitExpectation.GetExpectedText(expectation), "123.4") > -1, "[Not Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedFloat(expectation) == 123.45, "[Not Pass Example] Checking expected value")
    Assert(StringUtil.Find(SkyUnitExpectation.GetDescription(expectation), "ExpectFloat(4.2") > -1, "[Not Pass Example] Checking description")
    Assert(StringUtil.Find(SkyUnitExpectation.GetDescription(expectation), ".Not().To(EqualFloat(123.4") > -1, "[Not Pass Example] Checking description")
endFunction

function ExpectBool_Test()
    SetupFakeTest()

    ; Failing Case
    SwitchToContext_Fake()
    bool result = ExpectBool(false).To(EqualBool(true))
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing Bools false and true to return false")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Fail Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "Expected Bool false to equal Bool true", "[Fail Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Bool", "[Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "false", "[Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualBool(expectation) == false, "[Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Bool", "[Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "true", "[Fail Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedBool(expectation) == true, "[Fail Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectBool(false).To(EqualBool(true))", "[Fail Example] Checking description")

    ; Passing Case
    SwitchToContext_Fake()
    result = ExpectBool(false).To(EqualBool(false))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing Bools false and false to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Bool", "[Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "false", "[Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualBool(expectation) == false, "[Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Bool", "[Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "false", "[Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedBool(expectation) == false, "[Pass Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectBool(false).To(EqualBool(false))", "[Pass Example] Checking description")

    ; Not() Failing Case 
    SwitchToContext_Fake()
    result = ExpectBool(false).Not().To(EqualBool(false))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing Bools false and false not to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Not Fail Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "Expected Bool false not to equal Bool false", "[Not Fail Example] Checking failure message, actual: " + SkyUnitExpectation.GetFailureMessage(expectation))
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Bool", "[Not Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "false", "[Not Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualBool(expectation) == false, "[Not Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Bool", "[Not Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "false", "[Not Fail Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedBool(expectation) == false, "[Not Fail Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectBool(false).Not().To(EqualBool(false))", "[Not Fail Example] Checking description")

    ; Not() Passing Case 
    SwitchToContext_Fake()
    result = ExpectBool(false).Not().To(EqualBool(true))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing Bools false and true not to equal to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Not Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Not Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Bool", "[Not Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "false", "[Not Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualBool(expectation) == false, "[Not Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Bool", "[Not Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "true", "[Not Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedBool(expectation) == true, "[Not Pass Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectBool(false).Not().To(EqualBool(true))", "[Not Pass Example] Checking description")
endFunction

function ExpectForm_Test()
    SetupFakeTest()

    Form gold     = Game.GetForm(0xf)
    Form lockpick = Game.GetForm(0xa)
    Form player   = Game.GetPlayer()

    ; Failing Case
    SwitchToContext_Fake()
    bool result = ExpectForm(gold).To(EqualForm(lockpick))
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing Forms gold and lockpick to return false")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Fail Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "Expected Form Gold [MiscObject < (0000000F)>] to equal Form Lockpick [MiscObject < (0000000A)>]", "[Fail Example] Checking failure message: " + SkyUnitExpectation.GetFailureMessage(expectation))
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Form", "[Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "Gold [MiscObject < (0000000F)>]", "[Fail Example] Checking actual text: " + SkyUnitExpectation.GetActualText(expectation))
    Assert(SkyUnitExpectation.GetActualForm(expectation) == gold, "[Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Form", "[Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "Lockpick [MiscObject < (0000000A)>]", "[Fail Example] Checking expected text: " + SkyUnitExpectation.GetExpectedText(expectation))
    Assert(SkyUnitExpectation.GetExpectedForm(expectation) == lockpick, "[Fail Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectForm(Gold [MiscObject < (0000000F)>]).To(EqualForm(Lockpick [MiscObject < (0000000A)>]))", "[Fail Example] Checking description: " + SkyUnitExpectation.GetDescription(expectation))

    ; Passing Case
    SwitchToContext_Fake()
    result = ExpectForm(player).To(EqualForm(player))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing Forms player and player to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Form", "[Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "[Actor < (00000014)>]", "[Pass Example] Checking actual text: " + SkyUnitExpectation.GetActualText(expectation) )
    Assert(SkyUnitExpectation.GetActualForm(expectation) == player, "[Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Form", "[Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "[Actor < (00000014)>]", "[Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedForm(expectation) == player, "[Pass Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectForm([Actor < (00000014)>]).To(EqualForm([Actor < (00000014)>]))", "[Pass Example] Checking description: " + SkyUnitExpectation.GetDescription(expectation))

    ; Not() Failing Case 
    SwitchToContext_Fake()
    result = ExpectForm(player).Not().To(EqualForm(player))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing Forms player and player not to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Not Fail Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "Expected Form [Actor < (00000014)>] not to equal Form [Actor < (00000014)>]", "[Not Fail Example] Checking failure message, actual: " + SkyUnitExpectation.GetFailureMessage(expectation))
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Form", "[Not Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "[Actor < (00000014)>]", "[Not Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualForm(expectation) == player, "[Not Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Form", "[Not Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "[Actor < (00000014)>]", "[Not Fail Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedForm(expectation) == player, "[Not Fail Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectForm([Actor < (00000014)>]).Not().To(EqualForm([Actor < (00000014)>]))", "[Not Fail Example] Checking description")

    ; Not() Passing Case 
    SwitchToContext_Fake()
    result = ExpectForm(gold).Not().To(EqualForm(lockpick))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing Forms gold and lockpick not to equal to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Not Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Not Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Form", "[Not Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "Gold [MiscObject < (0000000F)>]", "[Not Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualForm(expectation) == gold, "[Not Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Form", "[Not Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "Lockpick [MiscObject < (0000000A)>]", "[Not Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedForm(expectation) == lockpick, "[Not Pass Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectForm(Gold [MiscObject < (0000000F)>]).Not().To(EqualForm(Lockpick [MiscObject < (0000000A)>]))", "[Not Pass Example] Checking description")
endFunction

function ExpectForm_None_Test()
    SetupFakeTest()

    Form gold     = Game.GetForm(0xf)
    Form lockpick = Game.GetForm(0xa)
    Form nothing

    ; Failing Case
    SwitchToContext_Fake()
    bool result = ExpectForm(gold).To(EqualForm(lockpick))
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing Forms gold and lockpick to return false")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Fail Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "Expected Form Gold [MiscObject < (0000000F)>] to equal Form Lockpick [MiscObject < (0000000A)>]", "[Fail Example] Checking failure message: " + SkyUnitExpectation.GetFailureMessage(expectation))
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Form", "[Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "Gold [MiscObject < (0000000F)>]", "[Fail Example] Checking actual text: " + SkyUnitExpectation.GetActualText(expectation))
    Assert(SkyUnitExpectation.GetActualForm(expectation) == gold, "[Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Form", "[Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "Lockpick [MiscObject < (0000000A)>]", "[Fail Example] Checking expected text: " + SkyUnitExpectation.GetExpectedText(expectation))
    Assert(SkyUnitExpectation.GetExpectedForm(expectation) == lockpick, "[Fail Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectForm(Gold [MiscObject < (0000000F)>]).To(EqualForm(Lockpick [MiscObject < (0000000A)>]))", "[Fail Example] Checking description: " + SkyUnitExpectation.GetDescription(expectation))

    ; Passing Case
    SwitchToContext_Fake()
    result = ExpectForm(nothing).To(EqualForm(nothing))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing Forms nothing and nothing to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Form", "[Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "None", "[Pass Example] Checking actual text: " + SkyUnitExpectation.GetActualText(expectation) )
    Assert(SkyUnitExpectation.GetActualForm(expectation) == nothing, "[Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Form", "[Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "None", "[Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedForm(expectation) == nothing, "[Pass Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectForm(None).To(EqualForm(None))", "[Pass Example] Checking description: " + SkyUnitExpectation.GetDescription(expectation))

    ; Not() Failing Case 
    SwitchToContext_Fake()
    result = ExpectForm(nothing).Not().To(EqualForm(nothing))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Refute(result, "Expected comparing Forms nothing and nothing not to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "FAILING", "[Not Fail Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "Expected Form None not to equal Form None", "[Not Fail Example] Checking failure message, actual: " + SkyUnitExpectation.GetFailureMessage(expectation))
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Form", "[Not Fail Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "None", "[Not Fail Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualForm(expectation) == nothing, "[Not Fail Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Form", "[Not Fail Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "None", "[Not Fail Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedForm(expectation) == nothing, "[Not Fail Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectForm(None).Not().To(EqualForm(None))", "[Not Fail Example] Checking description")

    ; Not() Passing Case 
    SwitchToContext_Fake()
    result = ExpectForm(gold).Not().To(EqualForm(lockpick))
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    Assert(result, "Expected comparing Forms gold and lockpick not to equal to return true")
    Assert(SkyUnitExpectation.GetStatus(expectation) == "PASSING", "[Not Pass Example] Checking status")
    Assert(SkyUnitExpectation.GetFailureMessage(expectation) == "", "[Not Pass Example] Checking failure message")
    Assert(SkyUnitExpectation.GetActualType(expectation) == "Form", "[Not Pass Example] Checking actual type")
    Assert(SkyUnitExpectation.GetActualText(expectation) == "Gold [MiscObject < (0000000F)>]", "[Not Pass Example] Checking actual text")
    Assert(SkyUnitExpectation.GetActualForm(expectation) == gold, "[Not Pass Example] Checking actual value")
    Assert(SkyUnitExpectation.GetExpectedType(expectation) == "Form", "[Not Pass Example] Checking expected type")
    Assert(SkyUnitExpectation.GetExpectedText(expectation) == "Lockpick [MiscObject < (0000000A)>]", "[Not Pass Example] Checking expected text")
    Assert(SkyUnitExpectation.GetExpectedForm(expectation) == lockpick, "[Not Pass Example] Checking expected value")
    Assert(SkyUnitExpectation.GetDescription(expectation) == "ExpectForm(Gold [MiscObject < (0000000F)>]).Not().To(EqualForm(Lockpick [MiscObject < (0000000A)>]))", "[Not Pass Example] Checking description")
endFunction
