scriptName ActorAssertions hidden
{SkyUnit test assertions for Actors}

SkyUnitTest function ExpectActor(Actor theActor) global
    SkyUnit.BeginExpectation()
    SkyUnit.SetExpectationData_Form("Actor", theActor)
    return SkyUnit.CurrentTest()
endFunction

function BeAlive() global
    Actor theActor = SkyUnit.GetExpectationData_Form("Actor") as Actor
    bool not = SkyUnit.Not()
    if theActor
        if not && ! theActor.IsDead()
            SkyUnit.FailExpectation("Expected actor " + theActor.GetBaseObject().GetName() + " not to be alive")
        elseIf ! not && theActor.IsDead()
            SkyUnit.FailExpectation("Expected actor " + theActor.GetBaseObject().GetName() + " to be alive")
        endIf
    else
        SkyUnit.GetInstance().Log("BeAlive() called without ExpectActor()")
    endIf
endFunction

function BeDead() global
    Actor theActor = SkyUnit.GetExpectationData_Form("Actor") as Actor
    bool not = SkyUnit.Not()
    if theActor
        if not && theActor.IsDead()
            SkyUnit.FailExpectation("Expected actor " + theActor.GetBaseObject().GetName() + " not to be dead")
        elseIf ! not && ! theActor.IsDead()
            SkyUnit.FailExpectation("Expected actor " + theActor.GetBaseObject().GetName() + " to be dead")
        endIf
    else
        SkyUnit.GetInstance().Log("BeDead() called without ExpectActor()")
    endIf
endFunction

function HaveSpell(Spell theSpell) global
    Actor theActor = SkyUnit.GetExpectationData_Form("Actor") as Actor
    bool not = SkyUnit.Not()
    if theActor
        if not && theActor.HasSpell(theSpell)
            SkyUnit.FailExpectation("Expected actor " + theActor.GetBaseObject().GetName() + " not to have spell " + theSpell.GetName())
        elseIf ! not && ! theActor.HasSpell(theSpell)
            SkyUnit.FailExpectation("Expected actor " + theActor.GetBaseObject().GetName() + " to have spell " + theSpell.GetName())
        endIf
    else
        SkyUnit.GetInstance().Log("HaveSpell() called without ExpectActor()")
    endIf
endFunction

function HaveItem(Form item) global
    Actor theActor = SkyUnit.GetExpectationData_Form("Actor") as Actor
    bool not = SkyUnit.Not()
    if theActor
        if not && theActor.GetItemCount(item) > 0
            SkyUnit.FailExpectation("Expected actor " + theActor.GetBaseObject().GetName() + " not to have item " + item.GetName())
        elseIf ! not && theActor.GetItemCount(item) == 0
            SkyUnit.FailExpectation("Expected actor " + theActor.GetBaseObject().GetName() + " to have item " + item.GetName())
        endIf
    else
        SkyUnit.GetInstance().Log("HaveSpell() called without ExpectActor()")
    endIf
endFunction

; HaveItemEquipped
; HavePerk
