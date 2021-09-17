scriptName SkyUnitExpectation hidden
{Global functions used for implementing custom expectations.
This script is also used for implementing all built-in SkyUnit expectations.

Example Custom Expectation:

```
;TODO
```

Example Custom Assertion:

```
;TODO
```
}

; Returns the currently installed version of the SkyUnit expectation framework.
float function GetCurrentVersion()
    ; Not gonna lie, this is really just here because of a VSCode bug which
    ; prevents the documentation tooltip from working with the first function
    ; in a file and we *need* the documentation for every other function
    ; in this file to work for users.
    return SkyUnitPrivateAPI.CurrentVersion()
endFunction

; Begins a new expectation on the currently running test.
; This is **required** before you can use any of the expectation's data functions
; or `Pass` or `Fail` the expectation.
function BeginExpectation(string expectationType, int testId = 0) global
    if ! testId
        testId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentTestResult()
    endIf
    int expectations = SkyUnitPrivateAPI.SkyUnitData_CurrentExpectationsArray()
    int expectation = JMap.object()
    JArray.addObj(expectations, expectation)
    SkyUnitPrivateAPI.SkyUnitData_SetCurrentExpectation(expectation)
    JMap.setStr(expectation, "expectationType", expectationType)
    JMap.setStr(expectation, "status", "pending")
    JMap.setObj(expectation, "actual", JMap.object())
    JMap.setObj(expectation, "expected", JMap.object())
endFunction

; Marks the current expectation as a "Not" expectation.
; You **must** check whether or not your assertion is being run using "Not"
; by checking `SkyUnitExpectation.Not()` which returns true if the expectation
; is a "Not" expectation, e.g. created via `ExpectInt(42).Not().To(EqualInt(123))`
function ToggleNotExpectation(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        int not = JMap.getInt(expectationId, "not")
        if not == 1
            JMap.setInt(expectationId, "not", 0)
        else
            JMap.setInt(expectationId, "not", 1)
        endIf
    endIf
endFunction

; Used to check if the current expectation is a "Not" expectation
; e.g. created via `ExpectInt(42).Not().To(EqualInt(123))`
; You **must** check whether your custom assertions are being run as a "Not" assertion.
bool function Not(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getInt(expectationId, "not") == 1
    endIf
endFunction

; Gets the expectation "type" as set by `SkyUnitExpectation.Begin(<type>)`
; e.g. `"ExpectString"` for the `ExpectString()` expectation. 
string function GetExpectationType(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getStr(expectationId, "expectationType")
    endIf
endFunction

; Fails the current expectation.
; The `assertionType` is required and should generally match your custom
; assertion's function name, e.g. `"EqualString"` for the `EqualString()` assertion.
; You must use _either_ `Fail()` _or_ `Pass()` from your assertion.
bool function Fail(string assertionType, string failureMessage, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setStr(expectationId, "assertionType", assertionType)
        JMap.setStr(expectationId, "status", "failing")
        JMap.setStr(expectationId, "failureMessage", failureMessage)
    endIf
    return false
endFunction

; Fails the current expectation (optionally with the failure message)
; The `assertionType` is required and should generally match your custom
; assertion's function name, e.g. `"EqualString"` for the `EqualString()` assertion.
; You must use _either_ `Fail()` _or_ `Pass()` from your assertion.
bool function Pass(string assertionType, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setStr(expectationId, "assertionType", assertionType)
        JMap.setStr(expectationId, "status", "passing")
    endIf
    return true
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper for getting "Expected [Style] [Value]"
;; and "to equal [Style] [value]"
;; This returns the [Style] [value] bits.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

string function ExpectedDescription() global
    string type = GetExpectedType()
    if type == "String"
        return "String \"" + GetExpectedString() + "\""
    else
        return type + " " + GetExpectedText()
    endIf
endFunction

string function ActualDescription() global
    string type = GetActualType()
    if type == "String"
        return "String \"" + GetActualString() + "\""
    else
        return type + " " + GetActualText()
    endIf
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Storing Actual/Expected Data Type
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Gets the "data type" of the "actual value" (as provided to an `Expect*()` function)
; Intended to be called by an assertion function to check what type was provided.
string function GetActualType(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getStr(JMap.getObj(expectationId, "actual"), "type")
    endIf
endFunction

; Sets the "data type" of the "actual value" (intended to be called by an `Expect*()` function)
function SetActualType(string type, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setStr(JMap.getObj(expectationId, "actual"), "type", type)
    endIf
endFunction

; Gets the "data type" of the "expected value" (as provided to an assertion function)
string function GetExpectedType(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getStr(JMap.getObj(expectationId, "expected"), "type")
    endIf
endFunction

; Sets the "data type" of the "expected value"
function SetExpectedType(string type, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setStr(JMap.getObj(expectationId, "expected"), "type", type)
    endIf
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Storing Actual/Expected Value Text
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Gets a text, string representation of the "actual value" (as provided to an `Expect*()` function)
; Intended to be called by an assertion function to easily get text of what type was provided.
string function GetActualText(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getStr(JMap.getObj(expectationId, "actual"), "text")
    endIf
endFunction

; Sets a text, string representation of the "actual value" (intended to be called by an `Expect*()` function)
function SetActualText(string text, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setStr(JMap.getObj(expectationId, "actual"), "text", text)
    endIf
endFunction

; Gets a text, string representation of the "expected value" (as provided to an `Expect*()` function)
string function GetExpectedText(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getStr(JMap.getObj(expectationId, "expected"), "text")
    endIf
endFunction

; Sets a text, string representation of the "expected value"
function SetExpectedText(string text, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setStr(JMap.getObj(expectationId, "expected"), "text", text)
    endIf
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Storing Actual/Expected Values
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Gets the "actual value" (as provided to an `Expect*()` function) [String version]
; Intended to be called by an assertion function to easily get text of what type was provided.
; Note: there can only be 1 "actual value", e.g. either a String or an Int (or JContainer data object) etc
string function GetActualString(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getStr(JMap.getObj(expectationId, "actual"), "data")
    endIf
endFunction

; Sets the "actual value" (as provided to an `Expect*()` function) [String version]
; Intended to be called by an assertion function to get the data which is being asserted on.
; Note: there can only be 1 "actual value", e.g. either a String or an Int (or JContainer data object) etc
function SetActualString(string value, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setStr(JMap.getObj(expectationId, "actual"), "data", value)
        if autoSetText
            SetActualText(value)
        endIf
    endIf
endFunction

; Gets the "expected value" [String version]
; Note: there can only be 1 "expected value", e.g. either a String or an Int (or JContainer data object) etc
string function GetExpectedString(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getStr(JMap.getObj(expectationId, "expected"), "data")
    endIf
endFunction

; Sets the "expected value" [String version]
function SetExpectedString(string value, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setStr(JMap.getObj(expectationId, "expected"), "data", value)
        if autoSetText
            SetActualText(value)
        endIf
    endIf
endFunction

; Gets the "actual value" (as provided to an `Expect*()` function) [Int version]
; Intended to be called by an assertion function to easily get text of what type was provided.
; Note: there can only be 1 "actual value", e.g. either a Int or an Int (or JContainer data object) etc
int function GetActualInt(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getInt(JMap.getObj(expectationId, "actual"), "data")
    endIf
endFunction

; Sets the "actual value" (as provided to an `Expect*()` function) [Int version]
; Intended to be called by an assertion function to get the data which is being asserted on.
; Note: there can only be 1 "actual value", e.g. either a Int or an Int (or JContainer data object) etc
function SetActualInt(int value, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setInt(JMap.getObj(expectationId, "actual"), "data", value)
        if autoSetText
            SetActualText(value)
        endIf
    endIf
endFunction

; Gets the "expected value" [Int version]
; Note: there can only be 1 "expected value", e.g. either a Int or an Int (or JContainer data object) etc
int function GetExpectedInt(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getInt(JMap.getObj(expectationId, "expected"), "data")
    endIf
endFunction

; Sets the "expected value" [Int version]
function SetExpectedInt(int value, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setInt(JMap.getObj(expectationId, "expected"), "data", value)
        if autoSetText
            SetActualText(value)
        endIf
    endIf
endFunction

; Gets the "actual value" (as provided to an `Expect*()` function) [JObject version]
; JObjectended to be called by an assertion function to easily get text of what type was provided.
; Note: there can only be 1 "actual value", e.g. either a JObject or an JObject (or JContainer data object) etc
int function GetActualJObject(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getObj(JMap.getObj(expectationId, "actual"), "data")
    endIf
endFunction

; Sets the "actual value" (as provided to an `Expect*()` function) [JObject version]
; JObjectended to be called by an assertion function to get the data which is being asserted on.
; Note: there can only be 1 "actual value", e.g. either a JObject or an JObject (or JContainer data object) etc
function SetActualJObject(int value, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setObj(JMap.getObj(expectationId, "actual"), "data", value)
        if autoSetText
            SetActualText(value)
        endIf
    endIf
endFunction

; Gets the "expected value" [JObject version]
; Note: there can only be 1 "expected value", e.g. either a JObject or an JObject (or JContainer data object) etc
int function GetExpectedJObject(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getObj(JMap.getObj(expectationId, "expected"), "data")
    endIf
endFunction

; Sets the "expected value" [JObject version]
function SetExpectedJObject(int value, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setObj(JMap.getObj(expectationId, "expected"), "data", value)
        if autoSetText
            SetActualText(value)
        endIf
    endIf
endFunction

; Gets the "actual value" (as provided to an `Expect*()` function) [Bool version]
; Boolended to be called by an assertion function to easily get text of what type was provided.
; Note: there can only be 1 "actual value", e.g. either a Bool or an Bool (or JContainer data object) etc
bool function GetActualBool(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getInt(JMap.getObj(expectationId, "actual"), "data") == 1
    endIf
endFunction

; Sets the "actual value" (as provided to an `Expect*()` function) [Bool version]
; Boolended to be called by an assertion function to get the data which is being asserted on.
; Note: there can only be 1 "actual value", e.g. either a Bool or an Bool (or JContainer data object) etc
function SetActualBool(bool value, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        if value
            JMap.setInt(JMap.getObj(expectationId, "actual"), "data", 1)
            if autoSetText
                SetActualText("true")
            endIf
        else
            JMap.setInt(JMap.getObj(expectationId, "actual"), "data", 0)
            if autoSetText
                SetActualText("false")
            endIf
        endIf
    endIf
endFunction

; Gets the "expected value" [Bool version]
; Note: there can only be 1 "expected value", e.g. either a Bool or an Bool (or JContainer data object) etc
bool function GetExpectedBool(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getInt(JMap.getObj(expectationId, "expected"), "data") == 1
    endIf
endFunction

; Sets the "expected value" [Bool version]
function SetExpectedBool(bool value, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        if value
            JMap.setInt(JMap.getObj(expectationId, "expected"), "data", 1)
            if autoSetText
                SetActualText("true")
            endIf
        else
            JMap.setInt(JMap.getObj(expectationId, "expected"), "data", 0)
            if autoSetText
                SetActualText("false")
            endIf
        endIf
    endIf
endFunction

; Gets the "actual value" (as provided to an `Expect*()` function) [Float version]
; Floatended to be called by an assertion function to easily get text of what type was provided.
; Note: there can only be 1 "actual value", e.g. either a Float or an Float (or JContainer data object) etc
float function GetActualFloat(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getFlt(JMap.getObj(expectationId, "actual"), "data")
    endIf
endFunction

; Sets the "actual value" (as provided to an `Expect*()` function) [Float version]
; Floatended to be called by an assertion function to get the data which is being asserted on.
; Note: there can only be 1 "actual value", e.g. either a Float or an Float (or JContainer data object) etc
function SetActualFloat(float value, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setFlt(JMap.getObj(expectationId, "actual"), "data", value)
        if autoSetText
            SetActualText(value)
        endIf
    endIf
endFunction

; Gets the "expected value" [Float version]
; Note: there can only be 1 "expected value", e.g. either a Float or an Float (or JContainer data object) etc
float function GetExpectedFloat(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getFlt(JMap.getObj(expectationId, "expected"), "data")
    endIf
endFunction

; Sets the "expected value" [Float version]
function SetExpectedFloat(float value, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setFlt(JMap.getObj(expectationId, "expected"), "data", value)
        if autoSetText
            SetActualText(value)
        endIf
    endIf
endFunction

; Gets the "actual value" (as provided to an `Expect*()` function) [Form version]
; Formended to be called by an assertion function to easily get text of what type was provided.
; Note: there can only be 1 "actual value", e.g. either a Form or an Form (or JContainer data object) etc
Form function GetActualForm(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getForm(JMap.getObj(expectationId, "actual"), "data")
    endIf
endFunction

; Gets the "type" of the "actual value" Form, e.g. Actor -vs- Spell -vs- Weapon etc
; Formended to be called by an assertion function to easily get text of what type was provided.
; Note: there can only be 1 "actual value", e.g. either a Form or an Form (or JContainer data object) etc
string function GetActualFormType(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getForm(JMap.getObj(expectationId, "actual"), "formType")
    endIf
endFunction

; Sets the "actual value" (as provided to an `Expect*()` function) [Form version]
; Formended to be called by an assertion function to get the data which is being asserted on.
; Note: there can only be 1 "actual value", e.g. either a Form or an Form (or JContainer data object) etc
function SetActualForm(Form value, string type, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setForm(JMap.getObj(expectationId, "actual"), "data", value)
        JMap.setStr(JMap.getObj(expectationId, "actual"), "formType", type)
        if autoSetText
            SetActualText(value)
        endIf
    endIf
endFunction

; Gets the "expected value" [Form version]
; Note: there can only be 1 "expected value", e.g. either a Form or an Form (or JContainer data object) etc
Form function GetExpectedForm(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getForm(JMap.getObj(expectationId, "expected"), "data")
    endIf
endFunction

; Gets the "type" of the "g value" Form, e.g. Actor -vs- Spell -vs- Weapon etc
; Note: there can only be 1 "expected value", e.g. either a Form or an Form (or JContainer data object) etc
string function GetExpectedFormType(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getForm(JMap.getObj(expectationId, "expected"), "formType")
    endIf
endFunction

; Sets the "expected value" [Form version]
function SetExpectedForm(Form value, string type, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setForm(JMap.getObj(expectationId, "expected"), "data", value)
        JMap.setStr(JMap.getObj(expectationId, "expected"), "formType", type)
        if autoSetText
            SetActualText(value)
        endIf
    endIf
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Values which cannot be stored in JContainers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Gets the "actual value" (as provided to an `Expect*()` function) [Alias version]
; Aliasended to be called by an assertion function to easily get text of what type was provided.
; Note: there can only be 1 "actual value", e.g. either a Alias or an Alias (or JContainer data object) etc
;
; **[Alias] Special Note:** only one Alias can be set at a time.
; This shouldn't matter in most scenarios.
; The Alias will NOT be stored in the data structure which stores test results.
; _Implementation detail: JContainers cannot store aliases_
; Because this cannot be saved in the data result, we only use Actual and not Expected.
Alias function GetActualAlias(int expectationId = 0) global
    return SkyUnitPrivateAPI.GetInstance().CurrentExpectationActualValue_Alias
endFunction

; Sets the "actual value" (as provided to an `Expect*()` function) [Alias version]
; Aliasended to be called by an assertion function to get the data which is being asserted on.
; Note: there can only be 1 "actual value", e.g. either a Alias or an Alias (or JContainer data object) etc
;
; **[Alias] Special Note:** only one Alias can be set at a time.
; This shouldn't matter in most scenarios.
; The Alias will NOT be stored in the data structure which stores test results.
; _Implementation detail: JContainers cannot store aliases_
; Because this cannot be saved in the data result, we only use Actual and not Expected.
function SetActualAlias(Alias value, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        SkyUnitPrivateAPI.GetInstance().CurrentExpectationActualValue_Alias = value
        if autoSetText
            SetActualText(value)
        endIf
    endIf
endFunction

; Gets the "actual value" (as provided to an `Expect*()` function) [ActiveMagicEffect version]
; ActiveMagicEffectended to be called by an assertion function to easily get text of what type was provided.
; Note: there can only be 1 "actual value", e.g. either a ActiveMagicEffect or an ActiveMagicEffect (or JContainer data object) etc
;
; **[ActiveMagicEffect] Special Note:** only one ActiveMagicEffect can be set at a time.
; This shouldn't matter in most scenarios.
; The ActiveMagicEffect will NOT be stored in the data structure which stores test results.
; _Implementation detail: JContainers cannot store aliases_
; Because this cannot be saved in the data result, we only use Actual and not Expected.
ActiveMagicEffect function GetActualActiveMagicEffect(int expectationId = 0) global
    return SkyUnitPrivateAPI.GetInstance().CurrentExpectationActualValue_ActiveMagicEffect
endFunction

; Sets the "actual value" (as provided to an `Expect*()` function) [ActiveMagicEffect version]
; ActiveMagicEffectended to be called by an assertion function to get the data which is being asserted on.
; Note: there can only be 1 "actual value", e.g. either a ActiveMagicEffect or an ActiveMagicEffect (or JContainer data object) etc
;
; **[ActiveMagicEffect] Special Note:** only one ActiveMagicEffect can be set at a time.
; This shouldn't matter in most scenarios.
; The ActiveMagicEffect will NOT be stored in the data structure which stores test results.
; _Implementation detail: JContainers cannot store aliases_
; Because this cannot be saved in the data result, we only use Actual and not Expected.
function SetActualActiveMagicEffect(ActiveMagicEffect value, bool autoSetText = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        SkyUnitPrivateAPI.GetInstance().CurrentExpectationActualValue_ActiveMagicEffect = value
        if autoSetText
            SetActualText(value)
        endIf
    endIf
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Storing Actual/Expected Array Values
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; TODO ;
