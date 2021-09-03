scriptName SkyUnitTests_TrackingScripts extends SkyUnitTests_BaseTest
{Tests for registering and tracking SkyUnitTest scripts}

import ArrayAssertions

function Tests()
    Test("Can register test scripts").Fn(CanRegisterTestScripts_Test())
    Test("Different instances of SkyUnit have different sets of test scripts")
    Test("Can get a SkyUnit instance's script by name")
    Test("Can get the names of all test scripts in a SkyUnit instance")
    Test("Can clear an instance's list of scripts")
    Test("Can register over a thousand test scripts")
endFunction

function CanRegisterTestScripts_Test()
    SkyUnit2.CreateTestSuite("MySuite")

    SkyUnit2.AddScriptToTestSuite("MySuite", ExampleTest1)

    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("MySuite")).To(EqualStringArray1("SkyUnitTests_ExampleTest1"))

    SkyUnit2.AddScriptToTestSuite("MySuite", ExampleTest2)

    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("MySuite")).To(ContainString("SkyUnitTests_ExampleTest1"))
    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("MySuite")).To(ContainString("SkyUnitTests_ExampleTest2"))
endFunction

; function DifferenceTestSuitesWithDifferentScripts_Test()
;     SkyUnit2TestSuite testSuite = SkyUnit2.CreateTestSuite("MySuite")

; endFunction
