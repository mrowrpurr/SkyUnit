scriptName ActorAssertions hidden
{SkyUnit test assertions for Actors}

SkyUnitTest function ExpectActor(Actor theActor) global
    SkyUnit2.BeginExpectation("ExpectActor")
    SkyUnit.SetExpectationData_Form("Actor", theActor) ; <---- REMOVE THIS SkyUnit Function Next!
    return SkyUnit2.CurrentTest()
endFunction

bool function BeAlive() global
    Actor theActor = SkyUnit.GetExpectationData_Form("Actor") as Actor
    bool not = SkyUnit.Not()
    if theActor
        if not && ! theActor.IsDead()
            return SkyUnit2.FailExpectation("BeAlive", "Expected actor " + theActor.GetBaseObject().GetName() + " not to be alive")
        elseIf ! not && theActor.IsDead()
            return SkyUnit2.FailExpectation("BeAlive", "Expected actor " + theActor.GetBaseObject().GetName() + " to be alive")
        endIf
    else
        return SkyUnit2.FailExpectation("BeAlive", "BeAlive() called without Actor. Use ExpectActor() or ExpectForm().")
    endIf
endFunction

bool function BeDead() global
    Actor theActor = SkyUnit.GetExpectationData_Form("Actor") as Actor
    bool not = SkyUnit.Not()
    if theActor
        if not && theActor.IsDead()
            return SkyUnit2.FailExpectation("BeDead", "Expected actor " + theActor.GetBaseObject().GetName() + " not to be dead")
        elseIf ! not && ! theActor.IsDead()
            return SkyUnit2.FailExpectation("BeDead", "Expected actor " + theActor.GetBaseObject().GetName() + " to be dead")
        endIf
    else
        return SkyUnit2.FailExpectation("BeDead", "BeDead() called without Actor. Use ExpectActor() or ExpectForm().")
    endIf
endFunction

bool function HaveSpell(Spell theSpell) global
    Actor theActor = SkyUnit.GetExpectationData_Form("Actor") as Actor
    bool not = SkyUnit.Not()
    if theActor
        if not && theActor.HasSpell(theSpell)
            return SkyUnit2.FailExpectation("HaveSpell", "Expected actor " + theActor.GetBaseObject().GetName() + " not to have spell " + theSpell.GetName())
        elseIf ! not && ! theActor.HasSpell(theSpell)
            return SkyUnit2.FailExpectation("HaveSpell", "Expected actor " + theActor.GetBaseObject().GetName() + " to have spell " + theSpell.GetName())
        endIf
    else
        return SkyUnit2.FailExpectation("HaveSpell", "HaveSpell() called without Actor. Use ExpectActor() or ExpectForm().")
    endIf
endFunction

bool function HaveItem(Form item) global
    Actor theActor = SkyUnit.GetExpectationData_Form("Actor") as Actor
    bool not = SkyUnit.Not()
    if theActor
        if not && theActor.GetItemCount(item) > 0
            return SkyUnit2.FailExpectation("HaveItem", "Expected actor " + theActor.GetBaseObject().GetName() + " not to have item " + item.GetName())
        elseIf ! not && theActor.GetItemCount(item) == 0
            return SkyUnit2.FailExpectation("HaveItem", "Expected actor " + theActor.GetBaseObject().GetName() + " to have item " + item.GetName())
        endIf
    else
        return SkyUnit2.FailExpectation("HaveItem", "HaveItem() called without Actor. Use ExpectActor() or ExpectForm().")
    endIf
endFunction

; HavePerk
