scriptName SkyUnit_ExampleTest1 extends SkyUnitTest
{Example SkyUnit test used by the tests

Turn the test functions off using their respective script properties.

e.g.

```
SkyUnitTestExamples.ExampleTest1().Test_PassingTest1_Enabled = true
```

Quest: 0x808
Plugin: SkyUnitTests.esp}

bool property Test_PassingTest1_Enabled auto
bool property Test_FailingTest1_Enabled auto
bool property Test_PendingTest1_Enabled auto

bool property ResetTestLogs auto
string[] property TestLogs auto

SkyUnit_ExampleTest1 function ResetTestSuite()
    ResetTestLogs = true
    TestLogs = Utility.CreateStringArray(0)
    DisableTests()
    return self
endFunction

SkyUnit_ExampleTest1 function EnableTests()
    Test_PassingTest1_Enabled = true
    Test_FailingTest1_Enabled = true
    Test_PendingTest1_Enabled = true
    return self
endFunction

SkyUnit_ExampleTest1 function DisableTests()
    Test_PassingTest1_Enabled = false
    Test_FailingTest1_Enabled = false
    Test_PendingTest1_Enabled = false
    return self
endFunction

function AddToLog(string text)
    if TestLogs && ! ResetTestLogs
        TestLogs = Utility.ResizeStringArray(TestLogs, TestLogs.Length + 1)
        TestLogs[TestLogs.Length - 1] = text
    else
        TestLogs = new string[1]
        TestLogs[0] = text
        ResetTestLogs = false
    endIf
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Before/After All/Each
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function BeforeAll()
    AddToLog("Before All")
endFunction

function AfterAll()
    AddToLog("After All")
endFunction

function BeforeEach()
    AddToLog("Before Each")
endFunction

function AfterEach()
    AddToLog("After Each")
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tests Below
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function Tests()
    AddToLog("Begin Tests")
    if Test_PassingTest1_Enabled
        AddToLog("Test(Passing Test 1)")
        Test("Passing Test 1").Fn(PassingTest1_Test())
    endIf
    if Test_FailingTest1_Enabled
        AddToLog("Test(Failing Test 1)")
        Test("Failing Test 1").Fn(FailingTest1_Test())
    endIf
    if Test_PendingTest1_Enabled
        AddToLog("Test(Pending Test 1)")
        Test("Pending Test 1") ; Pending, so no associated function
    endIf
    AddToLog("End Tests")
endFunction

function PassingTest1_Test()
    AddToLog("Begin Passing Test 1")
    ExpectString("Hello from ExampleTest1").To(EqualString("Hello from ExampleTest1"))
    AddToLog("End Passing Test 1")
endFunction

function FailingTest1_Test()
    AddToLog("Failing Passing Test 1")
    ExpectString("Hello from ExampleTest1").To(EqualString("This is a different string"))
    AddToLog("Failing Passing Test 1")
endFunction
