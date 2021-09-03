scriptName SkyUnitTests_RunningTests extends SkyUnitTests_BaseTest
{Tests for running **SkyUnit** tests (functions) in `SkyUnitTest` scripts}

import ArrayAssertions

function Tests()
    Test("Can run one passing test").Fn(RunOnePassingTest_Test())
    Test("Can run one passing test and a failing test")
endFunction

function RunOnePassingTest_Test()
    SkyUnit2.CreateTestSuite("Suite_One")
    SkyUnit2.AddScriptToTestSuite("Suite_One", ExampleTest1)
    ExpectInt(SkyUnit2.GetScriptTestResultCount("Suite_One", ExampleTest1)).To(EqualInt(0))
    ExpectInt(SkyUnit2.GetLatestScriptTestResult("Suite_One", ExampleTest1)).To(EqualInt(0))
    
    int result = SkyUnit2.RunTestScript("Suite_One", ExampleTest1)

    JValue.writeToFile(result, "ThisIsTheTestResult.json")

    ; ExpectInt(SkyUnit2.GetLatestTestResult("Suite_One", ExampleTest1)).To(EqualInt(result))

    string[] testNames = SkyUnit2.ScriptTestResult_GetTestNames(result)
    ExpectStringArray(testNames).To(HaveLength(4))
    ExpectStringArray(testNames).To(ContainString(SkyUnit2.SpecialTestNameFor_BeforeAll()))
    ExpectStringArray(testNames).To(ContainString(SkyUnit2.SpecialTestNameFor_AfterAll()))
    ExpectStringArray(testNames).To(ContainString("Passing test with string expectation"))
    ExpectStringArray(testNames).To(ContainString("Passing test with int expectation"))

    int stringExpectationTest = SkyUnit2.ScriptTestResult_GetTestResult(result, "Passing test with string expectation")
    int intExpectationTest = SkyUnit2.ScriptTestResult_GetTestResult(result, "Passing test with int expectation")

    ; We'll do test status AFTER getting the expectations AND assertions
    ; ExpectString(SkyUnit2.TestResult_GetTestStatus(result, "Passing test with string expectation")).To(EqualString(SkyUnit2.TestStatus_PASS()))
    ; ExpectString(SkyUnit2.TestResult_GetTestStatus(result, "Passing test with int expectation")).To(EqualString(SkyUnit2.TestStatus_PASS()))

    ; Expectations
    ExpectInt(SkyUnit2.TestResult_GetExpectationCount(stringExpectationTest)).To(EqualInt(1))
    ExpectString(SkyUnit2.TestResult_GetNthExpectationName(stringExpectationTest, 0)).To(EqualString("ExpectString"))

    ; Expectations
    ExpectInt(SkyUnit2.TestResult_GetExpectationCount(intExpectationTest)).To(EqualInt(2))
    ExpectString(SkyUnit2.TestResult_GetNthExpectationName(intExpectationTest, 0)).To(EqualString("ExpectInt"))
    ExpectString(SkyUnit2.TestResult_GetNthExpectationName(intExpectationTest, 1)).To(EqualString("ExpectFloat"))

    ; Assertions
    ExpectString(SkyUnit2.TestResult_GetNthExpectationAssertionName(stringExpectationTest, 0)).To(EqualString("EqualString"))
    ; ExpectString(SkyUnit2.TestResult_GetNthExpectationAssertionName(stringExpectationTest, 0)).To(EqualString("EqualString"))

    ; TODO MORE ~ then move this stuff into other tests :p
endFunction

; function PassingTestWithStringExpectation()
;     ExpectString("Hello").To(EqualString("Hello"))
; endFunction
; function PassingTestWithIntExpectation()
;     ExpectInt(1).To(EqualInt(1))
; endFunction



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Below are the implementations of the
;; tests which are "run on" our example
;; test scripts.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function PassingTest()
    ; Be sure that the testing context
    ; is switched from this ACTUAL TEST
    ; to this fake test (temporarily)
    ExpectString("Hello").To(EqualString("Hello"))
endFunction

function FailingTest()
    ; Be sure that the testing context
    ; is switched from this ACTUAL TEST
    ; to this fake test (temporarily)
    ExpectString("Hello").To(EqualString("NOT HELLO"))
endFunction
