scriptName SkyUnit_BasicTests extends SkyUnitTest
{Basic tests for loading test suite scripts, test functions,
getting test names, running test suite scripts, and getting the results.}

function Tests()
    Test("Get test suite names")
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


