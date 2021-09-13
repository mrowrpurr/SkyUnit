scriptName ArrayAssertions hidden
{SkyUnit test assertions for arrays}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expectations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SkyUnitTest function ExpectStringArray(string[] value) global
    SkyUnit2.BeginExpectation("ExpectStringArray")
    SkyUnit2.SetExpectationData_MainObject_StringArray(value)
    return SkyUnit2.CurrentTest()
endFunction

SkyUnitTest function ExpectIntArray(int[] value) global
    SkyUnit2.BeginExpectation("ExpectIntArray")
    SkyUnit2.SetExpectationData_MainObject_IntArray(value)
    return SkyUnit2.CurrentTest()
endFunction

SkyUnitTest function ExpectBoolArray(bool[] value) global
    SkyUnit2.BeginExpectation("ExpectBoolArray")
    SkyUnit2.SetExpectationData_MainObject_BoolArray(value)
    return SkyUnit2.CurrentTest()
endFunction

SkyUnitTest function ExpectFloatArray(float[] value) global
    SkyUnit2.BeginExpectation("ExpectFloatArray")
    SkyUnit2.SetExpectationData_MainObject_FloatArray(value)
    return SkyUnit2.CurrentTest()
endFunction

SkyUnitTest function ExpectFormArray(Form[] value) global
    SkyUnit2.BeginExpectation("ExpectFormArray")
    SkyUnit2.SetExpectationData_MainObject_FormArray(value)
    return SkyUnit2.CurrentTest()
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Assertions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function ContainBool(bool expected) global
    bool[] actual = SkyUnit.GetExpectationData_Object_BoolArray()
    bool found = false
    if actual
        int index = 0
        while index < actual.Length && ! found
            if actual[index] == expected
                found = true
            endIf
            index += 1
        endWhile
    endIf
    bool not = SkyUnit.Not()
    if not && found
        SkyUnit2.FailExpectation("ContainBool", "Expected " + actual + " not to contain '" + expected + "'")
        return
    elseIf ! not && ! found
        SkyUnit2.FailExpectation("ContainBool", "Expected " + actual + " to contain '" + expected + "'")
        return
    endIf
    SkyUnit2.PassExpectation("ContainBool")
endFunction

function ContainString(string expected) global
    string[] actual = SkyUnit.GetExpectationData_Object_StringArray()
    bool found = false
    if actual
        int index = 0
        while index < actual.Length && ! found
            if actual[index] == expected
                found = true
            endIf
            index += 1
        endWhile
    endIf
    bool not = SkyUnit.Not()
    if not && found
        SkyUnit2.FailExpectation("ContainString", "Expected " + actual + " not to contain '" + expected + "'")
        return
    elseIf ! not && ! found
        SkyUnit2.FailExpectation("ContainString", "Expected " + actual + " to contain '" + expected + "'")
        return
    endIf
    SkyUnit2.PassExpectation("ContainString")
endFunction

function ContainInt(int expected) global
    int[] actual = SkyUnit.GetExpectationData_Object_IntArray()
    bool found = false
    if actual
        int index = 0
        while index < actual.Length && ! found
            if actual[index] == expected
                found = true
            endIf
            index += 1
        endWhile
    endIf
    bool not = SkyUnit.Not()
    if not && found
        SkyUnit2.FailExpectation("ContainInt", "Expected " + actual + " not to contain '" + expected + "'")
        return
    elseIf ! not && ! found
        SkyUnit2.FailExpectation("ContainInt", "Expected " + actual + " to contain '" + expected + "'")
        return
    endIf
    SkyUnit2.PassExpectation("ContainInt")
endFunction

function ContainFloat(float expected) global
    float[] actual = SkyUnit.GetExpectationData_Object_FloatArray()
    bool found = false
    if actual
        int index = 0
        while index < actual.Length && ! found
            if actual[index] == expected
                found = true
            endIf
            index += 1
        endWhile
    endIf
    bool not = SkyUnit.Not()
    if not && found
        SkyUnit2.FailExpectation("ContainFloat", "Expected " + actual + " not to contain '" + expected + "'")
        return
    elseIf ! not && ! found
        SkyUnit2.FailExpectation("ContainFloat", "Expected " + actual + " to contain '" + expected + "'")
        return
    endIf
    SkyUnit2.PassExpectation("ContainFloat")
endFunction

function ContainForm(Form expected) global
    Form[] actual = SkyUnit.GetExpectationData_Object_FormArray()
    bool found = false
    if actual
        int index = 0
        while index < actual.Length && ! found
            if actual[index] == expected
                found = true
            endIf
            index += 1
        endWhile
    endIf
    bool not = SkyUnit.Not()
    if not && found
        SkyUnit2.FailExpectation("ContainForm", "Expected " + actual + " not to contain '" + expected + "'")
        return
    elseIf ! not && ! found
        SkyUnit2.FailExpectation("ContainForm", "Expected " + actual + " to contain '" + expected + "'")
        return
    endIf
    SkyUnit2.PassExpectation("ContainForm")
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Equal Array Assertions - String
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bool function EqualStringArray1(string a) global
    string[] expected = new string[1]
    expected[0] = a
    string[] actual = SkyUnit2.GetExpectationData_MainObject_StringArray()
    bool equal = true
    if actual && actual.Length == expected.Length && equal
        int index = 0
        while index < actual.Length
            if actual[index] != expected[index]
                equal = false
            endIf
            index += 1
        endWhile
    else
        equal = false ; can't be equal, not the same length
    endIf
    bool not = SkyUnit2.Not()
    if not && equal
        return SkyUnit2.FailExpectation("EqualStringArray1", "Expected StringArray " + actual + " not to equal StringArray " + expected)
    elseIf ! not && ! equal
        return SkyUnit2.FailExpectation("EqualStringArray1", "Expected StringArray " + actual + " to equal StringArray " + expected)
    endIf
    return SkyUnit2.PassExpectation("EqualStringArray1")
endFunction

bool function EqualStringArray2(string a, string b) global
    string[] expected = new string[2]
    expected[0] = a
    expected[1] = b
    string[] actual = SkyUnit2.GetExpectationData_MainObject_StringArray()
    bool equal = true
    if actual && actual.Length == expected.Length && equal
        int index = 0
        while index < actual.Length
            if actual[index] != expected[index]
                equal = false
            endIf
            index += 1
        endWhile
    else
        equal = false ; can't be equal, not the same length
    endIf
    bool not = SkyUnit2.Not()
    if not && equal
        return SkyUnit2.FailExpectation("EqualStringArray2", "Expected StringArray " + actual + " not to equal StringArray " + expected)
    elseIf ! not && ! equal
        return SkyUnit2.FailExpectation("EqualStringArray2", "Expected StringArray " + actual + " to equal StringArray " + expected)
    endIf
    return SkyUnit2.PassExpectation("EqualStringArray2")
endFunction

bool function EqualStringArray3(string a, string b, string c) global
    string[] expected = new string[3]
    expected[0] = a
    expected[1] = b
    expected[2] = c
    string[] actual = SkyUnit2.GetExpectationData_MainObject_StringArray()
    bool equal = true
    if actual && actual.Length == expected.Length && equal
        int index = 0
        while index < actual.Length
            if actual[index] != expected[index]
                equal = false
            endIf
            index += 1
        endWhile
    else
        equal = false ; can't be equal, not the same length
    endIf
    bool not = SkyUnit2.Not()
    if not && equal
        return SkyUnit2.FailExpectation("EqualStringArray3", "Expected StringArray " + actual + " not to equal StringArray " + expected)
    elseIf ! not && ! equal
        return SkyUnit2.FailExpectation("EqualStringArray3", "Expected StringArray " + actual + " to equal StringArray " + expected)
    endIf
    return SkyUnit2.PassExpectation("EqualStringArray3")
endFunction
