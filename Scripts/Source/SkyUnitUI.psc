scriptName SkyUnitUI extends Quest  
{SkyUnit UI}

bool _consoleHasBeenOpened = false
string _consoleTextToShow

SkyUnitUI function GetInstance() global
    return Game.GetFormFromFile(0x800, "SkyUnitUI.esp") as SkyUnitUI
endFunction

function Debug(string text)
    Debug.Trace("[SkyUnit UI] " + text)
endFunction

event OnInit()
    RegisterForMenu("Console")
    Utility.WaitMenuMode(0.5)
    int SkyUnit2TestCount = SkyUnit2.GetTestSuiteScriptCount(SkyUnit2.DefaultTestSuite())
    if SkyUnit2TestCount
        ; Automatically equip the power to run tests
        Spell runTestsSpell = Game.GetFormFromFile(0x802, "SkyUnitUI.esp") as Spell
        Actor player = Game.GetPlayer()
        player.EquipSpell(runTestsSpell, 0)
        Debug.Notification(SkyUnit2TestCount + " tests found")
        Debug.Notification("SkyUnit UI Ready")
    endIf
endEvent

event OnMenuOpen(string menuName)
    if _consoleHasBeenOpened
        return
    else
        _consoleHasBeenOpened = true
        Utility.WaitMenuMode(0.1)
        MiscUtil.PrintConsole(_consoleTextToShow)
        _consoleTextToShow = ""
    endIf
    UnregisterForMenu("Console")
endEvent

function PrintToConsole(string text)
    if _consoleHasBeenOpened
        MiscUtil.PrintConsole(text)
    else
        if _consoleTextToShow
            _consoleTextToShow += "\n" + text
        else
            _consoleTextToShow = text
        endIf
    endIf
endFunction

function ShowTestChooser()
    int totalTestCount = SkyUnit2.GetTestSuiteScriptCount()
    if ! totalTestCount
        Debug.MessageBox("No SkyUnit tests found")
        return
    endIf

    uilistmenu listMenu = uiextensions.GetMenu("UIListMenu") as uilistmenu
    listMenu.AddEntryItem("Run all tests")

    string[] testScriptNames = SkyUnit2.GetTestSuiteScriptNames()

    int index = 0
    while index < testScriptNames.Length
        listMenu.AddEntryItem(testScriptNames[index])
        index += 1
    endWhile

    listMenu.OpenMenu()

    int selectedIndex = listMenu.GetResultInt()

    if selectedIndex > -1
        if selectedIndex == 0
            RunAllTestScripts(testScriptNames)
        else
            string testName = testScriptNames[selectedIndex - 1]
            RunTestScriptByName(testName)
        endIf
    endIf
endFunction

function RunAllTestScripts(string[] testScriptNames)
    Debug("Running All Tests")
    string output = ""
    int totalPassed
    int totalPending
    int totalFailed
    int totalSkipped
    int testScriptIndex = 0
    while testScriptIndex < testScriptNames.Length
        string name = testScriptNames[testScriptIndex]
        Debug("Running " + name)
        int result = SkyUnit2.RunTestScriptByName(SkyUnit2.DefaultTestSuite(), name)
        JValue.writeToFile(result, "TestResult_" + name + ".json")
        string resultText = TestScriptSummary(name, result, showMessageBox = false)
        if resultText == SkyUnit2.TestStatus_PASS()
            totalPassed += 1
        elseIf resultText == SkyUnit2.TestStatus_FAIL()
            totalFailed += 1
            output += "[FAILED] " + name + "\n"
        elseIf resultText == SkyUnit2.TestStatus_PENDING()
            totalPending +=1
            output += "[PENDING] " + name + "\n"
        elseIf resultText == SkyUnit2.TestStatus_SKIPPED()
            totalSkipped +=1
        endIf
        testScriptIndex += 1
    endWhile
    Debug.Notification("Wrote files: TestResult_*.json")
    string summary = ""
    if totalPassed
        summary += totalPassed + " passed\n"
    endIf
    if totalFailed
        summary += totalFailed + " failed\n"
    endIf
    if totalPending
        summary += totalPending + " pending\n"
    endIf
    if totalSkipped
        summary += totalSkipped + " skipped\n"
    endIf
    Debug.MessageBox(summary + "\n" + output)
endFunction

function RunTestScriptByName(string name)
    Debug("Running " + name)
    int result = SkyUnit2.RunTestScriptByName(SkyUnit2.DefaultTestSuite(), name)
    JValue.writeToFile(result, "TestResult_" + name + ".json")
    Debug.Notification("Wrote file: TestResult_" + name + ".json")
    TestScriptSummary(name, result)
endFunction

string SummaryPart_OneLineTotals
string SummaryPart_OnlyFailed

string function TestScriptSummary(string name, int scriptResult, bool showMessageBox = true)
    string[] testNames = SkyUnit2.ScriptTestResult_GetTestNames(scriptResult)
    Debug("Tests: " + testNames)
    string output = ""
    int totalPassed
    int totalPending
    int totalFailed
    int totalSkipped
    PrintToConsole("[" + SkyUnit2.ScriptTestResult_GetScriptNames(scriptResult) + "]")
    int testIndex = 0
    while testIndex < testNames.Length
        string testName = testNames[testIndex]
        int testResult = SkyUnit2.ScriptTestResult_GetTestResult(scriptResult, testName)
        string testStatus = SkyUnit2.ScriptTestResult_GetScriptStatus(scriptResult)
        if testStatus == SkyUnit2.TestStatus_PASS()
            if (testName != SkyUnit2.SpecialTestNameFor_BeforeAll() && testName != SkyUnit2.SpecialTestNameFor_AfterAll())
                totalPassed += 1
                PrintToConsole("[PASSED] " + testName)
            endIf
        elseIf testStatus == SkyUnit2.TestStatus_FAIL()
            totalFailed += 1
            output += "[FAILED] " + testName + "\n"
            PrintToConsole("[FAILED] " + testName)
        elseIf testStatus == SkyUnit2.TestStatus_PENDING()
            totalPending += 1
            output += "[PENDING] " + testName + "\n"
            PrintToConsole("[PENDING] " + testName)
        elseIf testStatus == SkyUnit2.TestStatus_SKIPPED()
            PrintToConsole("[SKIPPED] " + testName)
            totalSkipped += 1
        else
            PrintToConsole("[" + testStatus + "] " + testName)
        endIf
        int expectationCount = SkyUnit2.TestResult_GetExpectationCount(testResult)
        int expectationIndex = 0
        while expectationIndex < expectationCount
            bool expectationPassed = SkyUnit2.TestResult_GetNthExpectationPassed(testResult, expectationIndex)
            if ! expectationPassed
                string failureMessage = SkyUnit2.TestResult_GetNthAssertionFailureMessage(testResult, expectationIndex)
                string expectationType = SkyUnit2.TestResult_GetNthExpectationType(testResult, expectationIndex)
                PrintToConsole(" - #" + (expectationIndex + 1) + " " + expectationType + " " + failureMessage)
            endIf
            expectationIndex += 1
        endWhile
        testIndex += 1
    endWhile
    string resultText = SkyUnit2.TestStatus_PENDING()
    string summary = ""
    if totalPassed
        summary += totalPassed + " passed\n"
        resultText = SkyUnit2.TestStatus_PASS()
    endIf
    if totalFailed
        summary += totalFailed + " failed\n"
        resultText = SkyUnit2.TestStatus_FAIL()
    endIf
    if totalPending
        summary += totalPending + " pending\n"
        if ! totalPassed && ! totalFailed
            resultText = SkyUnit2.TestStatus_PENDING()
        endIf
    endIf
    if totalSkipped
        summary += totalSkipped + " skipped\n"
        if ! totalPassed && ! totalFailed && ! totalPending
            resultText = SkyUnit2.TestStatus_SKIPPED()
        endIf
    endIf
    PrintToConsole("\n" + summary)
    if showMessageBox
        Debug.MessageBox("[" + name + "]\n\n" + summary + "\n" + output)
    endIf
    return resultText
endFunction
