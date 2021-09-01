scriptName ArrayAssertions hidden
{SkyUnit test assertions for arrays}

SkyUnitTest function ExpectStringArray(string[] value) global
    SkyUnit.BeginExpectation("ExpectStringArray")
    SkyUnit.SetExpectationData_Object_StringArray(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectIntArray(int[] value) global
    SkyUnit.BeginExpectation("ExpectIntArray")
    SkyUnit.SetExpectationData_Object_IntArray(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectBoolArray(bool[] value) global
    SkyUnit.BeginExpectation("ExpectBoolArray")
    SkyUnit.SetExpectationData_Object_BoolArray(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectFloatArray(float[] value) global
    SkyUnit.BeginExpectation("ExpectFloatArray")
    SkyUnit.SetExpectationData_Object_FloatArray(value)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectFormArray(Form[] value) global
    SkyUnit.BeginExpectation("ExpectFormArray")
    SkyUnit.SetExpectationData_Object_FormArray(value)
    return SkyUnit.CurrentTest()
endFunction

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
        SkyUnit.FailExpectation("Expected " + actual + " not to contain '" + expected + "'")
    elseIf ! not && ! found
        SkyUnit.FailExpectation("Expected " + actual + " to contain '" + expected + "'")
    endIf
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
        SkyUnit.FailExpectation("Expected " + actual + " not to contain '" + expected + "'")
    elseIf ! not && ! found
        SkyUnit.FailExpectation("Expected " + actual + " to contain '" + expected + "'")
    endIf
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
        SkyUnit.FailExpectation("Expected " + actual + " not to contain '" + expected + "'")
    elseIf ! not && ! found
        SkyUnit.FailExpectation("Expected " + actual + " to contain '" + expected + "'")
    endIf
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
        SkyUnit.FailExpectation("Expected " + actual + " not to contain '" + expected + "'")
    elseIf ! not && ! found
        SkyUnit.FailExpectation("Expected " + actual + " to contain '" + expected + "'")
    endIf
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
        SkyUnit.FailExpectation("Expected " + actual + " not to contain '" + expected + "'")
    elseIf ! not && ! found
        SkyUnit.FailExpectation("Expected " + actual + " to contain '" + expected + "'")
    endIf
endFunction

function EqualStringArray1(string a) global
    string[] expected = new string[1]
    expected[0] = a
    string[] actual = SkyUnit.GetExpectationData_Object_StringArray()
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
        SkyUnit.FailExpectation("Expected array " + actual + " not to equal " + expected)
    elseIf ! not && ! equal
        SkyUnit.FailExpectation("Expected array " + actual + " to equal " + expected)
    endIf
endFunction

function EqualStringArray2(string a, string b) global
    string[] expected = new string[2]
    expected[0] = a
    expected[1] = b
    string[] actual = SkyUnit.GetExpectationData_Object_StringArray()
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
        SkyUnit.FailExpectation("Expected array " + actual + " not to equal " + expected)
    elseIf ! not && ! equal
        SkyUnit.FailExpectation("Expected array " + actual + " to equal " + expected)
    endIf
endFunction

function EqualStringArray3(string a, string b, string c) global
    string[] expected = new string[3]
    expected[0] = a
    expected[1] = b
    expected[2] = c
    string[] actual = SkyUnit.GetExpectationData_Object_StringArray()
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
        SkyUnit.FailExpectation("Expected array " + actual + " not to equal " + expected)
    elseIf ! not && ! equal
        SkyUnit.FailExpectation("Expected array " + actual + " to equal " + expected)
    endIf
endFunction
