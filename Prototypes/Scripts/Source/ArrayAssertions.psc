scriptName ArrayAssertions hidden
{SkyUnit test assertions for arrays}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expectations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SkyUnitTest function ExpectStringArray(string[] value) global
    SkyUnit.BeginExpectation("ExpectStringArray")
    SkyUnit.SetExpectationData_MainObject_StringArray(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectIntArray(int[] value) global
    SkyUnit.BeginExpectation("ExpectIntArray")
    SkyUnit.SetExpectationData_MainObject_IntArray(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectBoolArray(bool[] value) global
    SkyUnit.BeginExpectation("ExpectBoolArray")
    SkyUnit.SetExpectationData_MainObject_BoolArray(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectFloatArray(float[] value) global
    SkyUnit.BeginExpectation("ExpectFloatArray")
    SkyUnit.SetExpectationData_MainObject_FloatArray(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectFormArray(Form[] value) global
    SkyUnit.BeginExpectation("ExpectFormArray")
    SkyUnit.SetExpectationData_MainObject_FormArray(value)
    return SkyUnit.CurrentTest()
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Assertions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bool function ContainBool(bool expected) global
    bool[] actual = SkyUnit.GetExpectationData_MainObject_BoolArray()
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
        return SkyUnit.FailExpectation("ContainBool", "Expected BoolArray " + actual + " not to contain " + expected)
    elseIf ! not && ! found
        return SkyUnit.FailExpectation("ContainBool", "Expected BoolArray " + actual + " to contain " + expected)
    endIf
    return SkyUnit.PassExpectation("ContainBool")
endFunction

bool function ContainString(string expected) global
    string[] actual = SkyUnit.GetExpectationData_MainObject_StringArray()
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
        return SkyUnit.FailExpectation("ContainString", "Expected StringArray " + actual + " not to contain '" + expected + "'")
    elseIf ! not && ! found
        return SkyUnit.FailExpectation("ContainString", "Expected StringArray " + actual + " to contain '" + expected + "'")
    endIf
    return SkyUnit.PassExpectation("ContainString")
endFunction

bool function ContainInt(int expected) global
    int[] actual = SkyUnit.GetExpectationData_MainObject_IntArray()
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
        return SkyUnit.FailExpectation("ContainInt", "Expected IntArray " + actual + " not to contain " + expected)
    elseIf ! not && ! found
        return SkyUnit.FailExpectation("ContainInt", "Expected IntArray " + actual + " to contain " + expected)
    endIf
    return SkyUnit.PassExpectation("ContainInt")
endFunction

bool function ContainFloat(float expected) global
    float[] actual = SkyUnit.GetExpectationData_MainObject_FloatArray()
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
        return SkyUnit.FailExpectation("ContainFloat", "Expected FloatArray " + actual + " not to contain " + expected)
    elseIf ! not && ! found
        return SkyUnit.FailExpectation("ContainFloat", "Expected FloatArray " + actual + " to contain " + expected)
    endIf
    return SkyUnit.PassExpectation("ContainFloat")
endFunction

bool function ContainForm(Form expected) global
    Form[] actual = SkyUnit.GetExpectationData_MainObject_FormArray()
    string expectedName = "None"
    if expected
        expectedName = expected.GetName()
    endIf
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
        return SkyUnit.FailExpectation("ContainForm", "Expected FormArray " + actual + " not to contain " + expectedName + " " + expected)
    elseIf ! not && ! found
        return SkyUnit.FailExpectation("ContainForm", "Expected FormArray " + actual + " to contain " + expectedName + " " + expected)
    endIf
    return SkyUnit.PassExpectation("ContainForm")
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Equal Array Assertions - String
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bool function EqualStringArray1(string a) global
    string[] expected = new string[1]
    expected[0] = a
    string[] actual = SkyUnit.GetExpectationData_MainObject_StringArray()
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
    bool not = SkyUnit.Not()
    if not && equal
        return SkyUnit.FailExpectation("EqualStringArray1", "Expected StringArray " + actual + " not to equal StringArray " + expected)
    elseIf ! not && ! equal
        return SkyUnit.FailExpectation("EqualStringArray1", "Expected StringArray " + actual + " to equal StringArray " + expected)
    endIf
    return SkyUnit.PassExpectation("EqualStringArray1")
endFunction

bool function EqualStringArray2(string a, string b) global
    string[] expected = new string[2]
    expected[0] = a
    expected[1] = b
    string[] actual = SkyUnit.GetExpectationData_MainObject_StringArray()
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
    bool not = SkyUnit.Not()
    if not && equal
        return SkyUnit.FailExpectation("EqualStringArray2", "Expected StringArray " + actual + " not to equal StringArray " + expected)
    elseIf ! not && ! equal
        return SkyUnit.FailExpectation("EqualStringArray2", "Expected StringArray " + actual + " to equal StringArray " + expected)
    endIf
    return SkyUnit.PassExpectation("EqualStringArray2")
endFunction

bool function EqualStringArray3(string a, string b, string c) global
    string[] expected = new string[3]
    expected[0] = a
    expected[1] = b
    expected[2] = c
    string[] actual = SkyUnit.GetExpectationData_MainObject_StringArray()
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
    bool not = SkyUnit.Not()
    if not && equal
        return SkyUnit.FailExpectation("EqualStringArray3", "Expected StringArray " + actual + " not to equal StringArray " + expected)
    elseIf ! not && ! equal
        return SkyUnit.FailExpectation("EqualStringArray3", "Expected StringArray " + actual + " to equal StringArray " + expected)
    endIf
    return SkyUnit.PassExpectation("EqualStringArray3")
endFunction
