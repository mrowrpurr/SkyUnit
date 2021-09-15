scriptName SkyUnitTests_RunningTests extends SkyUnitTests_BaseTest
{Tests for running **SkyUnit** tests (functions) in `SkyUnitTest` scripts}

; TODO TEST TO MAKE SURE THAT FILTER *NEVER* SKIPS BEFOREALL / AFTERALL :)

import ArrayAssertions

function Tests()
    Test("Basic 'hello world' SkyUnit features are working test").Fn(TestVariousThings_HelloWorldSkyUnitFeatures_Test())
    Test("Filtering tests by name").Fn(FilteringTestsByName_Test())
    ; Test("Can run one passing test and a failing test").Fn(Example2_OnePassingOneFailing_Test())
endFunction

function AfterAll()
    parent.AfterAll()
    ExampleTest2.OnePassingOneFailing = false
endFunction

function TestVariousThings_HelloWorldSkyUnitFeatures_Test()
    SkyUnit.CreateTestSuite("Suite_One", switchTo = true)
    SkyUnit.AddScriptToTestSuite("Suite_One", ExampleTest1)
    ExpectInt(SkyUnit.GetScriptTestResultCount("Suite_One", ExampleTest1)).To(EqualInt(0))
    ExpectInt(SkyUnit.GetLatestScriptTestResult("Suite_One", ExampleTest1)).To(EqualInt(0))
    
    SkyUnit.SwitchToTestSuite("Suite_One")
    int result = SkyUnit.RunTestScript("Suite_One", ExampleTest1)
    SkyUnit.UseDefaultTestSuite()

    JValue.writeToFile(result, "ThisIsTheTestResult.json")

    ; ExpectInt(SkyUnit.GetLatestTestResult("Suite_One", ExampleTest1)).To(EqualInt(result))

    string[] testNames = SkyUnit.ScriptTestResult_GetTestNames(result)
    Debug.Trace("SkyUnit --- THE ARRAY IS: " + testNames)
    ExpectStringArray(testNames).To(HaveLength(4))
    ExpectStringArray(testNames).To(ContainString(SkyUnit.SpecialTestNameFor_BeforeAll()))
    ExpectStringArray(testNames).To(ContainString(SkyUnit.SpecialTestNameFor_AfterAll()))
    ExpectStringArray(testNames).To(ContainString("Passing test with string expectation"))
    ExpectStringArray(testNames).To(ContainString("Passing test with int expectation"))

    int stringExpectationTest = SkyUnit.ScriptTestResult_GetTestResult(result, "Passing test with string expectation")
    int intExpectationTest = SkyUnit.ScriptTestResult_GetTestResult(result, "Passing test with int expectation")

    ; Pass/Fail for whole script + individual tests
    ExpectString(SkyUnit.ScriptTestResult_GetScriptStatus(result)).To(EqualString(SkyUnit.TestStatus_PASS()))
    ExpectString(SkyUnit.TestResult_GetTestStatus(stringExpectationTest)).To(EqualString(SkyUnit.TestStatus_PASS()))
    ExpectString(SkyUnit.TestResult_GetTestStatus(intExpectationTest)).To(EqualString(SkyUnit.TestStatus_PASS()))

    ; Expectations
    ExpectInt(SkyUnit.TestResult_GetExpectationCount(stringExpectationTest)).To(EqualInt(1))
    ExpectString(SkyUnit.TestResult_GetNthExpectationName(stringExpectationTest, 0)).To(EqualString("ExpectString"))

    ; Expectations
    ExpectInt(SkyUnit.TestResult_GetExpectationCount(intExpectationTest)).To(EqualInt(2))
    ExpectString(SkyUnit.TestResult_GetNthExpectationName(intExpectationTest, 0)).To(EqualString("ExpectInt"))
    ExpectString(SkyUnit.TestResult_GetNthExpectationName(intExpectationTest, 1)).To(EqualString("ExpectFloat"))

    ; Expectations need to set data for assertions to use...
    ExpectString(SkyUnit.TestResult_GetNthExpectationMainObjectType(stringExpectationTest, 0)).To(EqualString("string"))
    ExpectString(SkyUnit.TestResult_GetNthExpectationMainObjectText(stringExpectationTest, 0)).To(EqualString("Hello"))
    ExpectString(SkyUnit.TestResult_GetNthExpectationMainObjectType(intExpectationTest, 0)).To(EqualString("int"))
    ExpectString(SkyUnit.TestResult_GetNthExpectationMainObjectText(intExpectationTest, 0)).To(EqualString("1"))
    ExpectString(SkyUnit.TestResult_GetNthExpectationMainObjectType(intExpectationTest, 1)).To(EqualString("float"))
    ExpectString(SkyUnit.TestResult_GetNthExpectationMainObjectText(intExpectationTest, 1)).To(ContainText("12.34"))

    ; Assertions
    ExpectString(SkyUnit.TestResult_GetNthExpectationAssertionName(stringExpectationTest, 0)).To(EqualString("EqualString"))
    ExpectString(SkyUnit.TestResult_GetNthExpectationAssertionName(intExpectationTest, 0)).To(EqualString("EqualInt"))
    ExpectString(SkyUnit.TestResult_GetNthExpectationAssertionName(intExpectationTest, 1)).To(EqualString("EqualFloat"))
endFunction

function FilteringTestsByName_Test()
    SkyUnit.CreateTestSuite("Suite_One", switchTo = true)
    SkyUnit.AddScriptToTestSuite("Suite_One", ExampleTest1)
    ExampleTest2.OnePassingOneFailing = false
    SkyUnit.AddScriptToTestSuite("Suite_One", ExampleTest2)
    
    int result = SkyUnit.RunTestScript("Suite_One", ExampleTest1, filter = "Simple")
    string[] testNames = SkyUnit.ScriptTestResult_GetTestNames(result)
    ExpectStringArray(testNames).To(HaveLength(4))
    ExpectStringArray(testNames).To(ContainString("Simple string passing"))
    ExpectStringArray(testNames).To(ContainString("Simple int failing"))
    ExpectStringArray(testNames).Not().To(ContainString("Passing test with string expectation"))
    ExpectStringArray(testNames).Not().To(ContainString("Passing test with int expectation"))

    result = SkyUnit.RunTestScript("Suite_One", ExampleTest1, filter = "string")
    testNames = SkyUnit.ScriptTestResult_GetTestNames(result)
    ExpectStringArray(testNames).To(HaveLength(4))
    ExpectStringArray(testNames).To(ContainString("Simple string passing"))
    ExpectStringArray(testNames).To(ContainString("Passing test with string expectation"))
    ExpectStringArray(testNames).Not().To(ContainString("Simple int failing"))
    ExpectStringArray(testNames).Not().To(ContainString("Passing test with int expectation"))

    result = SkyUnit.RunTestScript("Suite_One", ExampleTest1, filter = "passing")
    testNames = SkyUnit.ScriptTestResult_GetTestNames(result)
    ExpectStringArray(testNames).To(HaveLength(3))
    ExpectStringArray(testNames).To(ContainString("Simple string passing"))
    ExpectStringArray(testNames).Not().To(ContainString("Passing test with string expectation"))
    ExpectStringArray(testNames).Not().To(ContainString("Simple int failing"))
    ExpectStringArray(testNames).Not().To(ContainString("Passing test with int expectation"))
endFunction

function Example2_OnePassingOneFailing_Test()
    SkyUnit.CreateTestSuite("Suite_One")
    SkyUnit.AddScriptToTestSuite("Suite_One", ExampleTest2)

    ExampleTest2.OnePassingOneFailing = true
    int result = SkyUnit.RunTestScript("Suite_One", ExampleTest2)
    ExampleTest2.OnePassingOneFailing = false

    string[] testNames = SkyUnit.ScriptTestResult_GetTestNames(result)
    ExpectStringArray(testNames).To(ContainString("Simple string passing"))
    ExpectStringArray(testNames).To(ContainString("Simple int failing"))

    int passingTest = SkyUnit.ScriptTestResult_GetTestResult(result, "Simple string passing")
    int failingTest = SkyUnit.ScriptTestResult_GetTestResult(result, "Simple int failing")

    ; Pass/Fail for whole script + individual tests
    ExpectString(SkyUnit.ScriptTestResult_GetScriptStatus(result)).To(EqualString(SkyUnit.TestStatus_FAIL()))
    ExpectString(SkyUnit.TestResult_GetTestStatus(passingTest)).To(EqualString(SkyUnit.TestStatus_PASS()))
    ExpectString(SkyUnit.TestResult_GetTestStatus(failingTest)).To(EqualString(SkyUnit.TestStatus_FAIL()))

    ; Expectations

    ; Assertions

endFunction
