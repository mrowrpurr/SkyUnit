scriptName SkyUnitTests_TrackingScripts extends SkyUnitTests_BaseTest
{Tests for registering and tracking SkyUnitTest scripts}

import ArrayAssertions

function Tests()
    Test("Can register test scripts").Fn(CanRegisterTestScripts())
    Test("Different instances of SkyUnit have different sets of test scripts")
    Test("Can get a SkyUnit instance's script by name")
    Test("Can get the names of all test scripts in a SkyUnit instance")
    Test("Can clear an instance's list of scripts")
    Test("Can register over a thousand test scripts")
endFunction

function CanRegisterTestScripts()
    SkyUnit2TestSuite testSuite = SkyUnit2.CreateTestSuite("MySuite")
    ExpectInt(testSuite.ScriptCount).To(EqualInt(0))
    ExpectStringArray(testSuite.ScriptNames).To(BeEmpty())

    testSuite.AddScript(ExampleTest1)

    ExpectInt(testSuite.ScriptCount).To(EqualInt(1))
    ExpectStringArray(testSuite.ScriptNames).To(EqualStringArray1("ExampleTest1"))

    testSuite.AddScript(ExampleTest2)

    ExpectInt(testSuite.ScriptCount).To(EqualInt(2))
    ExpectStringArray(testSuite.ScriptNames).To(ContainString("ExampleTest1"))
    ExpectStringArray(testSuite.ScriptNames).To(ContainString("ExampleTest2"))
endFunction
