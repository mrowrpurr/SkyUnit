scriptName SkyUnitTests_RunningTests extends SkyUnit2_BaseTest
{Tests for running **SkyUnit** tests (functions) in `SkyUnit2Test` scripts}

import ArrayAssertions

function Tests()
    Test("Basic 'hello world' SkyUnit features are working test").Fn(TestVariousThings_HelloWorldSkyUnitFeatures_Test())
    ; Test("Filtering tests by name").Fn(FilteringTestsByName_Test())
    ; Test("Can run one passing test and a failing test").Fn(Example2_OnePassingOneFailing_Test())
endFunction

function AfterAll()
    parent.AfterAll()
    ExampleTest2.OnePassingOneFailing = false
endFunction

function TestVariousThings_HelloWorldSkyUnitFeatures_Test()
    SkyUnit2.CreateTestSuite("Suite_One", switchTo = true)
    SkyUnit2.AddScriptToTestSuite("Suite_One", ExampleTest1)
    ExpectInt(SkyUnit2.GetScriptTestResultCount("Suite_One", ExampleTest1)).To(EqualInt(0))
    ExpectInt(SkyUnit2.GetLatestScriptTestResult("Suite_One", ExampleTest1)).To(EqualInt(0))
    
    Debug.Trace("GONNA RUN ExampleTest1")
    SkyUnit2.SwitchToTestSuite("Suite_One")
    int result = SkyUnit2.RunTestScript("Suite_One", ExampleTest1)
    SkyUnit2.UseDefaultTestSuite()
    Debug.Trace("AFTER ExampleTest1")

    JValue.writeToFile(result, "ThisIsTheTestResult.json")

    ; ExpectInt(SkyUnit2.GetLatestTestResult("Suite_One", ExampleTest1)).To(EqualInt(result))

    Debug.Trace("ASSERTIONS FOR STUFFS")
    string[] testNames = SkyUnit2.ScriptTestResult_GetTestNames(result)
    ExpectStringArray(testNames).To(HaveLength(4))
    ExpectStringArray(testNames).To(ContainString(SkyUnit2.SpecialTestNameFor_BeforeAll()))
    ExpectStringArray(testNames).To(ContainString(SkyUnit2.SpecialTestNameFor_AfterAll()))
    ExpectStringArray(testNames).To(ContainString("Passing test with string expectation"))
    ExpectStringArray(testNames).To(ContainString("Passing test with int expectation"))

    int stringExpectationTest = SkyUnit2.ScriptTestResult_GetTestResult(result, "Passing test with string expectation")
    int intExpectationTest = SkyUnit2.ScriptTestResult_GetTestResult(result, "Passing test with int expectation")

    ; Pass/Fail for whole script + individual tests
    ExpectString(SkyUnit2.ScriptTestResult_GetScriptStatus(result)).To(EqualString(SkyUnit2.TestStatus_PASS()))
    ExpectString(SkyUnit2.TestResult_GetTestStatus(stringExpectationTest)).To(EqualString(SkyUnit2.TestStatus_PASS()))
    ExpectString(SkyUnit2.TestResult_GetTestStatus(intExpectationTest)).To(EqualString(SkyUnit2.TestStatus_PASS()))

    ; Expectations
    ExpectInt(SkyUnit2.TestResult_GetExpectationCount(stringExpectationTest)).To(EqualInt(1))
    ExpectString(SkyUnit2.TestResult_GetNthExpectationName(stringExpectationTest, 0)).To(EqualString("ExpectString"))

    ; Expectations
    ExpectInt(SkyUnit2.TestResult_GetExpectationCount(intExpectationTest)).To(EqualInt(2))
    ExpectString(SkyUnit2.TestResult_GetNthExpectationName(intExpectationTest, 0)).To(EqualString("ExpectInt"))
    ExpectString(SkyUnit2.TestResult_GetNthExpectationName(intExpectationTest, 1)).To(EqualString("ExpectFloat"))

    ; Expectations need to set data for assertions to use...
    ExpectString(SkyUnit2.TestResult_GetNthExpectationMainObjectType(stringExpectationTest, 0)).To(EqualString("string"))
    ExpectString(SkyUnit2.TestResult_GetNthExpectationMainObjectText(stringExpectationTest, 0)).To(EqualString("Hello"))
    ExpectString(SkyUnit2.TestResult_GetNthExpectationMainObjectType(intExpectationTest, 0)).To(EqualString("int"))
    ExpectString(SkyUnit2.TestResult_GetNthExpectationMainObjectText(intExpectationTest, 0)).To(EqualString("1"))
    ExpectString(SkyUnit2.TestResult_GetNthExpectationMainObjectType(intExpectationTest, 1)).To(EqualString("float"))
    ExpectString(SkyUnit2.TestResult_GetNthExpectationMainObjectText(intExpectationTest, 1)).To(ContainText("12.34"))

    ; Assertions
    ExpectString(SkyUnit2.TestResult_GetNthExpectationAssertionName(stringExpectationTest, 0)).To(EqualString("EqualString"))
    ExpectString(SkyUnit2.TestResult_GetNthExpectationAssertionName(intExpectationTest, 0)).To(EqualString("EqualInt"))
    ExpectString(SkyUnit2.TestResult_GetNthExpectationAssertionName(intExpectationTest, 1)).To(EqualString("EqualFloat"))
    Debug.Trace("END OF THE TEST")
endFunction

function FilteringTestsByName_Test()
    SkyUnit2.CreateTestSuite("Suite_One", switchTo = true)
    SkyUnit2.AddScriptToTestSuite("Suite_One", ExampleTest1)
    ExampleTest2.OnePassingOneFailing = false
    SkyUnit2.AddScriptToTestSuite("Suite_One", ExampleTest2)
    
    int result = SkyUnit2.RunTestScript("Suite_One", ExampleTest1, filter = "Simple")
    string[] testNames = SkyUnit2.ScriptTestResult_GetTestNames(result)
    ExpectStringArray(testNames).To(HaveLength(4))
    ExpectStringArray(testNames).To(ContainString("Simple string passing"))
    ExpectStringArray(testNames).To(ContainString("Simple int failing"))
    ExpectStringArray(testNames).Not().To(ContainString("Passing test with string expectation"))
    ExpectStringArray(testNames).Not().To(ContainString("Passing test with int expectation"))

    result = SkyUnit2.RunTestScript("Suite_One", ExampleTest1, filter = "string")
    testNames = SkyUnit2.ScriptTestResult_GetTestNames(result)
    ExpectStringArray(testNames).To(HaveLength(4))
    ExpectStringArray(testNames).To(ContainString("Simple string passing"))
    ExpectStringArray(testNames).To(ContainString("Passing test with string expectation"))
    ExpectStringArray(testNames).Not().To(ContainString("Simple int failing"))
    ExpectStringArray(testNames).Not().To(ContainString("Passing test with int expectation"))

    result = SkyUnit2.RunTestScript("Suite_One", ExampleTest1, filter = "passing")
    testNames = SkyUnit2.ScriptTestResult_GetTestNames(result)
    ExpectStringArray(testNames).To(HaveLength(3))
    ExpectStringArray(testNames).To(ContainString("Simple string passing"))
    ExpectStringArray(testNames).Not().To(ContainString("Passing test with string expectation"))
    ExpectStringArray(testNames).Not().To(ContainString("Simple int failing"))
    ExpectStringArray(testNames).Not().To(ContainString("Passing test with int expectation"))
endFunction

function Example2_OnePassingOneFailing_Test()
    SkyUnit2.CreateTestSuite("Suite_One")
    SkyUnit2.AddScriptToTestSuite("Suite_One", ExampleTest2)

    ExampleTest2.OnePassingOneFailing = true
    int result = SkyUnit2.RunTestScript("Suite_One", ExampleTest2)
    ExampleTest2.OnePassingOneFailing = false

    string[] testNames = SkyUnit2.ScriptTestResult_GetTestNames(result)
    ExpectStringArray(testNames).To(ContainString("Simple string passing"))
    ExpectStringArray(testNames).To(ContainString("Simple int failing"))

    int passingTest = SkyUnit2.ScriptTestResult_GetTestResult(result, "Simple string passing")
    int failingTest = SkyUnit2.ScriptTestResult_GetTestResult(result, "Simple int failing")

    ; Pass/Fail for whole script + individual tests
    ExpectString(SkyUnit2.ScriptTestResult_GetScriptStatus(result)).To(EqualString(SkyUnit2.TestStatus_FAIL()))
    ExpectString(SkyUnit2.TestResult_GetTestStatus(passingTest)).To(EqualString(SkyUnit2.TestStatus_PASS()))
    ExpectString(SkyUnit2.TestResult_GetTestStatus(failingTest)).To(EqualString(SkyUnit2.TestStatus_FAIL()))

    ; Expectations

    ; Assertions

endFunction
