scriptName SkyUnitTests_Assertions_Basic extends SkyUnitAssertionTestBase
{Additional tests for the basic built-in typed assertions, e.g. `EqualString()`

The basic use-cases of `EqualString()` `EqualInt()` etc are all tested in Expectations_Basic
but this is a good place for additional use-case testing such as `ExpectFloat().To(EqualInt())`

Generic assertions such as `HaveLength` and `ContainText` are tested in Assertions_Generic.}

function Tests()
    Test("BeTrue()").Fn(ExpectBool_BeTrue_Test())
    Test("BeFalse()").Fn(ExpectBool_BeFalse_Test())
    Test("ContainText() with Strings").Fn(String_ContainText_Test())
    Test("ContainText() with Arrays").Fn(Array_ContainText_Test())
    Test("HaveLength() with Strings")
    Test("HaveLength() with Arrays")
    Test("BeEmpty() with Strings")
    Test("BeEmpty() with Arrays")
    Test("BeGreaterThan()")
    Test("BeGreaterThanOrEqualTo()")
    Test("BeLessThan()")
    Test("BeLessThanOrEqualTo()")
endFunction

function ExpectBool_BeTrue_Test()
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
    ; FAIL
    ExpectExpectation().ToFail(ExpectBool(true).To(BeFalse()))
    ExpectDescription("ExpectBool(true).To(BeFalse())")
    ExpectFailureMessage("Expected Bool True to be false")
    ExpectActual("Bool", "true")
    ExpectExpected("Bool", "")
    ExpectBool(SkyUnitExpectation.GetActualBool(ExpectationID)).To(EqualBool(true))

    ; PASS
    ExpectExpectation().ToPass(ExpectBool(false).To(BeFalse()))
    ExpectDescription("ExpectBool(false).To(BeFalse())")
    ExpectActual("Bool", "false")
    ExpectExpected("Bool", "")
    ExpectBool(SkyUnitExpectation.GetActualBool(ExpectationID)).To(EqualBool(false))

    ; Not() FAIL
    ExpectExpectation().ToFail(ExpectBool(false).Not().To(BeFalse()))
    ExpectDescription("ExpectBool(false).Not().To(BeFalse())")
    ExpectFailureMessage("Expected Bool False not to be false")
    ExpectActual("Bool", "false")
    ExpectExpected("Bool", "")
    ExpectBool(SkyUnitExpectation.GetActualBool(ExpectationID)).To(EqualBool(false))

    ; Not() PASS
    ExpectExpectation().ToPass(ExpectBool(true).Not().To(BeFalse()))
    ExpectDescription("ExpectBool(true).Not().To(BeFalse())")
    ExpectActual("Bool", "true")
    ExpectExpected("Bool", "")
    ExpectBool(SkyUnitExpectation.GetActualBool(ExpectationID)).To(EqualBool(true))
endFunction

function String_ContainText_Test()
    ; FAIL
    ExpectExpectation().ToFail(ExpectString("Hello World").To(ContainText("Foo")) )
    ExpectDescription("ExpectString(\"Hello World\").To(ContainText(\"Foo\"))")
    ExpectFailureMessage("Expected String \"Hello World\" to contain text \"Foo\"")
    ExpectActual("String", "Hello World")
    ExpectExpected("String", "Foo")
    ExpectString(SkyUnitExpectation.GetActualString(ExpectationID)).To(EqualString("Hello World"))
    ExpectString(SkyUnitExpectation.GetExpectedString(ExpectationID)).To(EqualString("Foo"))

    ; PASS
    ExpectExpectation().ToPass(ExpectString("Hello World").To(ContainText("World")))
    ExpectDescription("ExpectString(\"Hello World\").To(ContainText(\"World\"))")
    ExpectActual("String", "Hello World")
    ExpectExpected("String", "World")
    ExpectString(SkyUnitExpectation.GetActualString(ExpectationID)).To(EqualString("Hello World"))
    ExpectString(SkyUnitExpectation.GetExpectedString(ExpectationID)).To(EqualString("World"))

    ; Not() FAIL
    ExpectExpectation().ToFail(ExpectString("Hello World").Not().To(ContainText("World")))
    ExpectDescription("ExpectString(\"Hello World\").Not().To(ContainText(\"World\"))")
    ExpectFailureMessage("Expected String \"Hello World\" not to contain text \"World\"")
    ExpectActual("String", "Hello World")
    ExpectExpected("String", "World")
    ExpectString(SkyUnitExpectation.GetActualString(ExpectationID)).To(EqualString("Hello World"))
    ExpectString(SkyUnitExpectation.GetExpectedString(ExpectationID)).To(EqualString("World"))

    ; Not() PASS
    ExpectExpectation().ToPass(ExpectString("Hello World").Not().To(ContainText("Foo")))
    ExpectDescription("ExpectString(\"Hello World\").Not().To(ContainText(\"Foo\"))")
    ExpectActual("String", "Hello World")
    ExpectExpected("String", "Foo")
    ExpectString(SkyUnitExpectation.GetActualString(ExpectationID)).To(EqualString("Hello World"))
    ExpectString(SkyUnitExpectation.GetExpectedString(ExpectationID)).To(EqualString("Foo"))
endFunction

; TODO FIXME
function Array_ContainText_Test()
    string[] myArray = new string[2]
    myArray[0] = "Hello"
    myArray[1] = "World"

    ; FAIL
    ExpectExpectation().ToFail(ExpectStringArray(myArray).To(ContainText("Foo")) )
    ExpectDescription("ExpectStringArray([\"Hello\", \"World\"]).To(ContainText(\"Foo\"))")
    ExpectFailureMessage("Expected StringArray [\"Hello\", \"World\"] to contain text \"Foo\"")
    ExpectActual("StringArray", "[\"Hello\", \"World\"]")
    ExpectExpected("String", "Foo")
    ExpectStringArray(SkyUnitExpectation.GetActualStringArray(ExpectationID)).To(EqualStringArray(myArray))
    ExpectString(SkyUnitExpectation.GetExpectedString(ExpectationID)).To(EqualString("Foo"))

    ; PASS
    ExpectExpectation().ToPass(ExpectStringArray(myArray).To(ContainText("World")))
    ExpectDescription("ExpectStringArray([\"Hello\", \"World\"]).To(ContainText(\"World\"))")
    ExpectActual("StringArray", "[\"Hello\", \"World\"]")
    ExpectExpected("String", "World")
    ExpectStringArray(SkyUnitExpectation.GetActualStringArray(ExpectationID)).To(EqualStringArray(myArray))
    ExpectString(SkyUnitExpectation.GetExpectedString(ExpectationID)).To(EqualString("World"))

    ; Not() FAIL
    ExpectExpectation().ToFail(ExpectStringArray(myArray).Not().To(ContainText("World")))
    ExpectDescription("ExpectStringArray([\"Hello\", \"World\"]).Not().To(ContainText(\"World\"))")
    ExpectFailureMessage("Expected StringArray [\"Hello\", \"World\"] not to contain text \"World\"")
    ExpectActual("StringArray", "[\"Hello\", \"World\"]")
    ExpectExpected("String", "World")
    ExpectStringArray(SkyUnitExpectation.GetActualStringArray(ExpectationID)).To(EqualStringArray(myArray))
    ExpectString(SkyUnitExpectation.GetExpectedString(ExpectationID)).To(EqualString("World"))

    ; Not() PASS
    ExpectExpectation().ToPass(ExpectStringArray(myArray).Not().To(ContainText("Foo")))
    ExpectDescription("ExpectStringArray([\"Hello\", \"World\"]).Not().To(ContainText(\"Foo\"))")
    ExpectActual("StringArray", "[\"Hello\", \"World\"]")
    ExpectExpected("String", "Foo")
    ExpectStringArray(SkyUnitExpectation.GetActualStringArray(ExpectationID)).To(EqualStringArray(myArray))
    ExpectString(SkyUnitExpectation.GetExpectedString(ExpectationID)).To(EqualString("Foo"))
endFunction