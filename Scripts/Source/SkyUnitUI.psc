scriptName SkyUnitUI extends Quest  
{SkyUnit UI}

bool _consoleHasBeenOpened = false
string _consoleTextToShow

SkyUnitUI function GetInstance() global
    return Game.GetFormFromFile(0x800, "SkyUnitUI.esp") as SkyUnitUI
endFunction

event OnInit()
    RegisterForMenu("Console")
    ; Automatically equip the power to run tests
    SkyUnit.GetInstance().WaitUntilReady()
    Utility.WaitMenuMode(0.5)
    int skyUnitTestCount = SkyUnit.GetTestScriptCount()
    if skyUnitTestCount
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
    int totalTestCount = SkyUnit.GetTestScriptCount()
    if ! totalTestCount
        Debug.MessageBox("No SkyUnit tests found")
        return
    endIf

    uilistmenu listMenu = uiextensions.GetMenu("UIListMenu") as uilistmenu
    listMenu.AddEntryItem("Run all tests")
    ; listMenu.AddEntryItem("Run all matching filter")

    int index = 0
    while index < totalTestCount
        listMenu.AddEntryItem(GetTestName(SkyUnit.GetNthTestScript(index)))
        index += 1
    endWhile

    listMenu.OpenMenu()

    ; TODO ~ Extract Method
    int selectedIndex = listMenu.GetResultInt()
    if selectedIndex > -1
        if selectedIndex == 0
            int passedCount = 0
            int failedCount = 0
            string failed = ""
            string passed = ""

            index = 0
            while index < totalTestCount

                SkyUnitTest test = SkyUnit.GetNthTestScript(index)
                SkyUnit.GetInstance().ResetTestData()

                bool testPassed = test.Run()
                if testPassed
                    passedCount += 1
                    passed += "[PASS] " + test.GetDisplayName() + "\n"
                else
                    failedCount += 1
                    failed += "[FAIL] " + test.GetDisplayName() + "\n"
                endIf

                PrintToConsole("\n[" + GetTestName(test) + "]")
                PrintToConsole(test.GetSummary(showFailureMessages = true, showPassingTestNames = true))

                index += 1
                Utility.WaitMenuMode(0.1)
            endWhile

            string summary = ""
            if passedCount > 0 && failedCount > 0
                Debug.MessageBox(passedCount + " passed, " + failedCount + " failed\n\n" + failed + "\n" + passed)
            elseIf passedCount > 0
                Debug.MessageBox(passedCount + " passed\n\n" + passed)
            elseIf failedCount > 0
                Debug.MessageBox(passedCount + " failed\n\n" + failed)
            else
                Debug.MessageBox("No tests")
            endIf
        else
            SkyUnitTest test = SkyUnit.GetNthTestScript(selectedIndex - 1)
            SkyUnit.GetInstance().ResetTestData()
            test.Run()

            string filename = "Data/SkyUnit/TestResults_" + GetTestName(test) + ".json"
            test.SaveResult(filename)
            MiscUtil.PrintConsole("Saved " + filename)

            Debug.MessageBox("[" + GetTestName(test) + "]\n\n" + test.GetSummary(showFailureMessages = false, showPassingTestNames = false))
            PrintToConsole("\n[" + GetTestName(test) + "]")
            PrintToConsole(test.GetSummary(showFailureMessages = true, showPassingTestNames = true))
        endIf
    endIf
endFunction

string function GetTestName(SkyUnitTest test)
    string scriptNameText = test
    int spaceIndex = StringUtil.Find(scriptNameText, " ")
    return StringUtil.Substring(scriptNameText, 1, spaceIndex - 1)
endFunction
