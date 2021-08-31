scriptName FormAssertions hidden
{SkyUnit test assertions for Forms}

SkyUnitTest function ExpectFormName(Form theForm) global
    SkyUnit.BeginExpectation("ExpectForm")
    SkyUnit.SetExpectationData_Object_Form(theForm)
    Actor theActor = theForm as Actor
    if theActor
        SkyUnit.SetExpectationData_Object_String(theActor.GetActorBase().GetName())
    else
        SkyUnit.SetExpectationData_Object_String(theForm.GetName())
    endIf
endFunction