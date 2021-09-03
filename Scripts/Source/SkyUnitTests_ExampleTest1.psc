scriptName SkyUnitTests_ExampleTest1 extends SkyUnit2Test
{Example SkyUnitTest used by other tests.
DO NOT modify the Tests() in this.}

function Tests()
    Test("Passing test with string expectation").Fn(PassingTestWithStringExpectation())
    Test("Passing test with int expectation").Fn(PassingTestWithIntExpectation())
endFunction

function PassingTestWithStringExpectation()
    ExpectString("Hello").To(EqualString("Hello"))
endFunction

function PassingTestWithIntExpectation()
    ExpectInt(1).To(EqualInt(2))
    ExpectFloat(12.34).To(EqualFloat(12.34))
endFunction
