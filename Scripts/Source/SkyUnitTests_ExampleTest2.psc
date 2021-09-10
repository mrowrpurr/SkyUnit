scriptName SkyUnitTests_ExampleTest2 extends SkyUnitTest
{Example SkyUnitTest used by other tests.
DO NOT modify the Tests() in this.}

bool property OnePassingOneFailing auto

function Tests()
    if OnePassingOneFailing ; Only run these tests when we're doing it manually from our tests
        Test("Simple string passing").Fn(Passing_SimpleStringAssertion())
        Test("Simple int failing").Fn(Failing_SimpleIntAssertions())
    endIf
endFunction

function Passing_SimpleStringAssertion()
    ExpectString("Fourty Two").To(EqualString("Fourty Two"))
endFunction

function Failing_SimpleIntAssertions()
    ExpectInt(42).To(EqualInt(12345))
endFunction
