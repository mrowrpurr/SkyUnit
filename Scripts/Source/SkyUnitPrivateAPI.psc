scriptName SkyUnitPrivateAPI extends ReferenceAlias  
{[PRIVATE] [DO NOT USE]

Internal API for SkyUnit and SkyUnit UI.

Please see `SkyUnitTest` for implementing tests
and `SkyUnitExpectation` for implementing custom expectations and assertions.

This is used to:
- Detect SkyUnit tests when the game loads.
- Show # of tests loaded.
- Auto-equip SkyUnit test runner spell.
- Perform upgrades on player load game, if necessary.
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Script Instance Interface
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Currently installed version of SkyUnit
float property CurrentlyInstalledModVersion auto

; Spell which runs SkyUnit tests
Spell property SkyUnitTestRunnerSpell auto

; References to SkyUnitTest scripts
SkyUnitTest[] property TestSuiteScripts0 auto
SkyUnitTest[] property TestSuiteScripts1 auto
SkyUnitTest[] property TestSuiteScripts2 auto
SkyUnitTest[] property TestSuiteScripts3 auto
SkyUnitTest[] property TestSuiteScripts4 auto
SkyUnitTest[] property TestSuiteScripts5 auto
SkyUnitTest[] property TestSuiteScripts6 auto
SkyUnitTest[] property TestSuiteScripts7 auto
SkyUnitTest[] property TestSuiteScripts8 auto
SkyUnitTest[] property TestSuiteScripts9 auto

; Fields for assertions (these types cannot be stored in JContaienrs and are stored here instead)
Alias property CurrentExpectationActualValue_Alias auto
ActiveMagicEffect property CurrentExpectationActualValue_ActiveMagicEffect auto

event OnInit()
    PerformModInstallation()
    Utility.WaitMenuMode(2.5)
    InitializeUI()
endEvent

event OnPlayerLoadGame()
    PerformModUpgrade()
    Utility.WaitMenuMode(2.5)
    InitializeUI()
endEvent

function InitializeUI()
    string[] testSuiteNames = TestSuites()
    Info("Test Suites: " + testSuiteNames)
    if testSuiteNames.Length > 0
        int leftHand = 0
        GetActorReference().EquipSpell(SkyUnitTestRunnerSpell, leftHand)
        Debug.Notification(testSuiteNames.Length + " Tests Found")
    endIf
endFunction

function PerformModInstallation()
    CurrentlyInstalledModVersion = CurrentVersion()
    InitializeDataStorage()
endFunction

function PerformModUpgrade()
    ; Nothing here yet! Only 1 version of SkyUnit is currently available.
endFunction

function InitializeDataStorage()
    int skyUnitMap = JMap.object()
    JDB.solveObjSetter(".skyUnit", skyUnitMap, createMissingKeys = true)

    int skyUnitContextsMap = JMap.object()
    JDB.solveObjSetter(".skyUnit.contexts", skyUnitContextsMap, createMissingKeys = true)

    ; Setup "slot number" array
    int testScriptAvailableSlotNumbersArray = JArray.object()
    JDB.solveObjSetter(".skyUnit.availableTestScriptSlotNumbers", testScriptAvailableSlotNumbersArray, createMissingKeys = true)
    int minSlotNumber = 0
    int maxSlotNumber = 128 * 10
    int index = minSlotNumber
    while index < maxSlotNumber
        JArray.addInt(testScriptAvailableSlotNumbersArray, index)
        index += 1
    endWhile

    TestSuiteScripts0 = new SkyUnitTest[128]
    TestSuiteScripts1 = new SkyUnitTest[128]
    TestSuiteScripts2 = new SkyUnitTest[128]
    TestSuiteScripts3 = new SkyUnitTest[128]
    TestSuiteScripts4 = new SkyUnitTest[128]
    TestSuiteScripts5 = new SkyUnitTest[128]
    TestSuiteScripts6 = new SkyUnitTest[128]
    TestSuiteScripts7 = new SkyUnitTest[128]
    TestSuiteScripts8 = new SkyUnitTest[128]
    TestSuiteScripts9 = new SkyUnitTest[128]

    CreateContext("default")
    SwitchToContext("default")

    Info("Ready")
    JDB.solveIntSetter(".skyUnit.ready", 1, createMissingKeys = true)
endFunction

function CreateContext(string name) global
    int context = JMap.object()
    JDB.solveObjSetter(".skyUnit.contexts." + name, context, createMissingKeys = true)
    JMap.setStr(context, "contextName", name)
    JMap.setObj(context, "testSuitesByName", JMap.object())
    JMap.setObj(context, "currentTestResult", JMap.object())
    JMap.setObj(context, "currentTestSuiteResult", JMap.object())
    JMap.setObj(context, "currentlyRunningTestSuite", JMap.object())
    JMap.setObj(context, "currentExpectation", JMap.object())
    JMap.setFlt(context, "lock", 0.0)
endFunction

function DeleteContext(string name) global
    int contexts = SkyUnitData_GetTopLevelContextsMap()
    JMap.removeKey(contexts, name)
endFunction

function SwitchToContext(string name) global
    int context = JDB.solveObj(".skyUnit.contexts." + name)
    JDB.solveObjSetter(".skyUnit.currentContext", context, createMissingKeys = true)
endFunction

bool function ContextExists(string name) global
    return JDB.solveObj(".skyUnit.contexts." + name) != 0
endFunction

string function CurrentContext() global
    return JDB.solveStr(".skyUnit.currentContext.contextName")
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Global Interface
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Get the currently installed of SkyUnit
float function CurrentVersion() global
    return 1.0
endFunction

; Returns the instance of the SkyUnitPrivateAPI script
SkyUnitPrivateAPI function GetInstance() global
    Quest skyUnitQuest = Game.GetFormFromFile(0xd65, "SkyUnit.esp") as Quest
    return skyUnitQuest.GetAliasByName("PlayerRef") as SkyUnitPrivateAPI
endFunction

; Blocks until SkyUnit is ready for test registration and data querying
function WaitForDataToBeInitialized() global
    while ! JDB.solveInt(".skyUnit.ready") == 1
        Info("Waiting...")
        Utility.WaitMenuMode(0.1)
    endWhile
    Info("Done waiting!")
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Getting Test Suites and Test Names
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Returns array of names of all currently registered Test Suites.
string[] function TestSuites() global
    return JMap.allKeysPArray(SkyUnitData_TestSuitesByNameMap())
endFunction

; Returns array of names of the tests in the specified test suite.
string[] function TestNamesInSuite(string testSuiteName) global
    int testSuiteMap = SkyUnitData_TestSuiteByName(testSuiteName)
    int testsMap = SkyUnitData_TestSuiteTestsMap(testSuiteName)
    bool alreadyLoadedTestNames = JMap.getInt(testSuiteMap, "testNamesLoaded") == 1
    if ! alreadyLoadedTestNames
        SkyUnitTest testScript = GetTestScriptBySuiteName(testSuiteName)
        GetLock()
        testScript.Tests()
        ReleaseLock()
        JMap.setInt(testSuiteMap, "testNamesLoaded", 1)
    endIf
    return JMap.allKeysPArray(testsMap)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Misc Helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

string function ScriptDisplayName(SkyUnitTest suiteScript) global
    string suiteFullName = suiteScript
    int spaceIndex = StringUtil.Find(suiteFullName, " ")
    return StringUtil.Substring(suiteFullName, 1, spaceIndex - 1)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JDB Data Access Helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; TODO update all getters to start with Get*()

int function SkyUnitData_TopLevelMap() global
    return JDB.solveObj(".skyUnit")
endFunction

int function SkyUnitData_GetTopLevelContextsMap() global
    return JDB.solveObj(".skyUnit.contexts")
endFunction

int function SkyUnitData_TestSuitesByNameMap() global
    return JDB.solveObj(".skyUnit.currentContext.testSuitesByName")
endFunction

int function SkyUnitData_TestSuiteByName(string testSuiteName) global
    return JMap.getObj(SkyUnitData_TestSuitesByNameMap(), testSuiteName)
endFunction

int function SkyUnitData_TestSuiteTestsMap(string testSuiteName) global
    return JMap.getObj(SkyUnitData_TestSuiteByName(testSuiteName), "tests")
endFunction

int function SkyUnitData_TestMap(string testSuiteName, string testName) global
    return JMap.getObj(SkyUnitData_TestSuiteTestsMap(testSuiteName), testName)
endFunction

int function SkyUnitData_AvailableTestSuiteScriptSlotNumbersArray() global
    return JDB.solveObj(".skyUnit.availableTestScriptSlotNumbers")
endFunction

int function SkyUnitData_GetCurrentTestResult() global
    return JDB.solveObj(".skyUnit.currentContext.currentTestResult")
endFunction

function SkyUnitData_SetCurrentTestResult(int testResult) global
    JDB.solveObjSetter(".skyUnit.currentContext.currentTestResult", testResult)
endFunction

int function SkyUnitData_CurrentExpectationsArray() global
    return JMap.getObj(SkyUnitData_GetCurrentTestResult(), "expectations")
endFunction

function SkyUnitData_SetCurrentExpectation(int expectation) global
    JDB.solveObjSetter(".skyUnit.currentContext.currentExpectation", expectation)
endFunction

int function SkyUnitData_GetCurrentExpectation() global
    return JDB.solveObj(".skyUnit.currentContext.currentExpectation")
endFunction

int function SkyUnitData_GetCurrentlyRunningTestSuite() global
    return JDB.solveObj(".skyUnit.currentContext.currentlyRunningTestSuite")
endFunction

function SkyUnitData_SetCurrentlyRunningTestSuite(int testSuiteMap) global
    JDB.solveObjSetter(".skyUnit.currentContext.currentlyRunningTestSuite", testSuiteMap)
endFunction

int function SkyUnitData_GetLatestSuiteResult() global
    return JDB.solveObj(".skyUnit.currentContext.currentTestSuiteResult")
endFunction

function SkyUnitData_SetLatestSuiteResult(int latestTestResult) global
    JDB.solveObjSetter(".skyUnit.currentContext.currentTestSuiteResult", latestTestResult)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Logging
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function Info(string text) global
    Debug.Trace("[SkyUnit] " + text, aiSeverity = 0)
endFunction

function Warn(string text) global
    Debug.Trace("[SkyUnit] [WARNING] " + text, aiSeverity = 1)
endFunction

function Error(string text) global
    Debug.Trace("[SkyUnit] [ERROR] " + text, aiSeverity = 2)
endFunction

function WriteSkyUnitDebugJsonFile() global
    JValue.writeToFile(JDB.solveObj(".skyUnit"), "SkyUnitTests.json")
    Debug.Notification("Write SkyUnitTests.json")
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Locking (prevent parallel async scripts)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

float function GetCurrentLock() global
    return JDB.solveFlt(".skyUnit.currentContext.lock")
endFunction

function SetCurrentLock(float lock) global
    JDB.solveFltSetter(".skyUnit.currentContext.lock", lock)
endFunction

function GetLock(float lock = 0.0) global
    if lock == 0.0
        lock = Utility.RandomFloat(1.0, 1000000.0)
    endIf

    while GetCurrentLock() != 0.0
        Utility.WaitMenuMode(0.05)
    endWhile

    SetCurrentLock(lock)

    if GetCurrentLock() == lock
        if GetCurrentLock() == lock
            return
        else
            GetLock(lock)
        endIf
    else
        GetLock(lock)
    endIf
endFunction

function ReleaseLock() global
    SetCurrentLock(0.0)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Suite Registration / Test Scripts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function RegisterTestSuite(SkyUnitTest suiteScript, string suiteName = "") global
    WaitForDataToBeInitialized()
    GetLock()

    Info("Register Test Suite: " + suiteScript + " " + suiteName)

    int testSuitesByName = SkyUnitData_TestSuitesByNameMap()

    if ! suiteName
        suiteName = ScriptDisplayName(suiteScript)
    endIf

    int testSuiteMap = JMap.object()
    JMap.setObj(testSuitesByName, suiteName, testSuiteMap)

    int testsMap = JMap.object()
    JMap.setObj(testSuiteMap, "tests", testsMap)

    if suiteScript
        int scriptSlotNumber = ClaimAvailableTestSuiteScriptArraySlotNumber()
        JMap.setInt(testSuiteMap, "scriptArraySlotNumber", scriptSlotNumber)
        SetTestScriptForSlotNumber(scriptSlotNumber, suiteScript)
    else
        Warn("RegisterTestSuite() called with None script [" + suiteName + "]")
    endIf

    ReleaseLock()
endFunction

int function ClaimAvailableTestSuiteScriptArraySlotNumber() global
    int slotNumber
    int availableSlotNumbersArray = SkyUnitData_AvailableTestSuiteScriptSlotNumbersArray()
    int countOfAvailableSlots = JArray.count(availableSlotNumbersArray)
    if countOfAvailableSlots == 0
        Error("Cannot register script because there are no available SkyUnitTest script slots to store this script. Are there already 1,280 scripts registered?")
    else
        int slotIndex = countOfAvailableSlots - 1
        slotNumber = JArray.getInt(availableSlotNumbersArray, slotIndex)
        JArray.eraseIndex(availableSlotNumbersArray, slotIndex)
    endIf
    return slotNumber
endFunction

function SetTestScriptForSlotNumber(int slotNumber, SkyUnitTest testScript) global
    SkyUnitPrivateAPI api = GetInstance()
    int arrayNumber = slotNumber / 128
    int arrayIndex = slotNumber % 128
    if arrayNumber == 0
        api.TestSuiteScripts0[arrayIndex] = testScript
    elseIf arrayNumber == 1
        api.TestSuiteScripts1[arrayIndex] = testScript
    elseIf arrayNumber == 2
        api.TestSuiteScripts2[arrayIndex] = testScript
    elseIf arrayNumber == 3
        api.TestSuiteScripts3[arrayIndex] = testScript
    elseIf arrayNumber == 4
        api.TestSuiteScripts4[arrayIndex] = testScript
    elseIf arrayNumber == 5
        api.TestSuiteScripts5[arrayIndex] = testScript
    elseIf arrayNumber == 6
        api.TestSuiteScripts6[arrayIndex] = testScript
    elseIf arrayNumber == 7
        api.TestSuiteScripts7[arrayIndex] = testScript
    elseIf arrayNumber == 8
        api.TestSuiteScripts9[arrayIndex] = testScript
    elseIf arrayNumber == 9
        api.TestSuiteScripts9[arrayIndex] = testScript
    endIf
endFunction

SkyUnitTest function GetTestScriptForSlotNumber(int slotNumber) global
    SkyUnitPrivateAPI api = GetInstance()
    int arrayNumber = slotNumber / 128
    int arrayIndex = slotNumber % 128
    if arrayNumber == 0
        return api.TestSuiteScripts0[arrayIndex]
    elseIf arrayNumber == 1
        return api.TestSuiteScripts1[arrayIndex]
    elseIf arrayNumber == 2
        return api.TestSuiteScripts2[arrayIndex]
    elseIf arrayNumber == 3
        return api.TestSuiteScripts3[arrayIndex]
    elseIf arrayNumber == 4
        return api.TestSuiteScripts4[arrayIndex]
    elseIf arrayNumber == 5
        return api.TestSuiteScripts5[arrayIndex]
    elseIf arrayNumber == 6
        return api.TestSuiteScripts6[arrayIndex]
    elseIf arrayNumber == 7
        return api.TestSuiteScripts7[arrayIndex]
    elseIf arrayNumber == 8
        return api.TestSuiteScripts8[arrayIndex]
    elseIf arrayNumber == 9
        return api.TestSuiteScripts9[arrayIndex]
    endIf
endFunction

SkyUnitTest function GetTestScriptBySuiteName(string testSuiteName) global
    int testSuiteMap = SkyUnitData_TestSuiteByName(testSuiteName)
    int scriptSlotNumber = JMap.getInt(testSuiteMap, "scriptArraySlotNumber")
    SkyUnitTest testScript = GetTestScriptForSlotNumber(scriptSlotNumber)
    return testScript
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Running Tests
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function DoneWithTestResult(int testResult) global
    JValue.release(testResult)
endFunction

int function RunTestSuite(string testSuiteName) global
    GetLock()
    int testSuiteResult = JMap.object()
    SkyUnitData_SetCurrentlyRunningTestSuite(testSuiteResult)
    SkyUnitData_SetLatestSuiteResult(testSuiteResult)
    JMap.setStr(testSuiteResult, "testSuite", testSuiteName)
    JMap.setStr(testSuiteResult, "status", "PENDING")
    JMap.setObj(testSuiteResult, "tests", JMap.object())
    SkyUnitTest testScript = GetTestScriptBySuiteName(testSuiteName)

    ; TODO : BeforeAll()

    testScript.Tests()

    ; TODO : AfterAll()

    SkyUnitData_SetCurrentExpectation(0)
    SkyUnitData_SetCurrentTestResult(0)
    SkyUnitData_SetCurrentlyRunningTestSuite(0)
    ReleaseLock()
    return testSuiteResult
endFunction

int function RunSingleTest(string testSuiteName, string testName) global
    return JMap.getObj(RunTestSuite(testSuiteName), testName)
endFunction

; TODO - Before Each
function Test_BeginTestRun(string testSuiteName, string testName) global
    JMap.setObj(SkyUnitData_TestSuiteTestsMap(testSuiteName), testName, JMap.object())
    int testResult = JMap.object()
    int currentlyRunningTestSuiteResult = SkyUnitData_GetCurrentlyRunningTestSuite()
    int currentlyRunningTestsMap = JMap.getObj(currentlyRunningTestSuiteResult, "tests")
    JMap.setObj(currentlyRunningTestsMap, testName, testResult)
    JMap.setStr(testResult, "testName", testName)
    JMap.setStr(testResult, "status", "PENDING")
    JMap.setObj(testResult, "expectations", JArray.object())
    JMap.setInt(testResult, "testSuiteResultId", currentlyRunningTestSuiteResult)
    SkyUnitData_SetCurrentTestResult(testResult)
    SkyUnitData_SetCurrentExpectation(0)
endFunction

function Fn_EndTestRun() global
    int testResult = SkyUnitData_GetCurrentTestResult()
    if JMap.getStr(testResult, "status") != "FAILING"
        JMap.setStr(testResult, "status", "PASSING")
    endIf
    ; if JMap.getStr(SkyUnitData_GetLatestSuiteResultForTestSuite())
    int testSuiteResult = SkyUnitData_GetLatestSuiteResult()
    if JMap.getStr(testSuiteResult, "status") != "FAILING"
        JMap.setStr(testSuiteResult, "status", "PASSING")
    endIf
    SkyUnitData_SetCurrentTestResult(0)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SkyUnit User Interface
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function ShowUI() global
    string[] testSuiteNames = TestSuites()
    if testSuiteNames.Length > 0
        ShowTestSuiteChooserUI(testSuiteNames)
    else
        Debug.MessageBox("No tests found")
    endIf
endFunction

function ShowTestSuiteChooserUI(string[] testSuiteNames) global
    string option_RunAllTests_text = "Run All Tests"
    string option_RunTestsMatchingFilter_text = "Run Tests Matching Filter"
    string option_ViewTestSuite_text = "View Test Suite"
    string option_ViewTestSuitesMatchingFilter_text = "View Test Suites Matching Filter"

    int option_RunAllTests_index = 0
    int option_RunTestsMatchingFilter_index = 1
    int option_ViewTestSuite_index = 2
    int option_ViewTestSuitesMatchingFilter_index = 3

    uilistmenu listMenu = uiextensions.GetMenu("UIListMenu") as uilistmenu

    int textOptionCount = 6
    listMenu.AddEntryItem(option_RunAllTests_text)
    listMenu.AddEntryItem(option_RunTestsMatchingFilter_text)
    listMenu.AddEntryItem(option_ViewTestSuite_text)
    listMenu.AddEntryItem(option_ViewTestSuitesMatchingFilter_text)
    listMenu.AddEntryItem(" ")
    listMenu.AddEntryItem("--- [Choose Test Suite to Run] ---")

    int suiteIndex = 0
    while suiteIndex < testSuiteNames.Length
        listMenu.AddEntryItem(testSuiteNames[suiteIndex])
        suiteIndex += 1
    endWhile

    listMenu.OpenMenu()

    int selection = listMenu.GetResultInt()
    if selection > -1
        if selection == option_RunAllTests_index
            Debug.MessageBox("Not yet supported...")
        elseIf selection == option_RunTestsMatchingFilter_index
            Debug.MessageBox("Not yet supported...")
        elseIf selection == option_ViewTestSuite_index
            ShowViewTestSuiteChooserUI(testSuiteNames)
        elseIf selection == option_ViewTestSuite_index
            ShowViewTestSuiteChooserUI(testSuiteNames)
        elseIf selection == option_ViewTestSuitesMatchingFilter_index
            Debug.MessageBox("Not yet supported...")
        elseIf selection >= textOptionCount
            RunTestSuiteAndDisplayResult(testSuiteNames[selection - textOptionCount])
        endIf
    endIf
endFunction

function ShowViewTestSuiteChooserUI(string[] testSuiteNames) global
    uilistmenu listMenu = uiextensions.GetMenu("UIListMenu") as uilistmenu

    int textOptionCount = 1
    listMenu.AddEntryItem("--- [View Test Suite] ---")

    int suiteIndex = 0
    while suiteIndex < testSuiteNames.Length
        listMenu.AddEntryItem(testSuiteNames[suiteIndex])
        suiteIndex += 1
    endWhile

    listMenu.OpenMenu()

    int selection = listMenu.GetResultInt()
    if selection > -1
        string testSuiteName = testSuiteNames[selection - textOptionCount]
        ShowTestSuiteTestsUI(testSuiteName)
    endIf
endFunction

function ShowTestSuiteTestsUI(string testSuiteName) global
    string[] testNames = TestNamesInSuite(testSuiteName)

    uilistmenu listMenu = uiextensions.GetMenu("UIListMenu") as uilistmenu

    int textOptionCount = 1
    listMenu.AddEntryItem("--- [" + testSuiteName + "] ---")

    int testIndex = 0
    while testIndex < testNames.Length
        listMenu.AddEntryItem(testNames[testIndex])
        testIndex += 1
    endWhile

    listMenu.OpenMenu()

    int selection = listMenu.GetResultInt()
    if selection > -1
        string testName = testNames[selection - textOptionCount]
        int testResult = RunSingleTest(testSuiteName, testName)
        ShowSingleTestResult(testSuiteName, testName, testResult)
        ShowTestSuiteTestsUI(testSuiteName)
        string filename = "SkyUnit_Testing.json"
        JValue.writeToFile(SkyUnitData_TopLevelMap(), filename)
    endIf
endFunction

function ShowSingleTestResult(string testSuiteName, string testName, int testResult) global
    Debug.MessageBox("Test Result: " + JMap.getStr(testResult, "status"))
endFunction

function RunTestSuiteAndDisplayResult(string testSuiteName) global
    int testSuiteResult = RunTestSuite(testSuiteName)
    string text = ""

    text += "[" + testSuiteName + "]\n"
    text += JMap.getStr(testSuiteResult, "status") + "\n\n"

    int tests = JMap.getObj(testSuiteResult, "tests")
    string[] testNames = JMap.allKeysPArray(tests)

    int i = 0
    while i < testNames.Length
        string name = testNames[i]
        int test = JMap.getObj(tests, name)
        string status = JMap.getStr(test, "status")
        text += status + " - " + name + "\n"
        if status == "failed"
            ; get the failed expectations...
        endIf
        i += 1
    endWhile
    Debug.MessageBox(text)
    WriteSkyUnitDebugJsonFile()
endFunction
