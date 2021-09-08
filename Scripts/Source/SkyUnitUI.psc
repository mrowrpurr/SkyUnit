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
            RunAllTestScripts()
        else
            string testName = testScriptNames[selectedIndex - 1]
            RunTestScriptByName(testName)
        endIf
    endIf
endFunction

function RunAllTestScripts()
    ; TODO
endFunction

function RunTestScriptByName(string name)
    Debug("Running " + name)
    int result = SkyUnit2.RunTestScriptByName(SkyUnit2.DefaultTestSuite(), name)
    JValue.writeToFile(result, "TestResult_" + name + ".json")
    Debug.Notification("Wrote file: TestResult_" + name + ".json")
    GenerateScriptSummaryParts(result, printToConsole = true)
endFunction

string SummaryPart_OneLineTotals
string SummaryPart_OnlyFailed

function GenerateScriptSummaryParts(int scriptResult, bool printToConsole = true)
    string[] testNames = SkyUnit2.ScriptTestResult_GetTestNames(scriptResult)
    Debug("Tests: " + testNames)
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
            totalPassed += 1
            PrintToConsole("[PASSED] " + testName)
        elseIf testStatus == SkyUnit2.TestStatus_FAIL()
            totalFailed += 1
            PrintToConsole("[FAILED] " + testName)
        elseIf testStatus == SkyUnit2.TestStatus_PENDING()
            totalPending += 1
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
endFunction

