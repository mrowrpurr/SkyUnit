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
    ExpectInt(SkyUnit2.GetTestResultCount("Suite_One", ExampleTest1)).To(EqualInt(0))
    ExpectInt(SkyUnit2.GetLatestTestResult("Suite_One", ExampleTest1)).To(EqualInt(0))
    
    int result = SkyUnit2.RunTestScript("Suite_One", ExampleTest1)

    JValue.writeToFile(result, "ThisIsTheTestResult.json")

    ; ExpectInt(result).To(BeGreaterThan(0))
    ; ExpectInt(SkyUnit2.GetLatestTestResult("Suite_One", ExampleTest1)).To(EqualInt(result))

    ExpectStringArray(SkyUnit2.TestResult_GetTestNames(result)).To(HaveLength(4))
    ExpectStringArray(SkyUnit2.TestResult_GetTestNames(result)).To(ContainString(SkyUnit2.SpecialTestNameFor_BeforeAll()))
    ExpectStringArray(SkyUnit2.TestResult_GetTestNames(result)).To(ContainString(SkyUnit2.SpecialTestNameFor_AfterAll()))
    ExpectStringArray(SkyUnit2.TestResult_GetTestNames(result)).To(ContainString("Passing test with string expectation"))
    ExpectStringArray(SkyUnit2.TestResult_GetTestNames(result)).To(ContainString("Passing test with int expectation"))

    ;;;

    ; ExpectString(SkyUnit2.TestResult_GetTestStatus(result, "Passing test with string expectation")).To(EqualString(SkyUnit2.TestStatus_PASS()))
    ; ExpectString(SkyUnit2.TestResult_GetTestStatus(result, "Passing test with int expectation")).To(EqualString(SkyUnit2.TestStatus_PASS()))

    ; ExpectInt(SkyUnit2.TestResult_GetTestExpectationCount(result, "Passing test with string expectation")).To(EqualInt(1))
    ; ExpectString(SkyUnit2.TestResult_GetNthTestExpectationType(result, "Passing test with string expectation", 0)).To(EqualString("ExpectString"))

    ; ExpectInt(SkyUnit2.TestResult_GetTestExpectationCount(result, "Passing test with int expectation")).To(EqualInt(2))
    ; ExpectString(SkyUnit2.TestResult_GetNthTestExpectationType(result, "Passing test with int expectation", 0)).To(EqualString("ExpectInt"))
    ; ExpectString(SkyUnit2.TestResult_GetNthTestExpectationType(result, "Passing test with int expectation", 1)).To(EqualString("ExpectFloat"))
    ; TODO MORE
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
