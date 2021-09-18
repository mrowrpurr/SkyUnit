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
    JMap.setStr(expectation, "status", "PENDING")
    JMap.setObj(expectation, "actual", JMap.object())
    JMap.setObj(expectation, "expected", JMap.object())
    JMap.setInt(expectation, "testResultId", testId)
endFunction

; If you want to *store* expectations for any reason, you can do:
; 
; ```
; ExpectString("Hello").To(EqualString("World"))
; int expectation = SkyUnitExpectation.LatestExpectationID()
; ```
;
; This returns an identifier which can be used with any of the `SkyUnitExpectation`
; functions which Get/Set Actual/Expected data, e.g.
;
; ```
; Debug.Trace(GetActualType(expectation))
; ; => "String"
; Debug.Trace(GetActualString(expectation))
; ; => "Hello
; Debug.Trace(GetExpectedString(expectation))
; ; => "World
; ```
;
; This low-level interface is mostly intended for usage by SkyUnit UI and test reporters.
;
; _It is also used in the SkyUnit test suite to test that SkyUnit functions correctly._
int function LatestExpectationID() global
    return SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
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

; Returns the currently running test.
; Every `Expect*()` function **MUST** return a `SkyUnitTest` using this function.
;
; Example:
;
; ```
; SkyUnitTest function ExpectSomething(Something thing) global
;   bool not = SkyUnitExpectation.Not()
;   ; ... <your expectation logic> ...
;   return SkyUnitExpectation.CurrentTest()
; endFunction
; ```
SkyUnitTest function CurrentTest() global
    SkyUnitPrivateAPI.Info("CurrentTest() " + SkyUnitPrivateAPI.SkyUnitData_GetCurrentTestScript())
    return SkyUnitPrivateAPI.SkyUnitData_GetCurrentTestScript()
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

; Gets the assertion "type" as set by `SkyUnitExpectation.Fail(<type>)` or `SkyUnitExpectation.Pass(<type>)`
string function GetAssertionType(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        return JMap.getStr(expectationId, "assertionType")
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
        JMap.setStr(expectationId, "status", "FAILING")
        JMap.setStr(expectationId, "failureMessage", failureMessage)
        ; Mark the test as FAILING if any expectation fails
        int testResultId = JMap.getInt(expectationId, "testResultId")
        JMap.setStr(testResultId, "status", "FAILING")
        ; And mark the whole suite test result as FAILING as well
        int testSuiteResultId = JMap.getInt(testResultId, "testSuiteResultId")
        JMap.setStr(testSuiteResultId, "status", "FAILING")
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
        JMap.setStr(expectationId, "status", "PASSING")
    endIf
    return true
endFunction

; Using an "Expectation identifier" retrieved via `LatestExpectationID()`
; this function will return the status of the expectation which will be
; one of: `PENDING`, `PASSING`, `FAILING`.
;
; The `PENDING` status will only be present if an `Expect*()` function was called with no assertion function
; or if the assertion function forgot to call `SkyUnitExpectation.Fail()` or `SkyUnitExpectation.Pass()`
string function GetStatus(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    return JMap.getStr(expectationId, "status")
endFunction

; Using an "Expectation identifier" retrieved via `LatestExpectationID()`
; this function will return the failure message of the expectation, if any.
string function GetFailureMessage(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    return JMap.getStr(expectationId, "failureMessage")
endFunction

; Returns the total number of expectations for the given test result.
; Can be used to create test reporters or custom UIs which display test results.
; Used by the built-in SkyUnit UI for displaying expectation results.
int function GetExpectationCount(int testResult) global
    SkyUnitPrivateAPI.Info("Get Expectation Count from " + testResult)
    JValue.writeToFile(testResult, "ThisIsTheTestResult.json")
    return JArray.count(JMap.getObj(testResult, "expectations"))
endFunction

; Returns the Nth expectation at the specified index of the test result.
; Use `GetExpectationCount()` to get the total count of expectations for a test.
; Can be used to create test reporters or custom UIs which display test results.
; Used by the built-in SkyUnit UI for displaying expectation results.
int function GetNthExpectation(int testResult, int index) global
    SkyUnitPrivateAPI.Info("Get Nth Expectation from result " + testResult + " N = " + index)
    return JArray.getObj(JMap.getObj(testResult, "expectations"), index)
endFunction

; Returns a text representation of a given expectation.
; Uses the provided expectation and assertion types and the provided expectation and assertion data.
string function GetDescription(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    SkyUnitPrivateAPI.Info("Get Description of expectation " + expectationId)
    string description = ""
    description += GetExpectationType(expectationId) + "(" + GetActualText(expectationId) + ")"
    if IsNotExpectation(expectationId)
        description += ".Not()"
    endIf
    description += ".To("
    description += GetAssertionType(expectationId) + "(" + GetExpectedText(expectationId) + ")"
    description += ")"
    return description
endFunction

; Returns whether the given expectation is a "Not" expectation.
; Used by the built-in SkyUnit UI for displaying expectation results.
bool function IsNotExpectation(int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    return JMap.getInt(expectationId, "not") == 1
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
    SkyUnitPrivateAPI.Info("Get Actual Type " + expectationId)
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
function SetActualString(string value, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setStr(JMap.getObj(expectationId, "actual"), "data", value)
        if autoSetText
            SetActualText(value, expectationId)
        endIf
        if autoSetType
            SetActualType("String", expectationId)
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
function SetExpectedString(string value, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setStr(JMap.getObj(expectationId, "expected"), "data", value)
        if autoSetText
            SetActualText(value, expectationId)
        endIf
        if autoSetType
            SetActualType("String", expectationId)
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
function SetActualInt(int value, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setInt(JMap.getObj(expectationId, "actual"), "data", value)
        if autoSetText
            SetActualText(value, expectationId)
        endIf
        if autoSetType
            SetActualType("Int", expectationId)
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
function SetExpectedInt(int value, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setInt(JMap.getObj(expectationId, "expected"), "data", value)
        if autoSetText
            SetActualText(value, expectationId)
        endIf
        if autoSetType
            SetActualType("Int", expectationId)
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
function SetActualJObject(int value, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setObj(JMap.getObj(expectationId, "actual"), "data", value)
        if autoSetText
            SetActualText(value, expectationId)
        endIf
        if autoSetType
            SetActualType("JObject", expectationId)
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
function SetExpectedJObject(int value, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setObj(JMap.getObj(expectationId, "expected"), "data", value)
        if autoSetText
            SetActualText(value, expectationId)
        endIf
        if autoSetType
            SetActualType("JObject", expectationId)
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
function SetActualBool(bool value, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
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
        if autoSetType
            SetActualType("Bool", expectationId)
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
function SetExpectedBool(bool value, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
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
        if autoSetType
            SetActualType("Bool", expectationId)
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
function SetActualFloat(float value, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setFlt(JMap.getObj(expectationId, "actual"), "data", value)
        if autoSetText
            SetActualText(value, expectationId)
        endIf
        if autoSetType
            SetActualType("Float", expectationId)
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
function SetExpectedFloat(float value, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setFlt(JMap.getObj(expectationId, "expected"), "data", value)
        if autoSetText
            SetActualText(value, expectationId)
        endIf
        if autoSetType
            SetActualType("Float", expectationId)
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
function SetActualForm(Form value, string type, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setForm(JMap.getObj(expectationId, "actual"), "data", value)
        JMap.setStr(JMap.getObj(expectationId, "actual"), "formType", type)
        if autoSetText
            SetActualText(value, expectationId)
        endIf
        if autoSetType
            SetActualType("Form", expectationId)
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
function SetExpectedForm(Form value, string type, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        JMap.setForm(JMap.getObj(expectationId, "expected"), "data", value)
        JMap.setStr(JMap.getObj(expectationId, "expected"), "formType", type)
        if autoSetText
            SetActualText(value, expectationId)
        endIf
        if autoSetType
            SetActualType("Form", expectationId)
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
function SetActualAlias(Alias value, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        SkyUnitPrivateAPI.GetInstance().CurrentExpectationActualValue_Alias = value
        if autoSetText
            SetActualText(value, expectationId)
        endIf
        if autoSetType
            SetActualType("Alias", expectationId)
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
function SetActualActiveMagicEffect(ActiveMagicEffect value, bool autoSetText = true, bool autoSetType = true, int expectationId = 0) global
    if ! expectationId
        expectationId = SkyUnitPrivateAPI.SkyUnitData_GetCurrentExpectation()
    endIf
    if expectationId
        SkyUnitPrivateAPI.GetInstance().CurrentExpectationActualValue_ActiveMagicEffect = value
        if autoSetText
            SetActualText(value, expectationId)
        endIf
        if autoSetType
            SetActualType("ActiveMagicEffect", expectationId)
        endIf
    endIf
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Storing Actual/Expected Array Values
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; TODO ;
