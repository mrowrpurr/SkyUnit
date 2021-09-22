scriptName SkyUnitTests_Assertions_Generic extends SkyUnitAssertionTestBase
{Tests for generic assertions which work for various types, e.g. `ContainsText("")`}

function Tests()
    Test("ContainText")
    Test("HaveLength")
    Test("BeEmpty")
    Test("BeTrue")
    Test("BeFalse")
endFunction

function ContainText_Test()
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

function HaveLength_Test()
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

function BeEmpty_Test()
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

function BeTrue_Test()
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

function BeFalse_Test()
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
