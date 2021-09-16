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

SkyUnit_ExampleTest1 function GetInstance() global
    return Game.GetFormFromFile(0x0808, "SkyUnitTests.esp") as SkyUnit_ExampleTest1
endFunction

function ResetTests() global
    SkyUnit_ExampleTest1 test = GetInstance()
    test.Test_PassingTest1_Enabled = true
    test.Test_FailingTest1_Enabled = true
    test.Test_PendingTest1_Enabled = true
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tests Below
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function Tests()
    if Test_PassingTest1_Enabled
        Test("Passing Test 1").Fn(PassingTest1_Test())
    endIf
    if Test_FailingTest1_Enabled
        Test("Failing Test 1").Fn(FailingTest1_Test())
    endIf
    if Test_PendingTest1_Enabled
        Test("Pending Test 1") ; Pending, so no associated function
    endIf
endFunction

function PassingTest1_Test()
    ; Nothing, should pass (no failures)
endFunction

function FailingTest1_Test()
    Fail("Manually failed FailingTest1")
endFunction
