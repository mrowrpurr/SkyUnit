scriptName SkyUnitTests_BaseTest extends SkyUnitTest
{Base test script for all SkyUnit tests for SkyUnit}

SkyUnitTests_ExampleTest1 _exampleTest1
SkyUnitTests_ExampleTest2 _exampleTest2
SkyUnitTests_ExampleTest3 _exampleTest3

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
