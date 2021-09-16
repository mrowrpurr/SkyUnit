scriptName SkyUnitTestExamples
{Script for controlling (enabling/disabling) example
test suite scripts and test functions for SkyUnit tests of itself!

The SkyUnitExampleTests quest is:
Quest: 0x808
Plugin: SkyUnitTests.esp}

function StartExamplesQuest() global
    GetSkyUnitExamplesQuest().Start()
endFunction

function StopExamplesQuest() global
    GetSkyUnitExamplesQuest().Stop()
endFunction

Quest function GetSkyUnitExamplesQuest() global
    return Game.GetFormFromFile(0x808, "SkyUnitTests.esp") as Quest
endFunction

SkyUnit_ExampleTest1 function ExampleTest1() global
    return GetSkyUnitExamplesQuest() as SkyUnit_ExampleTest1
endFunction

SkyUnit_ExampleTest2 function ExampleTest2() global
    return GetSkyUnitExamplesQuest() as SkyUnit_ExampleTest2
endFunction
