scriptName SkyUnit_BasicTests extends SkyUnitAssertionTestBase
{Basic tests for loading test suite scripts, test functions,
getting test names, running test suite scripts, and getting the results.}


; TODO RENAME THIS


function Tests()
    Test("Starting quest automatically registers test suite scripts").Fn(StartingQuestRegistersTestScripts_Test())
    Test("Get test suite names") ; .Fn(GetTestSuiteNames_Test())
    Test("Test test names for a single test suite")
    Test("Reload test names for a single test")
    Test("Getting test suite results - all passing")
    Test("Getting test suite results - one pending")
    Test("Getting test suite results - one failing")

    ; Use counters and current context checking to test these
    ; e.g. CurrentTestName
    Test("BeforeEach")
    Test("AfterEach")
    Test("BeforeAll")
    Test("AfterAll")
endFunction

function StartingQuestRegistersTestScripts_Test()
    SkyUnitPrivateAPI.DeleteContext("fake")
    
    SwitchToContext_Fake()
    string[] testSuites = SkyUnitPrivateAPI.TestSuites()
    SwitchToContext_Real()
    
    Assert(testSuites.Length == 0, "Expected fake context to have no loaded test suites " + testSuites)

    ; Switch to Fake so the initialized scripts will register themselves into the fake context
    SwitchToContext_Fake()

    ; Start quest
    SkyUnitTestExamples.StartExamplesQuest()

    ; Wait for the ExampleTest1 and ExampleTest2 scripts to be loaded
    ; Wait for 1 whole second which is hopefully enough (because we don't have closures/lambdas to make AssertWait())
    Utility.WaitMenuMode(1.0)
    testSuites = SkyUnitPrivateAPI.TestSuites()

    SwitchToContext_Real()
    Assert(testSuites.Length == 2, "Expected 2 test suites to get loaded " + testSuites)
    Assert(testSuites.Find("SkyUnit_ExampleTest1") > -1, "Expected test suite SkyUnit_ExampleTest1 to be loaded " + testSuites)
    Assert(testSuites.Find("SkyUnit_ExampleTest2") > -1, "Expected test suite SkyUnit_ExampleTest2 to be loaded " + testSuites)
endFunction

function GetTestSuiteNames_Test()
    ; SwitchToContext_Fake()
    ; Assert(SkyUnitPrivateAPI.TestSuites().Length == 0, "Expected fake context to have no loaded test suites")

    ; ; Start 
    ; SkyUnitTestExamples.StartExamplesQuest()


    ; CreateTestSuite(SkyUnitTestExamples.GetExampleTest1())
    ; CreateTest("Example Test")

    ; Debug.MessageBox("2 Here are the test suite names : " + SkyUnitPrivateAPI.TestSuites())

    ; CreateTestSuite(SkyUnitTestExamples.GetExampleTest1())

endFunction
