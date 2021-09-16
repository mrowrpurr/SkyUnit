scriptName ExampleTest1 extends SkyUnitTest

function Tests()
    Test("My passing test").Fn(PassingTest())
    Test("My pending test")
    Test("My failing test").Fn(FailingTest())
endFunction

function PassingTest()
    SkyUnitAPI.Info("PassingTest()")
    ; Nothing for right now
endFunction

function FailingTest()
    SkyUnitAPI.Info("FailingTest()")
    Fail("Oh jeez. This failed.")
endFunction
