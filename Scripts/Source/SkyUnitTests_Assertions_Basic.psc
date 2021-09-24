scriptName SkyUnitTests_Assertions_Basic extends SkyUnitAssertionTestBase
{Additional tests for the basic built-in typed assertions, e.g. `EqualString()`

The basic use-cases of `EqualString()` `EqualInt()` etc are all tested in Expectations_Basic
but this is a good place for additional use-case testing such as `ExpectFloat().To(EqualInt())`

Generic assertions such as `HaveLength` and `ContainText` are tested in Assertions_Generic.}

function Tests()
    Test("ExpectBool().To(BeTrue())").Fn(ExpectBool_BeTrue_Test())
    Test("ExpectBool().To(BeFalse())").Fn(ExpectBool_BeFalse_Test())
    Test("Expect[AnythingWithText]().To(BeTrue())")
    Test("Expect[AnythingWithText]().To(BeFalse())")
    Test("Expect[Type]Array().To(BeTrue())")
    Test("Expect[Type]Array().To(BeFalse())")
endFunction

function ExpectBool_BeTrue_Test()
    SetupFakeTest()

    ; Failing Case
    SwitchToContext_Fake()
    bool result = ExpectBool(false).To(BeTrue())
    
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("FAILING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal("Expected Bool False to be true"))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("false"))
    ExpectBool(SkyUnitExpectation.GetActualBool(expectation)).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal("")) ; No expected value so the description will simply show BeTrue()
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("ExpectBool(false).To(BeTrue())"))

    ; ; Passing Case
    SwitchToContext_Fake()
    result = ExpectBool(true).To(BeTrue())
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("PASSING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal(""))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("true"))
    ExpectBool(SkyUnitExpectation.GetActualBool(expectation)).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal("")) ; No expected value so the description will simply show BeTrue()
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("ExpectBool(true).To(BeTrue())"))

    ; Not() Failing Case
    SwitchToContext_Fake()
    result = ExpectBool(true).Not().To(BeTrue())
    
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("FAILING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal("Expected Bool True not to be true"))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("true"))
    ExpectBool(SkyUnitExpectation.GetActualBool(expectation)).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal("")) ; No expected value so the description will simply show BeTrue()
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("ExpectBool(true).Not().To(BeTrue())"))

    ; Not() Passing Case
    SwitchToContext_Fake()
    result = ExpectBool(false).Not().To(BeTrue())
    
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("PASSING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal(""))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("false"))
    ExpectBool(SkyUnitExpectation.GetActualBool(expectation)).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal("")) ; No expected value so the description will simply show BeTrue()
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("ExpectBool(false).Not().To(BeTrue())"))
endFunction

function ExpectBool_BeFalse_Test()
    SetupFakeTest()

    ; Failing Case
    SwitchToContext_Fake()
    bool result = ExpectBool(true).To(BeFalse())
    
    int expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("FAILING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal("Expected Bool True to be false"))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("true"))
    ExpectBool(SkyUnitExpectation.GetActualBool(expectation)).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal("")) ; No expected value so the description will simply show BeFalse()
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("ExpectBool(true).To(BeFalse())"))

    ; ; Passing Case
    SwitchToContext_Fake()
    result = ExpectBool(false).To(BeFalse())
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("PASSING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal(""))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("false"))
    ExpectBool(SkyUnitExpectation.GetActualBool(expectation)).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal("")) ; No expected value so the description will simply show BeFalse()
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("ExpectBool(false).To(BeFalse())"))

    ; Not() Failing Case
    SwitchToContext_Fake()
    result = ExpectBool(false).Not().To(BeFalse())
    
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("FAILING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal("Expected Bool False not to be false"))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("false"))
    ExpectBool(SkyUnitExpectation.GetActualBool(expectation)).To(EqualBool(false))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal("")) ; No expected value so the description will simply show BeFalse()
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("ExpectBool(false).Not().To(BeFalse())"))

    ; Not() Passing Case
    SwitchToContext_Fake()
    result = ExpectBool(true).Not().To(BeFalse())
    
    expectation = SkyUnitExpectation.LatestExpectationID()

    SwitchToContext_Real()
    ExpectBool(result).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetStatus(expectation)).To(Equal("PASSING"))
    Expect(SkyUnitExpectation.GetFailureMessage(expectation)).To(Equal(""))
    Expect(SkyUnitExpectation.GetActualType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetActualText(expectation)).To(Equal("true"))
    ExpectBool(SkyUnitExpectation.GetActualBool(expectation)).To(EqualBool(true))
    Expect(SkyUnitExpectation.GetExpectedType(expectation)).To(Equal("Bool"))
    Expect(SkyUnitExpectation.GetExpectedText(expectation)).To(Equal("")) ; No expected value so the description will simply show BeFalse()
    Expect(SkyUnitExpectation.GetDescription(expectation)).To(Equal("ExpectBool(true).Not().To(BeFalse())"))
endFunction
