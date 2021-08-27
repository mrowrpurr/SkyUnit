scriptName FormAssertions hidden
{SkyUnit test assertions for Forms}

SkyUnitTest function ExpectFormName(Form theForm) global
    SkyUnit.BeginExpectation("ExpectFormName", theForm)
    SkyUnit.SetExpectationForm("Form", theForm)
    Actor theActor = theForm as Actor
    if theActor
        SkyUnit.SetExpectationObjectString(theActor.GetActorBase().GetName())
    else
        SkyUnit.SetExpectationObjectString(theForm.GetName())
    endIf
endFunction