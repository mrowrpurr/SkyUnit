scriptName SkyUnitUI extends Quest  
{SkyUnit UI}

bool _consoleHasBeenOpened = false
string _consoleTextToShow

SkyUnitUI function GetInstance() global
    return Game.GetFormFromFile(0x800, "SkyUnitUI.esp") as SkyUnitUI
endFunction

event OnInit()
    RegisterForMenu("Console")
    Utility.WaitMenuMode(0.5)
    int skyUnitTestCount = SkyUnit2.GetTestSuiteScriptCount(SkyUnit2.DefaultTestSuite())
    if skyUnitTestCount
        ; Automatically equip the power to run tests
        Spell runTestsSpell = Game.GetFormFromFile(0x802, "SkyUnitUI.esp") as Spell
        Actor player = Game.GetPlayer()
        player.EquipSpell(runTestsSpell, 0)
        Debug.Notification(skyUnitTestCount + " tests found")
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

endFunction

function RunTestScriptByName(string name)
    int result = SkyUnit2.RunTestScriptByName(SkyUnit2.DefaultTestSuite(), name)
    GenerateScriptSummaryParts(result, printToConsole = true)
endFunction

string SummaryPart_OneLineTotals
string SummaryPart_OnlyFailed

function GenerateScriptSummaryParts(int result, bool printToConsole = true)
    string[] testNames = SkyUnit2.ScriptTestResult_GetTestNames(result)
    int totalPassed
    int totalPending
    int totalFailed
    if printToConsole
        SkyUnitConsole.Print("[" + SkyUnit2.ScriptTestResult_GetScriptNames(result) + "]")
    endIf
endFunction

