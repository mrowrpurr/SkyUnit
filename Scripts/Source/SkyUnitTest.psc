scriptName SkyUnitTest extends Quest hidden
{Base script for implementing SkyUnit tests}

int _testData
int _currentTest
int _currentExpectation
bool _modInstalled

event OnInit()
    SkyUnit sdk = SkyUnit.GetInstance()
    sdk.RegisterSkyUnitTest(self)
    if ! _modInstalled
        _modInstalled = true
    else
        Debug.Trace("[SkyUnit] onInit for test script (" + self + ")")
        sdk.BeginTestScript(self)
        if sdk.ShouldRun()
            BeforeAll()
            Tests()
        endIf
    endIf
endEvent

bool function Run()
    SkyUnit sdk = SkyUnit.GetInstance()
    sdk.BeginTestScript(self)
    BeforeAll()
    Tests()
    return sdk.AllTestsPassed(self)
endFunction

function SaveResult(string filePath)
    SkyUnit sdk = SkyUnit.GetInstance()
    JValue.writeToFile(sdk.GetMapForSkyUnitTestResults(self), filePath)
endFunction

string function GetSummary()
    SkyUnit sdk = SkyUnit.GetInstance()
    return sdk.GetTestSummary(self)
endFunction

string function GetDisplayName()
    SkyUnit sdk = SkyUnit.GetInstance()
    sdk.GetTestDisplayName(self)
endFunction

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
