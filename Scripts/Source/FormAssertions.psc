scriptName FormAssertions hidden
{SkyUnit test assertions for Forms}

SkyUnit2Test function ExpectFormName(Form theForm) global
    SkyUnit2.BeginExpectation("ExpectForm")
    SkyUnit.SetExpectationData_Object_Form(theForm)
    Actor theActor = theForm as Actor
    if theActor
        SkyUnit.SetExpectationData_Object_String(theActor.GetActorBase().GetName())
    else
        SkyUnit.SetExpectationData_Object_String(theForm.GetName())
    endIf
endFunction