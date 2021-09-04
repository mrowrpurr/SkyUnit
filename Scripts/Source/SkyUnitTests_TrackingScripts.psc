scriptName SkyUnitTests_TrackingScripts extends SkyUnit2_BaseTest
{Tests for registering and tracking SkyUnit2Test scripts}

import ArrayAssertions

function Tests()
    Test("Can register test scripts").Fn(CanRegisterTestScripts_Test())
    Test("Different instances of SkyUnit have different sets of test scripts").Fn(DifferenceTestSuitesWithDifferentScripts_Test())
    Test("Can get a test suite's script by name").Fn(GetScriptFromTestSuite_Test())
    Test("Can get the names of all test scripts in a test suite").Fn(GetNamesOfAllTestSuiteScripts_Test())
    ; Test("Can register over a thousand test scripts")
endFunction

function CanRegisterTestScripts_Test()
    SkyUnit2.CreateTestSuite("MySuite")

    SkyUnit2.AddScriptToTestSuite("MySuite", ExampleTest1)

    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("MySuite")).To(EqualStringArray1("SkyUnitTests_ExampleTest1"))

    SkyUnit2.AddScriptToTestSuite("MySuite", ExampleTest2)

    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("MySuite")).To(ContainString("SkyUnitTests_ExampleTest1"))
    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("MySuite")).To(ContainString("SkyUnitTests_ExampleTest2"))
endFunction

function DifferenceTestSuitesWithDifferentScripts_Test()
    SkyUnit2.CreateTestSuite("Suite_One")
    SkyUnit2.CreateTestSuite("Suite_Two")

    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("Suite_One")).To(BeEmpty())
    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("Suite_Two")).To(BeEmpty())

    SkyUnit2.AddScriptToTestSuite("Suite_One", ExampleTest1)
    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("Suite_One")).To(EqualStringArray1("SkyUnitTests_ExampleTest1"))
    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("Suite_Two")).To(BeEmpty())

    SkyUnit2.AddScriptToTestSuite("Suite_Two", ExampleTest2)
    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("Suite_One")).To(EqualStringArray1("SkyUnitTests_ExampleTest1"))
    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("Suite_Two")).To(EqualStringArray1("SkyUnitTests_ExampleTest2"))

    SkyUnit2.AddScriptToTestSuite("Suite_Two", ExampleTest3)
    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("Suite_One")).To(EqualStringArray1("SkyUnitTests_ExampleTest1"))
    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("Suite_Two")).To(EqualStringArray2("SkyUnitTests_ExampleTest2", "SkyUnitTests_ExampleTest3"))
endFunction

function GetScriptFromTestSuite_Test()
    SkyUnit2.CreateTestSuite("Suite_One")
    SkyUnit2.CreateTestSuite("Suite_Two")

    SkyUnit2Test test = SkyUnit2.GetTestSuiteScript("Suite_One", "SkyUnitTests_ExampleTest1")
    ExpectForm(test).To(BeNone())

    SkyUnit2.AddScriptToTestSuite("Suite_One", ExampleTest1)

    test = SkyUnit2.GetTestSuiteScript("Suite_One", "SkyUnitTests_ExampleTest1")
    ExpectForm(test).To(EqualForm(ExampleTest1))

    ; But another suite doesn't see the same one
    test = SkyUnit2.GetTestSuiteScript("Suite_Two", "SkyUnitTests_ExampleTest1")
    ExpectForm(test).To(BeNone())
endFunction

function GetNamesOfAllTestSuiteScripts_Test()
    SkyUnit2.CreateTestSuite("Suite_One")
    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("Suite_One")).To(BeEmpty())

    SkyUnit2.AddScriptToTestSuite("Suite_One", ExampleTest1)
    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("Suite_One")).To(EqualStringArray1("SkyUnitTests_ExampleTest1"))

    SkyUnit2.AddScriptToTestSuite("Suite_One", ExampleTest2)
    ExpectStringArray(SkyUnit2.GetTestSuiteScriptNames("Suite_One")).To(EqualStringArray2("SkyUnitTests_ExampleTest1", "SkyUnitTests_ExampleTest2"))
endFunction
