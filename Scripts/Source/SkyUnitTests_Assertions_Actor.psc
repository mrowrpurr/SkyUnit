scriptName SkyUnitTests_Assertions_Actor extends SkyUnitAssertionTestBase
{Tests for Actor assertions, e.g. `BeAlive()`}

function Tests()
    Test("ExpectActor / EqualActor")
    Test("BeAlive")
    Test("BeDead")
    Test("HaveItem").Fn(HaveItem_Test())
    Test("HavePerk")
    Test("HaveSpell")
    Test("HaveEquippedItem").Fn(HaveEquippedItem_Test())
    Test("HaveEquippedItemSpell")
endFunction

function HaveItem_Test()
    Form lockpick = Game.GetForm(0xa)
    string lockpickDescription = "Lockpick [MiscObject < (0000000a)>]"
    string playerDescription = Player.GetActorBase().GetName() + " [Actor < (00000014)>]"

    Player.RemoveItem(lockpick, 999, abSilent = true)

    ; Fail
    ExpectExpectation().ToFail(ExpectPlayer().To(HaveItem(lockpick)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").To(HaveItem(" + lockpickDescription + "))")
    ExpectFailureMessage("Expected Actor " + playerDescription + " to have item " + lockpickDescription)
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", lockpickDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(lockpick))

    Player.AddItem(lockpick, 1, abSilent = true)

    ; Pass
    ExpectExpectation().ToPass(ExpectPlayer().To(HaveItem(lockpick)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").To(HaveItem(" + lockpickDescription + "))")
    ExpectFailureMessage("")
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", lockpickDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(lockpick))

    ; Not() Fail
    ExpectExpectation().ToFail(ExpectPlayer().Not().To(HaveItem(lockpick)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").Not().To(HaveItem(" + lockpickDescription + "))")
    ExpectFailureMessage("Expected Actor " + playerDescription + " not to have item " + lockpickDescription)
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", lockpickDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(lockpick))

    Player.RemoveItem(lockpick, 999, abSilent = true)

    ; Not() Pass
    ExpectExpectation().ToPass(ExpectPlayer().Not().To(HaveItem(lockpick)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").Not().To(HaveItem(" + lockpickDescription + "))")
    ExpectFailureMessage("")
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", lockpickDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(lockpick))
endFunction

function HaveEquippedItem_Test()
    Form ironDagger = Game.GetForm(0x1397E)
    string ironDaggerDescription = "Iron Dagger [Weapon < (0001397E)>]"
    string playerDescription = Player.GetActorBase().GetName() + " [Actor < (00000014)>]"

    Player.UnequipItem(ironDagger, abSilent = true)

    ; Fail
    ExpectExpectation().ToFail(ExpectPlayer().To(HaveEquippedItem(ironDagger)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").To(HaveEquippedItem(" + ironDaggerDescription + "))")
    ExpectFailureMessage("Expected Actor " + playerDescription + " to have item equipped " + ironDaggerDescription)
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", ironDaggerDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(ironDagger))

    Player.EquipItem(ironDagger, abSilent = true)

    ; Pass
    ExpectExpectation().ToPass(ExpectPlayer().To(HaveEquippedItem(ironDagger)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").To(HaveEquippedItem(" + ironDaggerDescription + "))")
    ExpectFailureMessage("")
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", ironDaggerDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(ironDagger))

    ; Not() Fail
    ExpectExpectation().ToFail(ExpectPlayer().Not().To(HaveEquippedItem(ironDagger)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").Not().To(HaveEquippedItem(" + ironDaggerDescription + "))")
    ExpectFailureMessage("Expected Actor " + playerDescription + " not to have item equipped " + ironDaggerDescription)
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", ironDaggerDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(ironDagger))

    Player.UnequipItem(ironDagger, abSilent = true)

    ; Not() Pass
    ExpectExpectation().ToPass(ExpectPlayer().Not().To(HaveEquippedItem(ironDagger)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").Not().To(HaveEquippedItem(" + ironDaggerDescription + "))")
    ExpectFailureMessage("")
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", ironDaggerDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(ironDagger))
endFunction
