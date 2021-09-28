scriptName SkyUnitTests_Assertions_Actor extends SkyUnitAssertionTestBase
{Tests for Actor assertions, e.g. `BeAlive()`}

function Tests()
    Test("ExpectActor / EqualActor")
    Test("BeAlive")
    Test("BeDead")
    Test("HaveItem").Fn(HaveItem_Test())
    Test("HavePerk")
    Test("HaveSpell").Fn(HaveSpell_Test())
    Test("HaveEquippedItem").Fn(HaveEquippedItem_Test())
    Test("HaveEquippedItemSpell").Fn(HaveEquippedSpell_Test())
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

function HaveSpell_Test()
    Spell candlelight = Game.GetForm(0x43324) as Spell
    string candlelightDescription = "Candlelight [Spell < (00043324)>]"
    string playerDescription = Player.GetActorBase().GetName() + " [Actor < (00000014)>]"

    Player.RemoveSpell(candlelight)

    ; Fail
    ExpectExpectation().ToFail(ExpectPlayer().To(HaveSpell(candlelight)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").To(HaveSpell(" + candlelightDescription + "))")
    ExpectFailureMessage("Expected Actor " + playerDescription + " to have spell " + candlelightDescription)
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", candlelightDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(candlelight))

    Player.AddSpell(candlelight)

    ; Pass
    ExpectExpectation().ToPass(ExpectPlayer().To(HaveSpell(candlelight)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").To(HaveSpell(" + candlelightDescription + "))")
    ExpectFailureMessage("")
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", candlelightDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(candlelight))

    ; Not() Fail
    ExpectExpectation().ToFail(ExpectPlayer().Not().To(HaveSpell(candlelight)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").Not().To(HaveSpell(" + candlelightDescription + "))")
    ExpectFailureMessage("Expected Actor " + playerDescription + " not to have spell " + candlelightDescription)
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", candlelightDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(candlelight))

    Player.RemoveSpell(candlelight)

    ; Not() Pass
    ExpectExpectation().ToPass(ExpectPlayer().Not().To(HaveSpell(candlelight)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").Not().To(HaveSpell(" + candlelightDescription + "))")
    ExpectFailureMessage("")
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", candlelightDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(candlelight))
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

function HaveEquippedSpell_Test()
    Spell flames = Game.GetForm(0x12FCD) as Spell
    string flamesDescription = "Flames [Spell < (00012FCD)>]"
    string playerDescription = Player.GetActorBase().GetName() + " [Actor < (00000014)>]"

    Player.UnequipSpell(flames, 0)
    Player.UnequipSpell(flames, 1)

    ; Fail
    ExpectExpectation().ToFail(ExpectPlayer().To(HaveEquippedSpell(flames)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").To(HaveEquippedSpell(" + flamesDescription + "))")
    ExpectFailureMessage("Expected Actor " + playerDescription + " to have item equipped " + flamesDescription)
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", flamesDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(flames))

    Player.EquipSpell(flames, 0)

    ; Pass
    ExpectExpectation().ToPass(ExpectPlayer().To(HaveEquippedSpell(flames)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").To(HaveEquippedSpell(" + flamesDescription + "))")
    ExpectFailureMessage("")
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", flamesDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(flames))

    ; Not() Fail
    ExpectExpectation().ToFail(ExpectPlayer().Not().To(HaveEquippedSpell(flames)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").Not().To(HaveEquippedSpell(" + flamesDescription + "))")
    ExpectFailureMessage("Expected Actor " + playerDescription + " not to have item equipped " + flamesDescription)
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", flamesDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(flames))

    Player.UnequipSpell(flames, 0)
    Player.UnequipSpell(flames, 1)

    ; Not() Pass
    ExpectExpectation().ToPass(ExpectPlayer().Not().To(HaveEquippedSpell(flames)))
    ExpectDescription("ExpectPlayer(" + playerDescription + ").Not().To(HaveEquippedSpell(" + flamesDescription + "))")
    ExpectFailureMessage("")
    ExpectActual("Form", playerDescription)
    ExpectExpected("Form", flamesDescription)
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(Player))
    ExpectForm(SkyUnitExpectation.GetExpectedForm(ExpectationID)).To(EqualForm(flames))
endFunction
