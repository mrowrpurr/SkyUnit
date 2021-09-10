scriptName SkyUnitTests_BaseTest extends SkyUnitTest hidden
{Base SkyUnit test for testing SkyUnit tests}

SkyUnitTests_ExampleTest1 _exampleTest1
SkyUnitTests_ExampleTest2 _exampleTest2
SkyUnitTests_ExampleTest3 _exampleTest3

function BeforeEach()
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    api.DeleteAllTestSuitesExceptDefault()
    FAKE_TEST_SUITE_NAME = "[Fake Test Suite for Testing] - " + Utility.RandomInt(1, 1000) + "_" + Utility.RandomInt(1, 1000)
    SkyUnit2.CreateTestSuite(FAKE_TEST_SUITE_NAME)
    SwitchTo_Default_TestSuite()
endFunction

function AfterAll()
    SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
    api.DeleteAllTestSuitesExceptDefault()
endFunction

string property FAKE_TEST_SUITE_NAME auto
bool _fakeTestSuiteCreated

function SwitchTo_Fake_TestSuite()
    if ! _fakeTestSuiteCreated
        SkyUnit2.CreateTestSuite(FAKE_TEST_SUITE_NAME)
        _fakeTestSuiteCreated = true
    endIf
    SkyUnit2.SwitchToTestSuite(FAKE_TEST_SUITE_NAME)
endFunction

function SwitchTo_Default_TestSuite()
    SkyUnit2.UseDefaultTestSuite()
endFunction

SkyUnitTests_ExampleTest1 property ExampleTest1
    SkyUnitTests_ExampleTest1 function get()
        if ! _exampleTest1
            _exampleTest1 = Game.GetFormFromFile(0x801, "SkyUnitTests.esp") as SkyUnitTests_ExampleTest1
        endIf
        return _exampleTest1
    endFunction
endProperty

SkyUnitTests_ExampleTest2 property ExampleTest2
    SkyUnitTests_ExampleTest2 function get()
        if ! _exampleTest2
            _exampleTest2 = Game.GetFormFromFile(0x801, "SkyUnitTests.esp") as SkyUnitTests_ExampleTest2
        endIf
        return _exampleTest2
    endFunction
endProperty

SkyUnitTests_ExampleTest3 property ExampleTest3
    SkyUnitTests_ExampleTest3 function get()
        if ! _exampleTest3
            _exampleTest3 = Game.GetFormFromFile(0x801, "SkyUnitTests.esp") as SkyUnitTests_ExampleTest3
        endIf
        return _exampleTest3
    endFunction
endProperty
