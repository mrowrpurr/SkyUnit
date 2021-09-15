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
    Utility.WaitMenuMode(1.5)
    int SkyUnitTestCount = SkyUnit.GetTestSuiteScriptCount(SkyUnit.DefaultTestSuite())
    if SkyUnitTestCount
        ; Automatically equip the power to run tests
        Spell runTestsSpell = Game.GetFormFromFile(0x802, "SkyUnitUI.esp") as Spell
        Actor player = Game.GetPlayer()
        player.EquipSpell(runTestsSpell, 0)
        Debug.Notification(SkyUnitTestCount + " tests found")
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

string property SKYUNIT_UI_SUITE_CACHE_FILE = "Data\\SkyUnit\\SkyUnitUI\\DefaultTestSuiteCache.json" autoReadonly
bool _hasSavedCache = false ; reset on player load game?

function ShowTestChooser()
    SkyUnit.UseDefaultTestSuite()

    int totalTestCount = SkyUnit.GetTestSuiteScriptCount()
    if ! totalTestCount
        if ! totalTestCount
            Debug.MessageBox("No SkyUnit tests found")
            return
        endIf
    endIf

    uilistmenu listMenu = uiextensions.GetMenu("UIListMenu") as uilistmenu
    listMenu.AddEntryItem("Run all tests")
    listMenu.AddEntryItem("Filter tests by name")

    string[] testscriptNames = SkyUnit.GetTestSuitescriptNames()

    int index = 0
    while index < testscriptNames.Length
        listMenu.AddEntryItem(testscriptNames[index])
        index += 1
    endWhile

    listMenu.OpenMenu()

    int selectedIndex = listMenu.GetResultInt()

    if selectedIndex > -1
        if selectedIndex == 0
            RunAllTestScripts(testscriptNames)
        elseIf selectedIndex == 1
            uitextentrymenu textEntry = UIextensions.GetMenu("UITextEntryMenu") as uitextentrymenu
            textEntry.OpenMenu()
            string filter = textEntry.GetResultString()
            if filter
                RunAllTestScripts(testscriptNames, filter)
            endIf
        else
            string testName = testscriptNames[selectedIndex - 2]
            RunTestScriptByName(testName)
        endIf
    endIf
endFunction

function RunAllTestScripts(string[] testscriptNames, string filter = "")
    Debug("Running All Tests")
    string output = ""
    int totalPassed
    int totalPending
    int totalFailed
    int totalSkipped
    int testScriptIndex = 0
    while testScriptIndex < testscriptNames.Length
        string name = testscriptNames[testScriptIndex]
        Debug("Running " + name)
        int result = SkyUnit.RunTestScriptByName(SkyUnit.DefaultTestSuite(), name, filter)
        JValue.retain(result)
        JValue.writeToFile(result, "TestResult_" + name + ".json")
        string resultText = TestScriptSummary(name, result, showMessageBox = false)
        if resultText == SkyUnit.TestStatus_PASS()
            totalPassed += 1
        elseIf resultText == SkyUnit.TestStatus_FAIL()
            totalFailed += 1
            output += "[FAILED] " + name + "\n"
        elseIf resultText == SkyUnit.TestStatus_PENDING()
            totalPending +=1
            output += "[PENDING] " + name + "\n"
        elseIf resultText == SkyUnit.TestStatus_SKIPPED()
            totalSkipped +=1
        endIf
        testScriptIndex += 1
        JValue.release(result)
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
    int result = SkyUnit.RunTestScriptByName(SkyUnit.DefaultTestSuite(), name)
    JValue.retain(result)
    JValue.writeToFile(result, "TestResult_" + name + ".json")
    Debug.Notification("Wrote file: TestResult_" + name + ".json")
    TestScriptSummary(name, result)
    JValue.release(result)
endFunction

string SummaryPart_OneLineTotals
string SummaryPart_OnlyFailed

string function TestScriptSummary(string name, int scriptResult, bool showMessageBox = true)
    string[] testNames = SkyUnit.ScriptTestResult_GetTestNames(scriptResult)
    Debug("Tests: " + testNames)
    string output = ""
    int totalPassed
    int totalPending
    int totalFailed
    int totalSkipped
    PrintToConsole("[" + SkyUnit.ScriptTestResult_GetScriptNames(scriptResult) + "]")
    int testIndex = 0
    while testIndex < testNames.Length
        string testName = testNames[testIndex]
        int testResult = SkyUnit.ScriptTestResult_GetTestResult(scriptResult, testName)
        string testStatus = SkyUnit.TestResult_GetTestStatus(testResult)
        if testStatus == SkyUnit.TestStatus_PASS()
            if (testName != SkyUnit.SpecialTestNameFor_BeforeAll() && testName != SkyUnit.SpecialTestNameFor_AfterAll())
                totalPassed += 1
                PrintToConsole("[PASSED] " + testName)
            endIf
        elseIf testStatus == SkyUnit.TestStatus_FAIL()
            totalFailed += 1
            output += "[FAILED] " + testName + "\n"
            PrintToConsole("[FAILED] " + testName)
        elseIf testStatus == SkyUnit.TestStatus_PENDING()
            if (testName != SkyUnit.SpecialTestNameFor_BeforeAll() && testName != SkyUnit.SpecialTestNameFor_AfterAll())
                totalPending += 1
                output += "[PENDING] " + testName + "\n"
                PrintToConsole("[PENDING] " + testName)
            endIf
        elseIf testStatus == SkyUnit.TestStatus_SKIPPED()
            PrintToConsole("[SKIPPED] " + testName)
            totalSkipped += 1
        else
            PrintToConsole("[ Test Status: " + testStatus + "] " + testName)
        endIf
        int expectationCount = SkyUnit.TestResult_GetExpectationCount(testResult)
        int expectationIndex = 0
        while expectationIndex < expectationCount
            bool expectationPassed = SkyUnit.TestResult_GetNthExpectationPassed(testResult, expectationIndex)
            if ! expectationPassed
                string failureMessage = SkyUnit.TestResult_GetNthAssertionFailureMessage(testResult, expectationIndex)
                string expectationType = SkyUnit.TestResult_GetNthExpectationType(testResult, expectationIndex)
                PrintToConsole(" - #" + (expectationIndex + 1) + " " + expectationType + " " + failureMessage)
            endIf
            expectationIndex += 1
        endWhile
        testIndex += 1
    endWhile
    string resultText = SkyUnit.TestStatus_PENDING()
    string summary = ""
    if totalPassed
        summary += totalPassed + " passed\n"
        resultText = SkyUnit.TestStatus_PASS()
    endIf
    if totalFailed
        summary += totalFailed + " failed\n"
        resultText = SkyUnit.TestStatus_FAIL()
    endIf
    if totalPending
        summary += totalPending + " pending\n"
        if ! totalPassed && ! totalFailed
            resultText = SkyUnit.TestStatus_PENDING()
        endIf
    endIf
    if totalSkipped
        summary += totalSkipped + " skipped\n"
        if ! totalPassed && ! totalFailed && ! totalPending
            resultText = SkyUnit.TestStatus_SKIPPED()
        endIf
    endIf
    PrintToConsole("\n" + summary)
    if showMessageBox
        Debug.MessageBox("[" + name + "]\n\n" + summary + "\n" + output)
    endIf
    return resultText
endFunction
