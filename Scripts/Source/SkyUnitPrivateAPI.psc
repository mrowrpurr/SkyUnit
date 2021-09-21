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

ALL CODE IN THIS FILE IS SUBJECT TO CHANGE!
DO NOT USE ANY OF THE CODE IN THIS FILE!
WE MAY REFACTOR THESE INTERNALS OFTEN!

Please only use the publicly provided API interfaces:
- SkyUnitTest (for writing tests)
- SkyUnitExpectation (for writing and introspecting expectations)

At this time, there is no public API for running tests.
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Script Instance Interface
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

; Messages and hacky alias for dynamically setting Message text
Form property SkyUnitMessageTextFormBase auto
Message property SkyUnitTestSuiteMessage auto
Message property SkyUnitTestMessage auto
Message property SkyUnitExpectationMessage auto
Message property SkyUnitAllTestSuitesMessage auto

function OkMessageBox(string text) global
    ; SkyUnitPrivateAPI api = SkyUnitPrivateAPI.GetInstance()
    ; api.SkyUnitMessageTextFormBase.SetName(text)
    ; api.SkyUnitOkMessage.Show()
    Debug.MessageBox(text)
endFunction

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
    JMap.setObj(context, "testSuiteMostRecentResultsByName", JMap.object())
    JMap.setObj(context, "currentTestResult", JMap.object())
    JMap.setObj(context, "currentTestSuiteResult", JMap.object())
    JMap.setObj(context, "currentlyRunningTestSuite", JMap.object())
    JMap.setObj(context, "currentlyRunningTestRun", JMap.object())
    JMap.setObj(context, "testRuns", JMap.object())
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
;; Global Interface
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
        testScript.Tests() ; TODO TODO TODO TODO Update this to properly run things including the BeforeEach/After etc!
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

int function SkyUnitData_GetCurrentTestRunsMap() global
    return JDB.solveObj(".skyUnit.currentContext.testRuns")
endFunction

int function SkyUnitData_CreateNewTestRunMap(string testRunName = "") global
    if ! testRunName
        testRunName = Utility.GetCurrentRealTime() + "_" + Utility.RandomInt(1, 1000000)
    endIf
    int testRuns = SkyUnitData_GetCurrentTestRunsMap()
    int testRun = JMap.object()
    JMap.setObj(testRuns, testRunName, testRun)
    JMap.setStr(testRun, "testRunName", testRunName)
    JMap.setObj(testRun, "testSuites", JMap.object())
    JMap.setFlt(testRun, "startTime", Utility.GetCurrentRealTime())
    return testRun
endFunction

function SkyUnitData_SetCurrentlyRunningTestRun(int testRun) global
    JDB.solveObjSetter(".skyUnit.currentContext.currentlyRunningTestRun", testRun)
endFunction

int function SkyUnitData_GetCurrentlyRunningTestRun() global
    return JDB.solveObj(".skyUnit.currentContext.currentlyRunningTestRun")
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

int function SkyUnitData_GetMostRecentTestResultsMap() global
    return JDB.solveObj(".skyUnit.currentContext.testSuiteMostRecentResultsByName")
endFunction

function SkyUnitData_AddTestSuiteResultToMostRecentlyRunResults(string testSuiteName, int testRunResult) global
    JMap.setObj(SkyUnitData_GetMostRecentTestResultsMap(), testSuiteName, testRunResult)
endFunction

int function SkyUnitData_GetMostRecentResultForTestSuiteByName(string testSuiteName) global
    return JMap.getObj(SkyUnitData_GetMostRecentTestResultsMap(), testSuiteName)
endFunction

bool function SkyUnitData_TestSuiteHasBeenRun(string testSuiteName) global
    return SkyUnitData_GetMostRecentResultForTestSuiteByName(testSuiteName) > 0
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

SkyUnitTest function SkyUnitData_GetCurrentTestScript() global
    int currentlyRunningTestResult = SkyUnitData_GetCurrentTestResult()
    if currentlyRunningTestResult
        string testSuiteName = JMap.getStr(currentlyRunningTestResult, "testSuiteName")
        if testSuiteName
            return GetTestScriptBySuiteName(testSuiteName)
        endIf
    endIf
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

; Run all test suites and return a result which contains .testSuites[test suite name] => test suite result.
int function RunAllTestSuites(bool forceRerun = false) global
    int testRun = SkyUnitData_CreateNewTestRunMap()
    SkyUnitData_SetCurrentlyRunningTestRun(testRun)
    string[] testSuiteNames = TestSuites()
    int i = 0
    while i < testSuiteNames.Length
        RunTestSuite(testSuiteNames[i], testRun, forceRerun)
        i += 1
    endWhile
    ; TODO DRY
    float now = Utility.GetCurrentRealTime()
    float startTime = JMap.getFlt(testRun, "startTime")
    float duration = now - startTime
    JMap.setFlt(testRun, "endTime", now)
    JMap.setFlt(testRun, "duration", duration)
    ;
    SkyUnitData_SetCurrentlyRunningTestRun(0)
    return testRun
endFunction

; Run the specified test suite and return a result which contains .testSuites[test suite name] => test suite result/
; This returns the same data structure as RunAllTestSuites() but only the specified test suite script will have been run.
int function RunTestSuite(string testSuiteName, int parentTestRun = 0, bool forceRerun = false) global
    GetLock()

    if SkyUnitData_TestSuiteHasBeenRun(testSuiteName) && ! forceRerun
        int previousTestRun = SkyUnitData_GetMostRecentResultForTestSuiteByName(testSuiteName)
        Info("Test Suite has previously been run, returning cached result: " + testSuiteName + " (test run #" + previousTestRun + ")")
        return previousTestRun
    endIf

    bool shouldStopTestRun = parentTestRun == 0

    if ! parentTestRun
        parentTestRun = SkyUnitData_CreateNewTestRunMap()
        SkyUnitData_SetCurrentlyRunningTestRun(parentTestRun)
    endIf

    int parentTestSuitesMap = JMap.getObj(parentTestRun, "testSuites")
    int testSuiteResult = JMap.object()
    JMap.setObj(parentTestSuitesMap, testSuiteName, testSuiteResult)

    Info("Run Test Suite: " + testSuiteName + " (test run #" + parentTestRun + " > test suite run #" + testSuiteResult + ")")
    SkyUnitData_SetCurrentlyRunningTestSuite(testSuiteResult)
    SkyUnitData_SetLatestSuiteResult(testSuiteResult)
    JMap.setStr(testSuiteResult, "testSuite", testSuiteName)
    JMap.setStr(testSuiteResult, "status", "PENDING")
    JMap.setObj(testSuiteResult, "tests", JMap.object())
    SkyUnitTest testScript = GetTestScriptBySuiteName(testSuiteName)

    Test_BeginTestRun(testSuiteName, SpecialTestNames_BeforeAll(), runBeforeEach = false)
    testScript.BeforeAll()
    Fn_EndTestRun(runAfterEach = false)

    testScript.Tests()

    Test_BeginTestRun(testSuiteName, SpecialTestNames_AfterAll(), runBeforeEach = false)
    testScript.AfterAll()
    Fn_EndTestRun(runAfterEach = false)

    int currentTestResult = SkyUnitData_GetCurrentTestResult()
    if currentTestResult
        ; The last one didn't finish, e.g. it was pending. We need to make sure to run AfterEach()
        Fn_EndTestRun(markPassed = false)
    endIf

    SkyUnitData_SetCurrentExpectation(0)
    SkyUnitData_SetCurrentTestResult(0)
    SkyUnitData_SetCurrentlyRunningTestSuite(0)

    ; Cache result (caches the full testRun for this for consistency)
    SkyUnitData_AddTestSuiteResultToMostRecentlyRunResults(testSuiteName, parentTestRun)

    if shouldStopTestRun
        ; TODO DRY
        float now = Utility.GetCurrentRealTime()
        float startTime = JMap.getFlt(parentTestRun, "startTime")
        float duration = now - startTime
        JMap.setFlt(parentTestRun, "endTime", now)
        JMap.setFlt(parentTestRun, "duration", duration)
        ;
        SkyUnitData_SetCurrentlyRunningTestRun(0)
    endIf

    ReleaseLock()

    return parentTestRun
endFunction

string function SpecialTestNames_BeforeAll() global
    return "[SkyUnitTest.BeforeAll()]"
endFunction

string function SpecialTestNames_AfterAll() global
    return "[SkyUnitTest.AfterAll()]"
endFunction

; TODO - Before Each
function Test_BeginTestRun(string testSuiteName, string testName, bool runBeforeEach = true) global
    int currentTestResult = SkyUnitData_GetCurrentTestResult()
    if currentTestResult
        ; The previouis one didn't finish, e.g. it was pending. We need to make sure to run AfterEach()
        Fn_EndTestRun(markPassed = false) ; It's pending
    endIf

    JMap.setObj(SkyUnitData_TestSuiteTestsMap(testSuiteName), testName, JMap.object())
    int testResult = JMap.object()
    int currentlyRunningTestSuiteResult = SkyUnitData_GetCurrentlyRunningTestSuite()
    int testRun = SkyUnitData_GetCurrentlyRunningTestRun()
    Info("Run Test: " + testSuiteName + " > " + testName + " (test run #" + testRun + " > test suite run #" + currentlyRunningTestSuiteResult + " > test #" + testResult + ")")
    int currentlyRunningTestsMap = JMap.getObj(currentlyRunningTestSuiteResult, "tests")
    JMap.setObj(currentlyRunningTestsMap, testName, testResult)
    JMap.setStr(testResult, "testName", testName)
    JMap.setStr(testResult, "testSuiteName", testSuiteName)
    JMap.setStr(testResult, "status", "PENDING")
    JMap.setObj(testResult, "expectations", JArray.object())
    JMap.setInt(testResult, "testSuiteResultId", currentlyRunningTestSuiteResult)
    SkyUnitData_SetCurrentTestResult(testResult)
    SkyUnitData_SetCurrentExpectation(0)

    if runBeforeEach
        SkyUnitData_GetCurrentTestScript().BeforeEach() ; BeforeEach always runs, even for pending tests. Because of Papyrus limitations.
    endIf
endFunction

function Fn_EndTestRun(bool runAfterEach = true, bool markPassed = true) global
    if runAfterEach
        SkyUnitData_GetCurrentTestScript().AfterEach()
    endIf

    int testResult = SkyUnitData_GetCurrentTestResult()
    if markPassed
        if JMap.getStr(testResult, "status") != "FAILING"
            JMap.setStr(testResult, "status", "PASSING")
        endIf
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

; Display the UI (if there are any tests available to run)
function ShowUI() global
    string[] testSuiteNames = TestSuites()
    if testSuiteNames.Length > 0
        UI_Show_MainMenu(testSuiteNames)
    else
        Debug.MessageBox("No tests found")
    endIf
endFunction

; function ShowBrowseTestSuitesChooserUI(string[] testSuiteNames) global
;     UIListMenu listMenu = uiextensions.GetMenu("UIListMenu") as UIListMenu

;     int textOptionCount = 1
;     listMenu.AddEntryItem("--- [View Test Suite] ---")

;     int suiteIndex = 0
;     while suiteIndex < testSuiteNames.Length
;         listMenu.AddEntryItem(testSuiteNames[suiteIndex])
;         suiteIndex += 1
;     endWhile

;     listMenu.OpenMenu()

;     int selection = listMenu.GetResultInt()
;     if selection > -1
;         string testSuiteName = testSuiteNames[selection - textOptionCount]
;         ShowTestSuiteTestsUI(testSuiteName)
;     endIf
; endFunction

; function ShowTestSuiteTestsUI(string testSuiteName) global
;     string[] testNames = TestNamesInSuite(testSuiteName)

;     UIListMenu listMenu = uiextensions.GetMenu("UIListMenu") as UIListMenu

;     int textOptionCount = 1
;     listMenu.AddEntryItem("--- [" + testSuiteName + "] ---")

;     int testIndex = 0
;     while testIndex < testNames.Length
;         listMenu.AddEntryItem(testNames[testIndex])
;         testIndex += 1
;     endWhile

;     listMenu.OpenMenu()

;     int selection = listMenu.GetResultInt()
;     if selection > -1
;         string testName = testNames[selection - textOptionCount]
;         int tests = JMap.getObj(RunTestSuite(testSuiteName), "tests")
;         int testResult = JMap.getObj(tests, testName)
;         ShowSingleTestResult(testSuiteName, testName, testResult)
;         WriteSkyUnitDebugJsonFile()
;     endIf
; endFunction

; function ShowSingleTestResult(string testSuiteName, string testName, int testResult) global



;     Info("Show Single Test Result " + testSuiteName + " " + testName + " (test result #" + JMap.getInt(testResult, "testSuiteResultId") + " > #" + testResult + ")")
;     int failing = 0
;     int passing = 0
;     int pending = 0
;     int skipped = 0

;     int i = 0
;     int expectationCount = SkyUnitExpectation.GetExpectationCount(testResult)
;     while i < expectationCount
;         int expectation = SkyUnitExpectation.GetNthExpectation(testResult, i)
;         string status = SkyUnitExpectation.GetStatus(expectation)
;         if status == "FAILING"
;             failing += 0
;         elseIf status == "PASSING"
;             passing += 0
;         elseIf status == "PENDING"
;             pending += 0
;         elseIf status == "SKIPPED"
;             skipped += 0
;         endIf
;         i += 1
;     endWhile

;     string text = "[" + testSuiteName + "]\n\n" + testName + "\n"
;     text += GetTestSummaryLine(failing, passing, pending, skipped) + "\n"

;     i = 0
;     while i < expectationCount
;         int expectation = SkyUnitExpectation.GetNthExpectation(testResult, i)
;         string status = SkyUnitExpectation.GetStatus(expectation)
;         string expectationNumber = "#" + (i + 1)
;         string description = SkyUnitExpectation.GetDescription(expectation)
;         string failureMessage = SkyUnitExpectation.GetFailureMessage(expectation)
;         if status == "FAILING"
;             text += expectationNumber + " [" + status + "]\n" + description + "\n"
;             if failureMessage
;                 text += failureMessage + "\n"
;             endIf
;         endIf
;         i += 1
;     endWhile

;     ; Debug.MessageBox(text)
;     OkMessageBox(text)
; endFunction

; function RunTestSuiteAndDisplayResult(string testSuiteName) global
;     int testSuiteResult = RunTestSuite(testSuiteName)
;     string text = ""

;     int tests = JMap.getObj(testSuiteResult, "tests")
;     string[] testNames = JMap.allKeysPArray(tests)

;     int failing = JArray.object()
;     int passing = JArray.object()
;     int pending = JArray.object()
;     int skipped = JArray.object()

;     int i = 0
;     while i < testNames.Length
;         string name = testNames[i]
;         int test = JMap.getObj(tests, name)
;         string status = JMap.getStr(test, "status")
;         if status == "FAILING"
;             JArray.addStr(failing, name)
;         elseIf status == "PASSING"
;             JArray.addStr(passing, name)
;         elseIf status == "PENDING"
;             JArray.addStr(pending, name)
;         elseIf status == "SKIPPED"
;             JArray.addStr(skipped, name)
;         endIf
;         i += 1
;     endWhile

;     text += "[" + testSuiteName + "]\n"
;     text += JMap.getStr(testSuiteResult, "status") + "\n\n"
;     text += GetTestSummaryLine(JArray.count(failing), JArray.count(passing), JArray.count(pending), JArray.count(skipped)) + "\n"
    
;     if JArray.count(failing) > 0
;         text += "\nFailing:\n"
;         i = 0
;         while i < JArray.count(failing)
;             text += JArray.getStr(failing, i) + "\n"
;             i += 1
;         endWhile
;     endIf
;     if JArray.count(passing) > 0
;         text += "\nPassing:\n"
;         i = 0
;         while i < JArray.count(passing)
;             text += JArray.getStr(passing, i) + "\n"
;             i += 1
;         endWhile
;     endIf
;     if JArray.count(pending) > 0
;         text += "\nPending:\n"
;         i = 0
;         while i < JArray.count(pending)
;             text += JArray.getStr(pending, i) + "\n"
;             i += 1
;         endWhile
;     endIf
;     if JArray.count(skipped) > 0
;         text += "\nSkipped:\n"
;         i = 0
;         while i < JArray.count(skipped)
;             text += JArray.getStr(skipped, i) + "\n"
;             i += 1
;         endWhile
;     endIf

;     ; Debug.MessageBox(text)
;     OkMessageBox(text)

;     WriteSkyUnitDebugJsonFile()
; endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function UI_Show_MainMenu(string[] testSuiteNames) global
    string option_RunAllTestSuites_text       = "Run All Test Suites"
    int option_RunAllTestSuites_index         = 0
    ;
    string option_FilterTestSuites_text       = "Filter Test Suites"
    int option_FilterTestSuites_index         = 1
    ;
    string option_BrowseTestSuites_text       = "Browse Test Suites"
    int option_BrowseTestSuites_index         = 2

    UIListMenu listMenu = uiextensions.GetMenu("UIListMenu") as UIListMenu

    int textOptionCount = 5 ; Including an empty space and "Choose Test Suite to Run"

    listMenu.AddEntryItem(option_RunAllTestSuites_text)
    listMenu.AddEntryItem(option_FilterTestSuites_text)
    listMenu.AddEntryItem(option_BrowseTestSuites_text)
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
        if selection == option_RunAllTestSuites_index
            UI_Show_AllTestSuiteResults(RunAllTestSuites())
        elseIf selection == option_FilterTestSuites_index
            ; ShowAllTestSuiteFilterAndRunAllTestResultsAndDisplayResult(testSuiteNames)
        elseIf selection == option_BrowseTestSuites_index
            ; ShowBrowseTestSuitesChooserUI(testSuiteNames)
        elseIf selection == option_BrowseTestSuites_index
            ; ShowBrowseTestSuitesChooserUI(testSuiteNames)
        elseIf selection >= textOptionCount
            ; RunTestSuiteAndDisplayResult(testSuiteNames[selection - textOptionCount])
        endIf
    endIf
endFunction

function UI_Show_AllTestSuiteResults(int testRun) global
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

    ; 15 Lines
    string text = "[All Test Suites]\n\n"
    text += UI_GetTestSummaryLineFromMap(testNamesByStatus) + "\n"
    text += UI_GetLinesShowingNamesForEachStatus(testNamesByStatus)
    string[] durationParts = StringUtil.Split(JMap.getFlt(testRun, "duration"), ".")
    text += "\n\nDuration: " + durationParts[0] + "." + StringUtil.Substring(durationParts[1], 0, 2) + " seconds"

    SkyUnitPrivateAPI api = SkyUnitPrivateAPI.GetInstance()
    api.SkyUnitMessageTextFormBase.SetName(text)
    api.SkyUnitAllTestSuitesMessage.Show()

    JValue.writeToFile(SkyUnitData_TopLevelMap(), "AllTestResults.json")
    Debug.Notification("Wrote AllTestResults.json")
endFunction

function UI_Show_TestSuiteResult(int testSuiteResult) global

endFunction

function UI_Show_TestResult(int testResult) global

endFunction

function UI_Show_Expectation(int expectationId) global

endFunction

function UI_PrintToConsole_TestSuiteResult(int testSuiteResult) global

endFunction

function UI_PrintToConsole_TestResult(int testSuiteResult) global

endFunction

function UI_PrintToConsole_Expectation(int testSuiteResult) global

endFunction

string function GetTextEntryResult() global
    UITextEntryMenu menu = UIExtensions.GetMenu("UITextEntryMenu") as UITextEntryMenu
    menu.OpenMenu()
    return menu.GetResultString()
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI Helper Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function NamesByStatus_AddItem(int map, string name, string status) global
    if JMap.hasKey(map, status)
        JArray.addStr(JMap.getObj(map, status), name)
    else
        int array = JArray.object()
        JMap.setObj(map, status, array)
        JArray.addStr(array, name)
    endIf
endFunction

string function UI_GetTestSummaryLineFromMap(int map, string separator = ", ") global
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

string function UI_GetTestSummaryLine(int failing, int passing, int pending, string separator = ", ") global
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

string function UI_GetLinesShowingNamesForEachStatus(int map) global
    int totalLines = 0
    int maxLines = 7
    int failing = JMap.getObj(map, "FAILING")
    int passing = JMap.getObj(map, "PASSING")
    int pending = JMap.getObj(map, "PENDING")
    int i
    int count
    string text = ""
    if failing
        text += "\n[FAILING]\n"
        totalLines += 2
        if totalLines >= maxLines
            return text + "..."
        endIf
        i = 0
        count = JArray.count(failing)
        while i < count
            text += JArray.getStr(failing, i) + "\n"
            totalLines += 1
            if totalLines >= maxLines
                return text + "..."
            endIf
            i += 1
        endWhile
    endIf
    if passing
        text += "\n[PASSING]\n"
        totalLines += 2
        if totalLines >= maxLines
            return text + "..."
        endIf
        i = 0
        count = JArray.count(passing)
        while i < count
            text += JArray.getStr(passing, i) + "\n"
            totalLines += 1
            if totalLines >= maxLines
                return text + "..."
            endIf
            i += 1
        endWhile
    endIf
    if pending
        text += "\n[PENDING]\n"
        totalLines += 2
        if totalLines >= maxLines
            return text + "..."
        endIf
        i = 0
        count = JArray.count(pending)
        while i < count
            text += JArray.getStr(pending, i) + "\n"
            totalLines += 1
            if totalLines >= maxLines
                return text + "..."
            endIf
            i += 1
        endWhile
    endIf
    return text
endFunction

string function JArray_StrJoin(int array, string separator = " ") global
    string text = ""
    if array
        int count = JArray.count(array)
        if count
            int i = 0
            while i < count
                text += JArray.getStr(array, i)
                if i != count - 1 ; Don't add separator after last item
                    text += separator
                endIf
                i += 1
            endWhile
        endIf
    endIf
    return text
endFunction
