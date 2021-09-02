scriptName SkyUnit2Test extends Quest
{Base script for all SkyUnit test scripts.

e.g.
  scriptName MyCoolTest extends SkyUnitTest
  
  function Tests()
    Test("Pending test")
    Test("Failing test")
    Test("Passing test")
  endFunction

  function BeforeEach()
    ; This code runs before each test
    ; These functions are all available:
    ;    BeforeEach()
    ;    AfterEach()
    ;    BeforeAll()
    ;    AfterAll()
  endFunction

  function FailingTest()
    ExpectInt(42).To(EqualInt(12345))
  endFunction

  function PassingTest()
    ExpectString("Hello").To(ContainText("H"))
  endFunction
}