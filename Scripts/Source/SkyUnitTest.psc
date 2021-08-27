scriptName SkyUnitTest extends Quest hidden
{Base script for implementing SkyUnit tests}

int _testData
int _currentTest
int _currentExpectation
bool _modInstalled

event OnInit()
    if ! _modInstalled
        _modInstalled = true
    else
        Debug.Trace("[SkyUnit] onInit for test script (" + self + ")")
        SkyUnit sdk = SkyUnit.GetInstance()
        sdk.BeginTestScript(self)
        if sdk.ShouldRun()
            BeforeAll()
            Tests()
            sdk.WriteTestLogs()
        endIf
    endIf
endEvent

function Log(string text)
    SkyUnit.GetInstance().Log(text)
endFunction

SkyUnitTest function Test(string testName)
    SkyUnit sdk = SkyUnit.GetInstance()
    sdk.GetTestLock()
    sdk.BeginTest(self, testName)
    BeforeEach()
    return self
endFunction

function Fn(bool testFunction)
    SkyUnit sdk = SkyUnit.GetInstance()
    sdk.ReleaseTestLock()
endFunction

SkyUnitTest function Not()
    SkyUnit.GetInstance().SetNotExpectation()
    return self
endFunction

SkyUnitTest function To(bool expectationFunction, string failureMessage = "")
    SkyUnit.GetInstance().SetExpectationFailureMessage(failureMessage)
    return self
endFunction

function Tests()
endFunction

function BeforeAll()
endFunction

function BeforeEach()
endFunction
