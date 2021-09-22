scriptName SkyUnitTests_Expectations_Data extends SkyUnitAssertionTestBase
{Tests for reading and writing data for expectations,
i.e. data written by Expect*() functions and ready by assertion functions}

function Tests()
    Test("Text")
    Test("String")
    Test("Int")
    Test("Float")
    Test("Bool")
    Test("Form")
    Test("StringArray")
    Test("IntArray")
    Test("FloatArray")
    Test("BoolArray")
    Test("FormArray")
endFunction

function String_Test()
    SetupFakeExpectation("String Test")
    SwitchToContext_Fake()
    

    SwitchToContext_Real()
endFunction