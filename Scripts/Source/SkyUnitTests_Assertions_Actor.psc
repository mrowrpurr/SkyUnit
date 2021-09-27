scriptName SkyUnitTests_Assertions_Actor extends SkyUnitAssertionTestBase
{Tests for Actor assertions, e.g. `BeAlive()`}

function Tests()
    Test("ExpectActor / EqualActor")
    Test("BeAlive")
    Test("BeDead")
    Test("HaveItem").Fn(HaveItem_Test())
    Test("HavePerk")
    Test("HaveSpell")
    Test("HaveEquipped")
    Test("HaveEquippedSpell")
endFunction

function HaveItem_Test()
    Form lockpick = Game.GetForm(0xa)
    string playerDescription = Player.GetActorBase().GetName() + " [Actor < (00000014)>]"
    string lockpickDescription = "Lockpick [MiscObject < (0000000a)>]"

    Player.RemoveItem(lockpick, 999)

    ; Fail
    ExpectExpectation().ToFail(ExpectPlayer().To(HaveItem(lockpick)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").To(HaveItem(" + lockpickDescription + "))")
    ExpectFailureMessage("Expected Actor " + playerDescription + " to have item " + lockpickDescription)
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", lockpickDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Game.GetPlayer()))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(lockpick))

    Player.AddItem(lockpick, 1)

    ; Pass
    ExpectExpectation().ToPass(ExpectPlayer().To(HaveItem(lockpick)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").To(HaveItem(" + lockpickDescription + "))")
    ExpectFailureMessage("")
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", lockpickDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Game.GetPlayer()))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(lockpick))

    ; Not() Fail
    ExpectExpectation().ToFail(ExpectPlayer().Not().To(HaveItem(lockpick)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").Not().To(HaveItem(" + lockpickDescription + "))")
    ExpectFailureMessage("Expected Actor " + playerDescription + " not to have item " + lockpickDescription)
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", lockpickDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Game.GetPlayer()))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(lockpick))

    Player.RemoveItem(lockpick, 999)
    
    ; Not() Pass
    ExpectExpectation().ToPass(ExpectPlayer().Not().To(HaveItem(lockpick)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").Not().To(HaveItem(" + lockpickDescription + "))")
    ExpectFailureMessage("")
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", lockpickDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Game.GetPlayer()))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(lockpick))
endFunction
