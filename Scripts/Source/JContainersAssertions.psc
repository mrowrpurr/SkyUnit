scriptName JContainersAssertions hidden
{SkyUnit assertions for working with JContainers data structures}

SkyUnitTest function ExpectJObject(int jobjectID) global
    SkyUnit.SetExpectationData_MainObject_JObject(jobjectID)
    return SkyUnit.CurrentTest()
endFunction

; ; JMap
; function HasKey(string keyName) global
; endFunction

; ; JIntMap
; function HasIntKey(int intKey) global
; endFunction

; ; JFormMap
; function HasFormKey(Form formKey) global
; endFunction
