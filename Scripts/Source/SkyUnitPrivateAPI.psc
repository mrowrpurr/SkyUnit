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
    ; Initialized Objects
    JMap.setObj(context, "testSuitesByName", JMap.object())
    JMap.setObj(context, "testSuiteMostRecentResultsByName", JMap.object())
    JMap.setObj(context, "testRuns", JMap.object())
    ; Uninitialized Objects`coc riverwood

    JMap.setObj(context, "currentTestResult", 0)
    JMap.setObj(context, "currentTestSuiteResult", 0)
    JMap.setObj(context, "currentlyRunningTestSuite", 0)
    JMap.setObj(context, "currentlyRunningTestRun", 0)
    JMap.setObj(context, "currentExpectation", 0)
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
    Info("Create New Test Run #" + testRun)
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

; Run all test suites and return a result which contains .testSuites[test suite name] => test suite result.
int function RunAllTestSuites(int testRun = 0, bool forceRerun = false) global
    if ! testRun
        testRun = SkyUnitData_GetCurrentlyRunningTestRun()
    endIf
    if ! testRun || forceRerun
        testRun = SkyUnitData_CreateNewTestRunMap()
        SkyUnitData_SetCurrentlyRunningTestRun(testRun)
    endIf

    Info("Run All Test Suites (test run #" + testRun + ")")

    string[] testSuiteNames = TestSuites()
    Info("Test Suites: " + testSuiteNames)
    int i = 0
    while i < testSuiteNames.Length
        RunTestSuite(testSuiteNames[i], testRun, forceRerun)
        i += 1
    endWhile

    return testRun
endFunction

; Run the specified test suite and return a result which contains .testSuites[test suite name] => test suite result/
; This returns the same data structure as RunAllTestSuites() but only the specified test suite script will have been run.
int function RunTestSuite(string testSuiteName, int parentTestRun = 0, bool forceRerun = false) global
    Info("RunTestSuite() test run #" + parentTestRun)
    GetLock()

    if ! parentTestRun
        parentTestRun = SkyUnitData_GetCurrentlyRunningTestRun()
        if ! parentTestRun
            parentTestRun = SkyUnitData_CreateNewTestRunMap()
            SkyUnitData_SetCurrentlyRunningTestRun(parentTestRun)
        endIf
    endIf

    if ! forceRerun && SkyUnitData_TestSuiteHasBeenRun(testSuiteName)
        int previousTestRun = SkyUnitData_GetMostRecentResultForTestSuiteByName(testSuiteName)
        Info("Test Suite has previously been run, returning cached result: " + testSuiteName + " (test run #" + previousTestRun + ")")
        ReleaseLock()
        return previousTestRun
    endIf

    Info("Run Test Suite: " + testSuiteName + " (test run #" + parentTestRun + ")")

    int parentTestSuitesMap = JMap.getObj(parentTestRun, "testSuites")
    int testSuiteResult = JMap.object()
    JMap.setObj(parentTestSuitesMap, testSuiteName, testSuiteResult)

    Info("Run Test Suite: " + testSuiteName + " (test run #" + parentTestRun + " > test suite run #" + testSuiteResult + ")")
    SkyUnitData_SetCurrentlyRunningTestSuite(testSuiteResult)
    SkyUnitData_SetLatestSuiteResult(testSuiteResult)
    JMap.setStr(testSuiteResult, "testSuite", testSuiteName)
    JMap.setStr(testSuiteResult, "status", "PENDING")
    float startTime = Utility.GetCurrentRealTime()
    JMap.setFlt(testSuiteResult, "startTime", startTime)
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

    float endTime = Utility.GetCurrentRealTime()
    JMap.setFlt(testSuiteResult, "endTime", endTime)
    JMap.setFlt(testSuiteResult, "duration", endTime - startTime)

    SkyUnitData_SetCurrentExpectation(0)
    SkyUnitData_SetCurrentTestResult(0)
    SkyUnitData_SetCurrentlyRunningTestSuite(0)

    ; Cache result (caches the full testRun for this for consistency)
    SkyUnitData_AddTestSuiteResultToMostRecentlyRunResults(testSuiteName, parentTestRun) ; Is this even needed anymore?

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
        ; TODO FIX THIS, IN MY TESTS IT RUNS AfterEach BEFORE TESTS, but I haven't reproduced it in reality *yet*
        ; The previous one didn't finish, e.g. it was pending. We need to make sure to run AfterEach()
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
    JMap.setFlt(testResult, "startTime", Utility.GetCurrentRealTime())
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

    float endTime = Utility.GetCurrentRealTime()
    float startTime = JMap.getFlt(testResult, "startTime")
    JMap.setFlt(testResult, "endTime", endTime)
    JMap.setFlt(testResult, "duration", endTime - startTime)

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
;; SkyUnit User Interface - SkyUnitUI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Display the UI (if there are any tests available to run)
function ShowUI() global
    string[] testSuiteNames = TestSuites()
    if testSuiteNames.Length > 0
        UI_Show_MainMenu()
    else
        Debug.MessageBox("No tests found")
    endIf
endFunction

; Main Menu for SkyUnit
;
; Shows all test suite names so you can quickly run a specific suite and see its results!
function UI_Show_MainMenu() global
    Info("[UI] Main Menu")

    string[] testSuiteNames = TestSuites()

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
        int testSuiteResult = SkyUnitData_GetMostRecentResultForTestSuiteByName(testSuiteName)
        string status = JMap.getStr(testSuiteResult, "status")
        if status == "FAILING"
            listMenu.AddEntryItem("[FAIL] " + testSuiteName)
        else
            listMenu.AddEntryItem(testSuiteName)
        endIf
        suiteIndex += 1
    endWhile

    ; XXX.RegisterForKey(30) ; A - Run [A]ll ; <--- Use a Quest script to support keyboard shortcuts, e.g. F for filter, A for all, V for view
    listMenu.OpenMenu()
    ; XXX.UnregisterForKey(30) ; A

    int selection = listMenu.GetResultInt()
    if selection > -1
        if selection == option_RunAllTestSuites_index
            Debug.Notification("Running all tests...")
            float startTime = Utility.GetCurrentRealTime()
            int testRun = RunAllTestSuites(forceRerun = true)
            float endTime = Utility.GetCurrentRealTime()
            UI_Show_AllTestSuiteResults(testRun, endTime - startTime)
        elseIf selection == option_ViewTestSuites_index
            UI_Show_ViewAllTestSuites()
        elseIf selection == option_FilterTestSuites_index
            UI_Show_ViewAllTestSuites(GetTextEntryResult())
        else
            string testSuiteName = testSuiteNames[selection - textOptionCount]
            UI_Show_TestSuiteResult(RunTestSuite(testSuiteName), testSuiteName)
        endIf
    endIf
endFunction

; Display Results of Running All Test Results
function UI_Show_AllTestSuiteResults(int testRun, float duration) global
    Info("[UI] Run All Test Suites (test run #" + testRun + ")")

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
function UI_Show_AllTestSuiteResults_Message(int testRun, string text) global
    Info("[UI] All Test Results Message (test run #" + testRun + ")")
    SkyUnitPrivateAPI api = SkyUnitPrivateAPI.GetInstance()
    api.SkyUnitMessageTextFormBase.SetName(text)

    int mainMenu = 0
    int viewAllTestSuites = 1
    int filterAllTestSuites = 2
    int runAgain = 3
    int saveResultsToFile = 4
    int result = api.SkyUnitAllTestSuitesMessage.Show()
    if result == mainMenu
        UI_Show_MainMenu()
    elseIf result == viewAllTestSuites
        UI_Show_ViewAllTestSuites()
    elseIf result == filterAllTestSuites
        UI_Show_ViewAllTestSuites(GetTextEntryResult())
    elseIf result == runAgain
        float startTime = Utility.GetCurrentRealTime()
        testRun = RunAllTestSuites(forceRerun = true)
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
function UI_Show_ViewAllTestSuites(string filter = "") global
    Info("[UI] View Test Suite")

    UIListMenu listMenu = uiextensions.GetMenu("UIListMenu") as UIListMenu

    int textOptionCount = 1 ; Including an empty space and "Choose Test Suite"
    listMenu.AddEntryItem("--- [Choose Test Suite] ---")

    int matchingTestSuiteNames = JArray.object()
    string[] testSuiteNames = SkyUnitPrivateAPI.TestSuites()
    bool anyMatching = (filter == "")
    int suiteIndex = 0
    while suiteIndex < testSuiteNames.Length
        string testSuiteName = testSuiteNames[suiteIndex]
        if ! filter || StringUtil.Find(testSuiteName, filter) > -1
            int testSuiteResult = SkyUnitData_GetMostRecentResultForTestSuiteByName(testSuiteName)
            string status = JMap.getStr(testSuiteResult, "status")
            if status == "FAILING"
                listMenu.AddEntryItem("[FAIL] " + testSuiteName)
            else
                listMenu.AddEntryItem(testSuiteName)
            endIf
            JArray.addStr(matchingTestSuiteNames, testSuiteName)
            anyMatching = true
        endIf
        suiteIndex += 1
    endWhile

    if ! anyMatching
        Debug.MessageBox("No Test Suites found matching filter: " + filter)
        UI_Show_MainMenu()
        return
    endIf

    listMenu.OpenMenu()

    int selection = listMenu.GetResultInt()
    if selection > 0 ; 0 is the "Choose Test Suite" line
        string testSuiteName = JArray.getStr(matchingTestSuiteNames, selection - 1)
        UI_Show_TestSuiteResult(RunTestSuite(testSuiteName), testSuiteName)
    endIf
endFunction

function UI_Show_TestSuiteResult(int testRun, string testSuiteName) global
    Info("[UI] View Test Suite: " + testSuiteName)

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

function UI_Show_TestSuiteResult_Message(string testSuiteName, int testRun, string text) global
    SkyUnitPrivateAPI api = SkyUnitPrivateAPI.GetInstance()
    api.SkyUnitMessageTextFormBase.SetName(text)

    int mainMenu = 0
    int viewTests = 1
    int filterTests = 2
    int runAgain = 3
    int saveResultsToFile = 4
    int result = api.SkyUnitTestSuiteMessage.Show()
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

int function UI_Show_ViewAllTests(string testSuiteName, int testRun) global ; TODO add Filter
    Info("[UI] View All Tests in Test Suite: " + testSuiteName)

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
        UI_Show_TestResult(RunTestSuite(testSuiteName, testRun), testSuiteName, testName)
    endIf
endFunction

function UI_Show_TestResult(int testRun, string testSuiteName, string testName) global
    Info("[UI] View Test: " + testSuiteName + " > " + testName)

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
            expectationFailureText += "[" + expectationStatus + "] #" + (i + 1) + " " + expectationDescription + "\n"
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

function UI_Show_TestResult_Message(string testSuiteName, string testName, int testRun, int test, string text) global
    SkyUnitPrivateAPI api = SkyUnitPrivateAPI.GetInstance()
    api.SkyUnitMessageTextFormBase.SetName(text)

    int mainMenu = 0
    int viewTestSuite = 1
    int viewExpectations = 2
    int filterExpectations = 3
    int runAgain = 4
    int saveResultsToFile = 5
    int result = api.SkyUnitTestMessage.Show()
    if result == mainMenu
        UI_Show_MainMenu()
    elseIf result == viewTestSuite
        UI_Show_TestSuiteResult(testRun, testSuiteName)
    elseIf result == viewExpectations
        UI_Show_TestExpectations(testRun, testSuiteName, testName)
    elseIf result == filterExpectations
        UI_Show_TestExpectations(testRun, testSuiteName, testName, filter = GetTextEntryResult())
    elseIf result == runAgain
        RunTestSuite(testSuiteName, testRun, forceRerun = true)        
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

function UI_Show_TestExpectations(int testRun, string testSuiteName, string testName, string filter = "") global
    Info("[UI] Show Test Expectations " + testSuiteName + " > " + testName)
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

function UI_Show_Expectation(int expectation) global
    string text = SkyUnitExpectation.GetDescription(expectation) + "\n" + JMap.getStr(expectation, "status") + "\n\n"

    Debug.MessageBox(text) ; TODO

    ; SkyUnitPrivateAPI api = SkyUnitPrivateAPI.GetInstance()
    ; api.SkyUnitMessageTextFormBase.SetName("...")
endFunction

string function GetTextEntryResult(string defaultText = "") global
    UITextEntryMenu menu = UIExtensions.GetMenu("UITextEntryMenu") as UITextEntryMenu
    menu.SetPropertyString("text", defaultText)
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

string function UI_GetLinesShowingNamesForEachStatus(int map, int maxLines = 9) global
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

function SaveToFile(int object, string fileName) global
    if fileName
        MiscUtil.WriteToFile(fileName, "", append = false) ; empty the file in case we're writing an empty object
        JValue.writeToFile(object, fileName)
    endIf
endFunction
