scriptName SkyUnitUI extends ReferenceAlias
{Main script for the UI of SkyUnit}

; Messages and hacky alias for dynamically setting Message text
Form property SkyUnitMessageTextFormBase auto
Message property SkyUnitTestSuiteMessage auto
Message property SkyUnitTestMessage auto
Message property SkyUnitExpectationMessage auto
Message property SkyUnitAllTestSuitesMessage auto

; Returns the instance of the SkyUnitUI script
SkyUnitUI function GetInstance() global
    Quest skyUnitQuest = Game.GetFormFromFile(0x806, "SkyUnit.esp") as Quest
    return skyUnitQuest.GetAliasByName("PlayerRef") as SkyUnitUI
endFunction

function Info(string text) global
    Debug.Trace("[SkyUnitUI] " + text)
endFunction

event OnInit()
    ListenForMainMenu()
endEvent

event OnPlayerLoadGame()
    ListenForMainMenu()
endEvent

function ListenForMainMenu()
    RegisterForModEvent("SkyUnitUI_ShowMainMenu", "OnSkyUnitUI_ShowMainMenu")
endFunction

event OnSkyUnitUI_ShowMainMenu(string eventName, string strArg, float fltArg, Form sender)
    UI_Show_MainMenu()
endEvent

; SkyUnitUI_ShowMainMenu
;         SkyUnitPrivateAPI.GetInstance().SendModEvent("SkyUnitUI_ShowMainMenu")

function ListenForTestSuiteShortcuts()
    ; RegisterForKey(0) ; [A] for Run All   - TODO
    ; RegisterForKey(0) ; [R] for Run Again - TODO
    RegisterForKey(33) ; [F] for Filter
endFunction

function UnlistenForTestSuiteShortcuts()
    UnregisterForKey(33) ; F
endFunction

event OnKeyDown(int keyCode)
    if keyCode == 33 ; Filter
        Input.TapKey(1) ; Escape
        UI_Show_ViewAllTestSuites(GetTextEntryResult())
    endIf
endEvent

; Main Menu for SkyUnit
;
; Shows all test suite names so you can quickly run a specific suite and see its results!
function UI_Show_MainMenu()
    Info("Main Menu")

    string[] testSuiteNames = SkyUnitPrivateAPI.TestSuites()

    string option_RunAllTestSuites_text = "Run All Test Suites"
    int option_RunAllTestSuites_index   = 0
    string option_ViewTestSuites_text   = "View Test Suites"
    int option_ViewTestSuites_index     = 1
    string option_FilterTestSuites_text = "Filter Test Suites"
    int option_FilterTestSuites_index   = 2

    UIListMenu listMenu = uiextensions.GetMenu("UIListMenu") as UIListMenu

    int textOptionCount = 5 ; Including an empty space and "Choose Test Suite to Run"

    listMenu.AddEntryItem(option_RunAllTestSuites_text)
    listMenu.AddEntryItem(option_ViewTestSuites_text)
    listMenu.AddEntryItem(option_FilterTestSuites_text)
    listMenu.AddEntryItem(" ")
    listMenu.AddEntryItem("--- [Choose Test Suite to Run] ---")

    int suiteIndex = 0
    while suiteIndex < testSuiteNames.Length
        string testSuiteName = testSuiteNames[suiteIndex]
        int testSuiteResult = SkyUnitPrivateAPI.SkyUnitData_GetMostRecentResultForTestSuiteByName(testSuiteName)
        string status = JMap.getStr(testSuiteResult, "status")
        if status == "FAILING"
            listMenu.AddEntryItem("[FAIL] " + testSuiteName)
        else
            listMenu.AddEntryItem(testSuiteName)
        endIf
        suiteIndex += 1
    endWhile

    ListenForTestSuiteShortcuts()
    listMenu.OpenMenu()
    UnlistenForTestSuiteShortcuts()

    int selection = listMenu.GetResultInt()
    if selection > -1
        if selection == option_RunAllTestSuites_index
            Debug.Notification("Running all tests...")
            float startTime = Utility.GetCurrentRealTime()
            int testRun = SkyUnitPrivateAPI.RunAllTestSuites(forceRerun = true)
            float endTime = Utility.GetCurrentRealTime()
            UI_Show_AllTestSuiteResults(testRun, endTime - startTime)
        elseIf selection == option_ViewTestSuites_index
            UI_Show_ViewAllTestSuites()
        elseIf selection == option_FilterTestSuites_index
            UI_Show_ViewAllTestSuites(GetTextEntryResult())
        else
            string testSuiteName = testSuiteNames[selection - textOptionCount]
            UI_Show_TestSuiteResult(SkyUnitPrivateAPI.RunTestSuite(testSuiteName), testSuiteName)
        endIf
    endIf
endFunction

; Display Results of Running All Test Results
function UI_Show_AllTestSuiteResults(int testRun, float duration)
    Info("Run All Test Suites (test run #" + testRun + ")")

    int testSuites = JMap.getObj(testRun, "testSuites")
    string[] testSuiteNames = JMap.allKeysPArray(testSuites)

    int i = 0
    int testNamesByStatus = JMap.object()
    while i < testSuiteNames.Length
        string testSuiteName = testSuiteNames[i]    
        int testSuite = JMap.getObj(testSuites, testSuiteName)
        string status = JMap.getStr(testSuite, "status")
        NamesByStatus_AddItem(testNamesByStatus, testSuiteName, status)
        i += 1
    endWhile

    string text = ""
    text += UI_GetTestSummaryLineFromMap(testNamesByStatus) + "\n"
    text += UI_GetLinesShowingNamesForEachStatus(testNamesByStatus)
    string[] durationParts = StringUtil.Split(duration, ".")
    text += "\n\nDuration: " + durationParts[0] + "." + StringUtil.Substring(durationParts[1], 0, 2) + " seconds"
    UI_Show_AllTestSuiteResults_Message(testRun, text)
endFunction

; Displays All Suites Test Results with various options
function UI_Show_AllTestSuiteResults_Message(int testRun, string text)
    Info("All Test Results Message (test run #" + testRun + ")")
    SkyUnitPrivateAPI api = SkyUnitPrivateAPI.GetInstance()
    SkyUnitMessageTextFormBase.SetName(text)

    int mainMenu = 0
    int viewAllTestSuites = 1
    int filterAllTestSuites = 2
    int runAgain = 3
    int saveResultsToFile = 4
    int result = SkyUnitAllTestSuitesMessage.Show()
    if result == mainMenu
        UI_Show_MainMenu()
    elseIf result == viewAllTestSuites
        UI_Show_ViewAllTestSuites()
    elseIf result == filterAllTestSuites
        UI_Show_ViewAllTestSuites(GetTextEntryResult())
    elseIf result == runAgain
        float startTime = Utility.GetCurrentRealTime()
        testRun = SkyUnitPrivateAPI.RunAllTestSuites(forceRerun = true)
        float endTime = Utility.GetCurrentRealTime()
        UI_Show_AllTestSuiteResults(testRun, endTime - startTime)
    elseIf result == saveResultsToFile
        string filename = GetTextEntryResult("AllTestResults.json")
        if filename
            SaveToFile(testRun, filename)
            Debug.MessageBox("Wrote to " + filename)
            UI_Show_AllTestSuiteResults_Message(testRun, text)
        endIf
    endIf
endFunction

; Choose a Test Suite to view (will automatically run it as well)
function UI_Show_ViewAllTestSuites(string filter = "")
    Info("View Test Suite")

    UIListMenu listMenu = uiextensions.GetMenu("UIListMenu") as UIListMenu

    int textOptionCount = 1 ; Including an empty space and "Choose Test Suite"
    listMenu.AddEntryItem("--- [Choose Test Suite] ---")

    int matchingTestSuiteNames = JArray.object()
    string[] testSuiteNames = SkyUnitPrivateAPI.TestSuites()

    string firstMatchingTestSuiteName = ""
    int numMatching = 0
    bool anyMatching = (filter == "")
    int suiteIndex = 0
    while suiteIndex < testSuiteNames.Length
        string testSuiteName = testSuiteNames[suiteIndex]
        if ! filter || StringUtil.Find(testSuiteName, filter) > -1
            int testSuiteResult = SkyUnitPrivateAPI.SkyUnitData_GetMostRecentResultForTestSuiteByName(testSuiteName)
            string status = JMap.getStr(testSuiteResult, "status")
            if status == "FAILING"
                listMenu.AddEntryItem("[FAIL] " + testSuiteName)
            else
                listMenu.AddEntryItem(testSuiteName)
            endIf
            JArray.addStr(matchingTestSuiteNames, testSuiteName)
            anyMatching = true
            numMatching += 1
            if ! firstMatchingTestSuiteName
                firstMatchingTestSuiteName = testSuiteName
            endIf
        endIf
        suiteIndex += 1
    endWhile

    if ! anyMatching
        Debug.MessageBox("No Test Suites found matching filter: " + filter)
        UI_Show_MainMenu()
        return
    endIf

    if numMatching == 1
        UI_Show_TestSuiteResult(SkyUnitPrivateAPI.RunTestSuite(firstMatchingTestSuiteName), firstMatchingTestSuiteName)
        return
    endIf

    listMenu.OpenMenu()

    int selection = listMenu.GetResultInt()
    if selection > 0 ; 0 is the "Choose Test Suite" line
        string testSuiteName = JArray.getStr(matchingTestSuiteNames, selection - 1)
        UI_Show_TestSuiteResult(SkyUnitPrivateAPI.RunTestSuite(testSuiteName), testSuiteName)
    endIf
endFunction

function UI_Show_TestSuiteResult(int testRun, string testSuiteName)
    Info("View Test Suite: " + testSuiteName)

    int testSuites = JMap.getObj(testRun, "testSuites")
    int testSuite = JMap.getObj(testSuites, testSuiteName)
    string suiteStatus = JMap.getStr(testSuite, "status")

    int tests = JMap.getObj(testSuite, "tests")
    string[] testNames = JMap.allKeysPArray(tests)
    int i = 0
    int testNamesByStatus = JMap.object()
    while i < testNames.Length
        string testName = testNames[i]    
        int test = JMap.getObj(tests, testName)
        string testStatus = JMap.getStr(test, "status")
        ; Only show the BeforeAll and AfterAll special functions in the "Tests" list if the functions failed (so you can see if stuff is breaking!)
        if (testName == SkyUnitPrivateAPI.SpecialTestNames_AfterAll() || testName == SkyUnitPrivateAPI.SpecialTestNames_BeforeAll()) && testStatus != "PASSING"
            NamesByStatus_AddItem(testNamesByStatus, testName, testStatus)
        elseIf testName != SkyUnitPrivateAPI.SpecialTestNames_AfterAll() && testName != SkyUnitPrivateAPI.SpecialTestNames_BeforeAll()
            NamesByStatus_AddItem(testNamesByStatus, testName, testStatus)
        endIf
        i += 1
    endWhile

    string text = "[" + testSuiteName + "]\n" + suiteStatus + "\n"
    text += UI_GetTestSummaryLineFromMap(testNamesByStatus) + "\n"
    text += UI_GetLinesShowingNamesForEachStatus(testNamesByStatus, maxLines = 7)
    string[] durationParts = StringUtil.Split(JMap.getFlt(testSuite, "duration"), ".")
    text += "\n\nDuration: " + durationParts[0] + "." + StringUtil.Substring(durationParts[1], 0, 2) + " seconds"
    UI_Show_TestSuiteResult_Message(testSuiteName, testRun, text)
endFunction

function UI_Show_TestSuiteResult_Message(string testSuiteName, int testRun, string text)
    SkyUnitPrivateAPI api = SkyUnitPrivateAPI.GetInstance()
    SkyUnitMessageTextFormBase.SetName(text)

    int mainMenu = 0
    int viewTests = 1
    int filterTests = 2
    int runAgain = 3
    int saveResultsToFile = 4
    int result = SkyUnitTestSuiteMessage.Show()
    if result == mainMenu
        UI_Show_MainMenu()
    elseIf result == viewTests
        UI_Show_ViewAllTests(testSuiteName, testRun)
    elseIf result == filterTests

    elseIf result == runAgain

    elseIf result == saveResultsToFile
        string filename = GetTextEntryResult(testSuiteName + "Results.json")
        if filename
            SaveToFile(testRun, filename)
            Debug.MessageBox("Wrote to " + filename)
            UI_Show_AllTestSuiteResults_Message(testRun, text)
        endIf
    endIf
endFunction

int function UI_Show_ViewAllTests(string testSuiteName, int testRun) ; TODO add Filter
    Info("View All Tests in Test Suite: " + testSuiteName)

    int testSuites = JMap.getObj(testRun, "testSuites")
    int testSuite = JMap.getObj(testSuites, testSuiteName)
    int tests = JMap.getObj(testSuite, "tests")

    UIListMenu listMenu = uiextensions.GetMenu("UIListMenu") as UIListMenu

    int textOptionCount = 1 ; Including an empty space and "Choose Test"
    listMenu.AddEntryItem("--- [Choose Test] ---")

    ; TODO - put the FAILING ones *FIRST* and then Passing and then Pending. But Failing should be FIRST in the list :)
    string[] testNames = JMap.allKeysPArray(tests)
    int testIndex = 0
    while testIndex < testNames.Length
        string testName = testNames[testIndex]
        int test = JMap.getObj(tests, testName)
        string status = JMap.getStr(test, "status")
        if status == "PASSING" ; Highlight the ones which aren't passing, so it's really easy to get to the failures!
            listMenu.AddEntryItem(testName)
        elseIf status == "PENDING" ; Put parens around pending
            listMenu.AddEntryItem("* " + testName + " *")
        elseIf status == "FAILING" ; Highlight Failing
            listMenu.AddEntryItem("[FAIL] - " + testName)
        else
            listMenu.AddEntryItem("[" + status + "] " + testName)
        endIf
        testIndex += 1
    endWhile

    listMenu.OpenMenu()

    int selection = listMenu.GetResultInt()
    if selection > 0 ; 0 is the "Choose Test Suite" line
        string testName = testNames[selection - 1]
        UI_Show_TestResult(SkyUnitPrivateAPI.RunTestSuite(testSuiteName, testRun), testSuiteName, testName)
    endIf
endFunction

function UI_Show_TestResult(int testRun, string testSuiteName, string testName)
    Info("View Test: " + testSuiteName + " > " + testName)

    int testSuites = JMap.getObj(testRun, "testSuites")
    int testSuite = JMap.getObj(testSuites, testSuiteName)
    int tests = JMap.getObj(testSuite, "tests")
    int test = JMap.getObj(tests, testName)
    string testStatus = JMap.getStr(test, "status")

    int maxLines = 9
    int lineCount = 0
    string expectationFailureText = ""
    int expectations = JMap.getObj(test, "expectations")
    int expectationCount = JArray.count(expectations)
    int expectationsByStatus = JMap.object()
    int i = 0
    while i < expectationCount && lineCount < maxLines
        int expectation = JArray.getObj(expectations, i)
        string expectationStatus = JMap.getStr(expectation, "status")
        string expectationDescription = SkyUnitExpectation.GetDescription(expectation)
        if expectationStatus != "PASSING"
            lineCount += 1
            expectationFailureText += "[" + expectationStatus + "] #" + (i + 1) + "\n" ; + " " + expectationDescription + "\n"
            string failureMessage = JMap.getStr(expectation, "failureMessage")
            if failureMessage && lineCount < maxLines
                expectationFailureText += failureMessage + "\n"
                lineCount += 1
            endIf
        endIf
        JMap.setObj(expectationsByStatus, expectationStatus, expectation)
        NamesByStatus_AddItem(expectationsByStatus, expectationDescription, expectationStatus)
        i += 1
    endWhile
    if lineCount >= maxLines
        expectationFailureText += "..."
    endIf

    string text = "[" + testName + "]\n" + testStatus + "\n"
    text += UI_GetTestSummaryLineFromMap(expectationsByStatus) + "\n"
    text += expectationFailureText
    string[] durationParts = StringUtil.Split(JMap.getFlt(test, "duration"), ".")
    text += "\n\nDuration: " + durationParts[0] + "." + StringUtil.Substring(durationParts[1], 0, 2) + " seconds"
    UI_Show_TestResult_Message(testSuiteName, testName, testRun, test, text)
endFunction

function UI_Show_TestResult_Message(string testSuiteName, string testName, int testRun, int test, string text)
    SkyUnitPrivateAPI api = SkyUnitPrivateAPI.GetInstance()
    SkyUnitMessageTextFormBase.SetName(text)

    int mainMenu = 0
    int viewTestSuite = 1
    int viewExpectations = 2
    int filterExpectations = 3
    int runAgain = 4
    int saveResultsToFile = 5
    int result = SkyUnitTestMessage.Show()
    if result == mainMenu
        UI_Show_MainMenu()
    elseIf result == viewTestSuite
        UI_Show_TestSuiteResult(testRun, testSuiteName)
    elseIf result == viewExpectations
        UI_Show_TestExpectations(testRun, testSuiteName, testName)
    elseIf result == filterExpectations
        UI_Show_TestExpectations(testRun, testSuiteName, testName, filter = GetTextEntryResult())
    elseIf result == runAgain
        SkyUnitPrivateAPI.RunTestSuite(testSuiteName, testRun, forceRerun = true)        
        UI_Show_TestResult(testRun, testSuiteName, testName)
    elseIf result == saveResultsToFile
        string filename = GetTextEntryResult(testSuiteName + "_" + testName + "Results.json")
        if filename
            SaveToFile(testRun, filename)
            Debug.MessageBox("Wrote to " + filename)
            UI_Show_TestResult_Message(testSuiteName, testName, testRun, test, text)
        endIf
    endIf
endFunction

function UI_Show_TestExpectations(int testRun, string testSuiteName, string testName, string filter = "")
    Info("Show Test Expectations " + testSuiteName + " > " + testName)
    int testSuites = JMap.getObj(testRun, "testSuites")
    int testSuite = JMap.getObj(testSuites, testSuiteName)
    int tests = JMap.getObj(testSuite, "tests")
    int test = JMap.getObj(tests, testName)
    int expectations = JMap.getObj(test, "expectations")
    int expectationCount = JArray.count(expectations)

    UIListMenu listMenu = uiextensions.GetMenu("UIListMenu") as UIListMenu

    int textOptionCount = 1 ; Including an empty space and "Choose Test Suite"
    listMenu.AddEntryItem("--- [Choose Expectation] ---")

    int i = 0
    while i < expectationCount
        int expectationNumber = i + 1
        int expectation = JArray.getObj(expectations, i)
        string description = SkyUnitExpectation.GetDescription(expectation)
        string status = JMap.getStr(expectation, "status")
        listMenu.AddEntryItem("#" + expectationNumber + " [" + status + "] " + description)
        i += 1
    endWhile

    listMenu.OpenMenu()

    int selection = listMenu.GetResultInt()
    if selection > -1
        int selectedExpectation = JArray.getObj(expectations, selection - 1)
        UI_Show_Expectation(selectedExpectation)
    endIf
endFunction

function UI_Show_Expectation(int expectation)
    string text = SkyUnitExpectation.GetDescription(expectation) + "\n" + JMap.getStr(expectation, "status") + "\n\n"

    Debug.MessageBox(text) ; TODO

    ; SkyUnitPrivateAPI api = SkyUnitPrivateAPI.GetInstance()
    ; api.SkyUnitMessageTextFormBase.SetName("...")
endFunction

string function GetTextEntryResult(string defaultText = "")
    UITextEntryMenu menu = UIExtensions.GetMenu("UITextEntryMenu") as UITextEntryMenu
    menu.SetPropertyString("text", defaultText)
    menu.OpenMenu()
    return menu.GetResultString()
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI Helper Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function NamesByStatus_AddItem(int map, string name, string status)
    if JMap.hasKey(map, status)
        JArray.addStr(JMap.getObj(map, status), name)
    else
        int array = JArray.object()
        JMap.setObj(map, status, array)
        JArray.addStr(array, name)
    endIf
endFunction

string function UI_GetTestSummaryLineFromMap(int map, string separator = ", ")
    int failing
    int passing
    int pending
    if JMap.hasKey(map, "FAILING")
        failing += JArray.count(JMap.getObj(map, "FAILING"))
    endIf
    if JMap.hasKey(map, "PASSING")
        passing += JArray.count(JMap.getObj(map, "PASSING"))
    endIf
    if JMap.hasKey(map, "PENDING")
        pending += JArray.count(JMap.getObj(map, "PENDING"))
    endIf
    return UI_GetTestSummaryLine(failing, passing, pending, separator)
endFunction

string function UI_GetTestSummaryLine(int failing, int passing, int pending, string separator = ", ")
    string text = ""
    if failing > 0
        text += failing + " failed"
    endIf
    if passing > 0
        if text
            text += separator
        endIf
        text += passing + " passed"
    endIf
    if pending > 0
        if text
            text += separator
        endIf
        text += pending + " pending"
    endIf
    return text
endFunction

string function UI_GetLinesShowingNamesForEachStatus(int map, int maxLines = 9)
    int totalLines = 0
    int failing = JMap.getObj(map, "FAILING")
    int passing = JMap.getObj(map, "PASSING")
    int pending = JMap.getObj(map, "PENDING")
    int i
    int count
    string text = ""
    if failing
        text += "\n"
        totalLines += 1
        if totalLines >= maxLines
            return text + "..."
        endIf
        i = 0
        count = JArray.count(failing)
        while i < count
            text += "[FAIL] " + JArray.getStr(failing, i) + "\n"
            totalLines += 1
            if totalLines >= maxLines
                return text + "..."
            endIf
            i += 1
        endWhile
    endIf
    if passing
        text += "\n"
        totalLines += 1
        if totalLines >= maxLines
            return text + "..."
        endIf
        i = 0
        count = JArray.count(passing)
        while i < count
            text += "[PASS] " + JArray.getStr(passing, i) + "\n"
            totalLines += 1
            if totalLines >= maxLines
                return text + "..."
            endIf
            i += 1
        endWhile
    endIf
    if pending
        text += "\n"
        totalLines += 1
        if totalLines >= maxLines
            return text + "..."
        endIf
        i = 0
        count = JArray.count(pending)
        while i < count
            text += "[PENDING] " + JArray.getStr(pending, i) + "\n"
            totalLines += 1
            if totalLines >= maxLines
                return text + "..."
            endIf
            i += 1
        endWhile
    endIf
    return text
endFunction

function SaveToFile(int object, string fileName)
    if fileName
        MiscUtil.WriteToFile(fileName, "", append = false) ; empty the file in case we're writing an empty object
        JValue.writeToFile(object, fileName)
    endIf
endFunction