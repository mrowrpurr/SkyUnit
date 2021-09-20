scriptName SkyUnitTests_TestBasics extends SkyUnitAssertionTestBase
{Tests for some basic test functionality including BeforeEach/BeforeAll/AfterEach/AfterAll}

function Tests()
    Test("Run - ExampleTest1").Fn(Run_ExampleTest1_Test())
    Test("Run - ExampleTest2")
    Test("RunTest")
    Test("BeforeEach")
    Test("AfterEach")
    Test("BeforeAll")
    Test("AfterAll")
endFunction

; TODO update ExpectInt(.Length) to HaveLength() etc etc etc once those assertions have tests

function Run_ExampleTest1_Test()
    SkyUnit_ExampleTest1 testScript = SkyUnitTestExamples.GetExampleTest1().ResetTests()

    string expectedLogs = "[\"Before All\", \"Begin Tests\", \"Test(Passing Test 1)\", \"Before Each\", \"Begin Passing Test 1\", \"End Passing Test 1\", \"After Each\", \"Test(Failing Test 1)\", \"Before Each\", \"Failing Passing Test 1\", \"Failing Passing Test 1\", \"After Each\", \"Test(Pending Test 1)\", \"Before Each\", \"End Tests\", \"After Each\", \"After All\"]"
    Refute(testScript.TestLogs == expectedLogs, "Expected TestLogs not to equal " + expectedLogs + " but was " + testScript.TestLogs)

    SwitchToContext_Fake()
    SkyUnitPrivateAPI.RegisterTestSuite(testScript)
    int testResult = testScript.Run()
    SwitchToContext_Real()

    Assert(testScript.TestLogs == expectedLogs, "Expected TestLogs to equal " + expectedLogs + " but was " + testScript.TestLogs)
endFunction
