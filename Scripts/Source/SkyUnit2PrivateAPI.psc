scriptName SkyUnit2PrivateAPI extends Quest hidden
{Private API for SkyUnit.

DO NOT USE.

This includes all of the things which make SkyUnit work!

Data storage and persistence is managed via the SkyUnitPrivateAPI.

If you need to integrate with SkyUnit, please use the SkyUnit script
which provides a stable, documented API for working with SkyUnit.

The internals of SkyUnitPrivateAPI *may change at any time*.
}

SkyUnit2PrivateAPI function GetPrivateAPI() global
    SkyUnit2PrivateAPI api = Game.GetFormFromFile(0x800, "SkyUnit2.esp") as SkyUnit2PrivateAPI
    return api.EnsureSetupAndReadyForApiRequests()
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Install / Load Events / Versioning
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

float property CurrentlyInstalledVersion auto

; Only Runs on First Mod Installation
event OnInit()
    CurrentlyInstalledVersion = SkyUnit2.GetVersion()
    EnsureSetupAndReadyForApiRequests()
endEvent

; Runs On Every Load Game Event
; (the VersionManager script delegates to us)
event OnPlayerLoadGame()
    ; Nothing right now :)
endEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Logging
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Debug() only goes to the Papyrus log
function Debug(string text)
    Debug.Trace("[SkyUnit2] [Debug] " + text)
endFunction

; Log() goes to the Papyrus log and the ~ console (if ~ console support available)
function Log(string text)
    Debug.Trace("[SkyUnit2] " + text)
    SkyUnitConsole.Print("[SkyUnit2] " + text)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initial Mod Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Returns the private API instance *once it's ready* to handle API requests
;
; SkyUnit2PrivateAPI.GetPrivateAPI() calls this to ensure that every
; instance of the Private API which consumers use is *ready* for use
;
; Right now this simply blocks on global data storage setup status
SkyUnit2PrivateAPI function EnsureSetupAndReadyForApiRequests()
    if ! _dataSetupComplete
        SetupGlobalDataStorage()
    endIf
    while ! _dataSetupComplete
        Utility.WaitMenuMode(0.05)
    endWhile
    return self
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Suite Management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

string property DEFAULT_TEST_SUITE_NAME = "[SkyUnit Default Test Suite]" autoReadonly

; This should be the root data source used for ALL full properties in this script
; so that EVERYTHING is scoped to a Test Suite (allowing us to switch between them, especially to test SkyUnit with SkyUnit)
int property CurrentTestSuiteID auto
string property CurrentTestSuiteName auto

string function GetCurrentTestSuiteName()
    return CurrentTestSuiteName
endFunction

function SwitchToTestSuiteByID(int suite)
    ; Store the lock ID for the current suite so we can switch back to the same lock ID when we're done...
    ; We use the CURRENTLY RUNNING suite ID (not the NEW suite which we're switching to)
    JMap.setFlt(TestSuiteLockMap, CurrentTestSuiteID, _currentlyRunningTestLock)

    ; Go get the previous test suite's lock of the suite we're switching to, if any!
    float lock = JMap.getFlt(TestSuiteLockMap, suite)

    ; Switch the suite ID
    CurrentTestSuiteID = suite

    ; If a lock was provided, update the lock to use it, else set it to 0.0 to allow tests to run
    _currentlyRunningTestLock = lock
endFunction

function SwitchToTestSuiteByName(string suite)
    CurrentTestSuiteName = suite
    SwitchToTestSuiteByID(GetTestSuite(suite))
endFunction

int property TestSuitesMap
    int function get()
        return JMap.getObj(GlobalDataMap, "testSuites")
    endFunction
endProperty

int function SetupDefaultTestSuite()
    return CreateTestSuite(DEFAULT_TEST_SUITE_NAME, switchTo = true)
endFunction

int function CreateTestSuite(string name, bool switchTo = false)
    int testSuites = TestSuitesMap
    int suite = JMap.getObj(testSuites, name)
    if suite
        Log("Test Suite Already Exists: " + name)
    else
        ; Setup new object representing a "Test Suite".
        ; This basically represents a full instance of SkyUnit.
        suite = JMap.object()
        JMap.setObj(testSuites, name, suite)

        ; Set "name" on the test suite
        JMap.setStr(suite, "name", name)

        ; Every suite has a top-level "testScripts" key
        ; which stores a map of [Test Script Name] => [...]
        JMap.setObj(suite, "testScripts", JMap.object())

        ; Map of a variety of variables to store the "current state"
        ; about the test suite, e.g. storing which test is currently
        ; running and which expectation is running etc.
        ; These are stored in a map on the TestSuite so that you
        ; can switch TestSuites without breaking the current state.
        JMap.setObj(suite, "state", JMap.object())
    endIf
    if switchTo
        CurrentTestSuiteName = name
        SwitchToTestSuiteByID(suite)
    endIf
    return suite
endFunction

function DeleteTestSuite(string name)
    ; TODO 
    ;
    ; TODO TEST THAT SCRIPTS GET CLEANED UP PROPERLY
    ;
    ; WE NEED TO TRACK AN ARRAY/MAP ON EACH SCRIPT OF ITS *USAGES*
    ; so we can delete a script as soon as it no longer has any references
    ;
    ; ...
    ; 
    ; But for right now, let's just delete the whole object and that's it :P
    JMap.removeKey(TestSuitesMap, name)
endFunction

function DeleteAllTestSuitesExceptDefault()
    string[] testSuiteNames = JMap.allKeysPArray(TestSuitesMap)
    int i = 0
    while i < testSuiteNames.Length
        string suiteName = testSuiteNames[i]
        if suiteName != DEFAULT_TEST_SUITE_NAME
            DeleteTestSuite(suiteName)
        endIf
        i += 1
    endWhile
endFunction

int function GetTestSuite(string name)
    return JMap.getObj(TestSuitesMap, name)
endFunction

int function GetTestSuiteStateMap(int suite)
    return JMap.getObj(suite, "state")
endFunction

int property CurrentState
    int function get()
        return GetTestSuiteStateMap(CurrentTestSuiteID)
    endFunction
endProperty

int function GetTestSuiteScriptsMap(int suite)
    return JMap.getObj(suite, "testScripts")
endFunction

int function GetTestSuiteTestScriptMap(int suite, SkyUnitTest script)
    JMap.getObj(GetTestSuiteScriptsMap(suite), GetScriptDisplayName(script))
endFunction

; This does NOT check to see if the test script already exists on this Test Suite (in the test suite's .testScripts map)
int function CreateTestSuiteTestScriptMap(int suite, SkyUnitTest script, int scriptLookupArraySlotNumber)
    int scriptMap = JMap.object()
    JMap.setObj(GetTestSuiteScriptsMap(suite), GetScriptDisplayName(script), scriptMap)
    JMap.setStr(scriptMap, "name", GetScriptDisplayName(script))
    JMap.setObj(scriptMap, "testRuns", JMap.object())
    JMap.setInt(scriptMap, "arrayLookupSlotNumber", scriptLookupArraySlotNumber)
    return scriptMap
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global Data Storage Setup
;;
;; This Data Storage is NOT specified to
;; specific Test Suites (it's global)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This is the JMap which stores ALL GLOBAL DATA including references
; to all test suites. If this is reset, all test suite data is reset as well.
;
; It's a property so that the global SkyUnit functions may access it
; directly to perform direct JContainers operations.
;
; It still has to be accessed via GetPrivateAPI so it's always safe to use directly!
int property GlobalDataMap auto

; Boolean used for blocking API requests during initial data setup (or while performing a reset)
bool _dataSetupComplete = false

; Whether or not a reset is currently being performed (also used on initial installation)
bool _dataResetInProgress = false

; Map of float test locks for each test suite
int property TestSuiteLockMap auto

; Setup the data. If already setup, this returns immediately. Use ResetGlobalDataStorage() to reset.
; If setup is not complete, this will begin the setup.
; Note: do not rely on this function to block your requests. ALWAYS use GetPrivateAPI() for that.
function SetupGlobalDataStorage()
    if GlobalDataMap != 0 && _dataSetupComplete
        return ; All good! Things are setup :)
    endIf

    ; Not good, is this currently being reset? If not, let's kick that process off.
    if ! _dataSetupComplete && ! _dataResetInProgress
        ResetGlobalDataStorage()
    endIf
endFunction

; USE WITH CAUTION - THIS WILL RESET THE ENTIRE DATA STORAGE FOR ALL OF SKYUNIT.
;
; If reset, ALL TEST SUITE DATA will *also* be reset along with this.
function ResetGlobalDataStorage()
    _dataResetInProgress = true
    _dataSetupComplete = false ; Turn off the API while we reset (and make all requests block until we're ready)

    if GlobalDataMap != 0
        JValue.release(GlobalDataMap) ; Bye bye global data! It was nice knowing you.
    endIf

    ; Setup the map which tracks all SkyUnit information.
    ; This is currently simply used for:
    ; 1. Tracking Test Suites
    ; 2. Tracking SkyUnitTest Scripts (used by Test Suites)
    GlobalDataMap = JMap.object()
    JValue.retain(GlobalDataMap)

    ; Map of Test Suite objects keyed on name
    JMap.setObj(GlobalDataMap, "testSuites", JMap.object())

    ; Map of SkyUnitTest scripts keyed on "display name" (e.g. FooTest rather than [FooText <Something>(123)])
    ; The value of each is an integer which maps to the # "slot" the script is stored in in the arrays
    JMap.setObj(GlobalDataMap, "testScripts", JMap.object())

    ; Setup the arrays which store references to all SkyUnitTest scripts
    SkyUnitTestScriptArraySetup()

    ; Add availableScriptIndexes which tracks all of the available "slot #'s" in
    ; the arrays of SkyUnitTest which are available for usage.
    ; We are currently limited to 1,280 scripts (but this can be very easily expanded if necessary)
    int availableScriptIndexes = JArray.object()
    JMap.setObj(GlobalDataMap, "availableScriptIndexes", availableScriptIndexes)
    JArray.addFromArray(availableScriptIndexes, _SkyUnitTestScript_AvailableSlots_TemplateArray) ; Adds the 1,280 elements (very quickly)

    ; We also store test locks for different suites to support running suites from other suites
    TestSuiteLockMap = JMap.object()
    JMap.setObj(GlobalDataMap, "testSuiteTestLocks", TestSuiteLockMap)

    ; Before we return and are therefore "ready" for API requests,
    ; make a default test suite and activate it :)
    SetupDefaultTestSuite()

    _dataResetInProgress = false
    _dataSetupComplete = true ; Ok, done! API requests may come thru again!
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SkyUnitTest script instance tracking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

int property TestScriptLookupMap
    int function get()
        return JMap.getObj(GlobalDataMap, "testScripts")
    endFunction
endProperty

int _SkyUnitTestScript_AvailableSlots_TemplateArray

; For support of multiple test suites or large test suites,
; we support 1,280 scripts being loaded at one time
; but this number can very easily be increased if necessary
SkyUnitTest[] _SkyUnitTestScripts0
SkyUnitTest[] _SkyUnitTestScripts1
SkyUnitTest[] _SkyUnitTestScripts2
SkyUnitTest[] _SkyUnitTestScripts3
SkyUnitTest[] _SkyUnitTestScripts4
SkyUnitTest[] _SkyUnitTestScripts5
SkyUnitTest[] _SkyUnitTestScripts6
SkyUnitTest[] _SkyUnitTestScripts7
SkyUnitTest[] _SkyUnitTestScripts8
SkyUnitTest[] _SkyUnitTestScripts9

int property AvailableScriptIndexesArray
    int function get()
        return JMap.getObj(GlobalDataMap, "availableScriptIndexes")
    endFunction
endProperty

; Lock because we need it to claim slot #'s' for scripts
; without other folks trying to claim the same number at the same time
float _currentlyAddingScriptLock

; Registers a script.
; Registration and unregistration require a lock because they alter the array
; which stores available slots (global.availableScriptIndexes) which requires a lock
; (especially when the game loads and a number of tests are all trying to register themselves at the same time)
function AddScriptToTestSuite(SkyUnitTest script, int testSuite, float lock = 0.0)
    ; First check to see if it's already in a slot
    int existingIndex = JMap.getInt(TestScriptLookupMap, GetScriptDisplayName(script))
    if existingIndex
        ; Just add it to this suite
        CreateTestSuiteTestScriptMap(testSuite, script, existingIndex)
        return
    endIf

    ; It's not already in a slot, so wait in line to add it to a slot ...
    if lock == 0.0
        lock = Utility.RandomFloat(1.0, 1000.0)
    endIf

    while _currentlyAddingScriptLock != 0.0
        Utility.WaitMenuMode(0.1)
    endWhile

    _currentlyAddingScriptLock = lock

    if _currentlyAddingScriptLock == lock
        if _currentlyAddingScriptLock == lock
            ; Get available count
            int availableCount = JArray.count(AvailableScriptIndexesArray)
            if availableCount > 0
                int slotNumber = JArray.getInt(AvailableScriptIndexesArray, availableCount - 1)
                if slotNumber == 0
                    slotNumber = JArray.getInt(AvailableScriptIndexesArray, availableCount - 1)
                endIf
                if slotNumber == 0
                    Log("Cannot register test " + GetScriptDisplayName(script) + " (are there 1,280 scripts registered? that is the max)")
                else
                    ; Add to top-level registration map which tracks ALL scripts by name
                    JMap.setInt(TestScriptLookupMap, GetScriptDisplayName(script), slotNumber)
                    ; Add to this specific test suite as a new script
                    CreateTestSuiteTestScriptMap(testSuite, script, slotNumber)
                    ; Remove this index so other scripts won't take it
                    JArray.eraseIndex(AvailableScriptIndexesArray, availableCount - 1)
                    ; Add the script to an array
                    AddScriptToSlot(script, slotNumber)
                    Debug("Added " + script + " to slot # " + slotNumber)
                endIf
            else
                Log("Cannot register test " + GetScriptDisplayName(script) + " (are there 1,280 scripts registered? that is the max)")
            endIf
            _currentlyAddingScriptLock = 0.0
        else
            AddScriptToTestSuite(script, testSuite, lock)
        endIf
    else
        AddScriptToTestSuite(script, testSuite, lock)
    endIf
endFunction

; Simply removes the key. Really only used for testing. Do NOT make available via SkyUnit2 unless it has test coverage.
; Really this needs to handle much more (script registration)
function RemoveScriptFromTestSuite(SkyUnitTest script, int testSuite)
    JMap.removeKey(GetTestSuiteScriptsMap(testSuite), GetScriptDisplayName(script))
endFunction

function SkyUnitTestScriptArraySetup()
    ; Create template array to use for script slot tracking
    if _SkyUnitTestScript_AvailableSlots_TemplateArray == 0
        _SkyUnitTestScript_AvailableSlots_TemplateArray = JArray.object()
        JValue.retain(_SkyUnitTestScript_AvailableSlots_TemplateArray)
        int i = 0
        while i < 1280
            JArray.addInt(_SkyUnitTestScript_AvailableSlots_TemplateArray, i)
            i += 1
        endWhile
    endIf

    ; Initialize the arrays
    _SkyUnitTestScripts0 = new SkyUnitTest[128]
    _SkyUnitTestScripts1 = new SkyUnitTest[128]
    _SkyUnitTestScripts2 = new SkyUnitTest[128]
    _SkyUnitTestScripts3 = new SkyUnitTest[128]
    _SkyUnitTestScripts4 = new SkyUnitTest[128]
    _SkyUnitTestScripts5 = new SkyUnitTest[128]
    _SkyUnitTestScripts6 = new SkyUnitTest[128]
    _SkyUnitTestScripts7 = new SkyUnitTest[128]
    _SkyUnitTestScripts8 = new SkyUnitTest[128]
    _SkyUnitTestScripts9 = new SkyUnitTest[128]
endFunction

function AddScriptToSlot(SkyUnitTest script, int slotNumber)
    if slotNumber == 0
        return
    endIf
    int arrayNumber = slotNumber / 128
    int arrayIndex = slotNumber % 128
    if arrayNumber == 0
        _SkyUnitTestScripts0[arrayIndex] = script
    elseIf arrayNumber == 1
        _SkyUnitTestScripts1[arrayIndex] = script
    elseIf arrayNumber == 2
        _SkyUnitTestScripts2[arrayIndex] = script
    elseIf arrayNumber == 3
        _SkyUnitTestScripts3[arrayIndex] = script
    elseIf arrayNumber == 4
        _SkyUnitTestScripts4[arrayIndex] = script
    elseIf arrayNumber == 5
        _SkyUnitTestScripts5[arrayIndex] = script
    elseIf arrayNumber == 6
        _SkyUnitTestScripts6[arrayIndex] = script
    elseIf arrayNumber == 7
        _SkyUnitTestScripts7[arrayIndex] = script
    elseIf arrayNumber == 8
        _SkyUnitTestScripts8[arrayIndex] = script
    elseIf arrayNumber == 9
        _SkyUnitTestScripts9[arrayIndex] = script
    endIf
endFunction

SkyUnitTest function GetScriptFromSlot(int slotNumber)
    if slotNumber == 0
        return None
    endIf
    int arrayNumber = slotNumber / 128
    int arrayIndex = slotNumber % 128
    if arrayNumber == 0
        return _SkyUnitTestScripts0[arrayIndex]
    elseIf arrayNumber == 1
        return _SkyUnitTestScripts1[arrayIndex]
    elseIf arrayNumber == 2
        return _SkyUnitTestScripts2[arrayIndex]
    elseIf arrayNumber == 3
        return _SkyUnitTestScripts3[arrayIndex]
    elseIf arrayNumber == 4
        return _SkyUnitTestScripts4[arrayIndex]
    elseIf arrayNumber == 5
        return _SkyUnitTestScripts5[arrayIndex]
    elseIf arrayNumber == 6
        return _SkyUnitTestScripts6[arrayIndex]
    elseIf arrayNumber == 7
        return _SkyUnitTestScripts7[arrayIndex]
    elseIf arrayNumber == 8
        return _SkyUnitTestScripts8[arrayIndex]
    elseIf arrayNumber == 9
        return _SkyUnitTestScripts9[arrayIndex]
    endIf
endFunction

int function GetScriptSlotNumber(SkyUnitTest script)
    return JMap.getInt(TestScriptLookupMap, GetScriptDisplayName(script))
endFunction

; You can pass this function a script object (even though it takes a string parameter)
string function GetScriptDisplayName(string script)
    return StringUtil.Substring(script, 1, StringUtil.Find(script, " ") - 1)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Running Tests
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

int function GetTestSuiteScriptRunsMap(int suite, SkyUnitTest script)
    return JMap.getObj(GetTestSuiteScriptsMap(suite), "testRuns")
endFunction

float _currentlyRunningTestLock

int function RunTestScript(int suite, SkyUnitTest script, string filter = "", float lock = 0.0)
    Debug("Run Test Script " + script + " for " + suite + " lock:" + lock)
    if lock == 0.0
        lock = Utility.RandomFloat(1.0, 1000.0)
    endIf

    while _currentlyRunningTestLock != 0.0
        Utility.WaitMenuMode(0.1)
    endWhile

    _currentlyRunningTestLock = lock

    if _currentlyRunningTestLock == lock
        if _currentlyRunningTestLock == lock
            ; Yay, we can run our test! It's JUST US now, all alone. Ready to run our test script :)
            int testResult = RunTestScriptLocked(suite, script, filter)

            ; HACK HACK HACK REMOVE ME
            JValue.retain(testResult)
            ; HACK HACK HACK REMOVE ME

            _currentlyRunningTestLock = 0.0
            return testResult
        else
            RunTestScript(suite, script, filter, lock)
        endIf
    else
        RunTestScript(suite, script, filter, lock)
    endIf
endFunction

SkyUnitTest property CurrentlyRunningTestScript
    SkyUnitTest function get()
        int slotNumber = JMap.getInt(CurrentState, "currentlyRunningTestScriptSlotNumber")
        return GetScriptFromSlot(slotNumber)
    endFunction
    function set(SkyUnitTest script)
        int slotNumber = GetScriptSlotNumber(script)
        JMap.setInt(CurrentState, "currentlyRunningTestScriptSlotNumber", slotNumber)
    endFunction
endProperty

; TODO REMOVE AND REPLACE WITH PROPERTY ABOVE
;
; JUST NEED TO DO THE *Map and *TestsMap first :)
SkyUnitTest property CurrentlyRunningTest
    SkyUnitTest function get()
        return CurrentlyRunningTestScript
    endFunction
endProperty

int property CurrentlyRunningTestScriptRunsMap
    int function get()
        return JMap.getInt(CurrentState, "currentlyRunningTestScriptMap")
    endFunction
    function set(int value)
        JMap.setInt(CurrentState, "currentlyRunningTestScriptMap", value)
    endFunction
endProperty

int property CurrentlyRunningTestScriptTestsMap
    int function get()
        return JMap.getInt(CurrentState, "currentlyRunningTestScriptTestsMap")
    endFunction
    function set(int value)
        JMap.setInt(CurrentState, "currentlyRunningTestScriptTestsMap", value)
    endFunction
endProperty

string property CurrentTestRunFilter
    string function get()
        return JMap.getStr(CurrentState, "CurrentTestFilter")
    endFunction
    function set(string filter)
        JMap.setStr(CurrentState, "CurrentTestFilter", filter)
    endFunction
endProperty

int function BeginTestRun(int suite, SkyUnitTest script, string filter = "")
    Debug("Running " + script + " from " + suite + " (filter: \"" + filter + "\")")

    CurrentlyRunningTestScript = script
    
    int runsMap = GetTestSuiteScriptRunsMap(suite, script)
    CurrentlyRunningTestScriptRunsMap = runsMap
    CurrentTestRunFilter = filter

    ; Create a new test suite result
    float testRunKey = Utility.GetCurrentRealTime()
    int testRun = JMap.object()

    ; HACK FOR NOW
    JValue.retain(testRun)
    ; HACK FOR NOW

    CurrentlyRunningTestScriptMap = testRun
    JMap.setObj(runsMap, testRunKey, testRun)
    JMap.setObj(runsMap, SkyUnit2.SpecialTestRunDuration_LatestTest(), testRun)
    CurrentlyRunningTestScriptTestsMap = JMap.object()
    JMap.setStr(testRun, "name", GetScriptDisplayName(script)) ; Copy the pretty name of the script onto the result (cuz most folks just work with results)
    JMap.setObj(testRun, "tests", CurrentlyRunningTestScriptTestsMap)
    JMap.setStr(testRun, "status", SkyUnit2.TestStatus_PASS()) ; Default to pass, any failure will update this to FAIL

    return testRun
endFunction

int function RunTestScriptLocked(int suite, SkyUnitTest script, string filter = "")
    int testRun = BeginTestRun(suite, script, filter)

    ; Run the test! (And track duration)
    float startTime = Utility.GetCurrentRealTime()
    JMap.setFlt(testRun, "startTime", startTime)

    ; BeforeAll() - Treated just like any other test!
    BeginTest(SkyUnit2.SpecialTestNameFor_BeforeAll())
    script.BeforeAll()
    EndTest()

    ; Tests()
    script.Tests()

    if CurrentlyRunningTestScriptIndividualTestMap
        ; This happens if the last test is a PENDING test with no Fn() to clean things up :)
        EndTest()
    endIf

    ; AfterAll() - Treated just like any other test!
    BeginTest(SkyUnit2.SpecialTestNameFor_AfterAll())
    script.AfterAll()
    EndTest()
    
    CurrentlyRunningTestScript = None
    float endTime = Utility.GetCurrentRealTime()
    JMap.setFlt(testRun, "endTime", endTime)
    JMap.setFlt(testRun, "durationTime", endTime - startTime)

    return testRun
endFunction

int property CurrentlyRunningTestScriptMap
    int function get()
        return JMap.getInt(CurrentState, "currentlyRunningTestScriptMap")
    endFunction
    function set(int value)
        JMap.setInt(CurrentState, "currentlyRunningTestScriptMap", value)
    endFunction
endProperty

int property CurrentlyRunningTestScriptIndividualTestMap
    int function get()
        return JMap.getInt(CurrentState, "currentlyRunningTestScriptIndividualTestMap")
    endFunction
    function set(int value)
        JMap.setInt(CurrentState, "currentlyRunningTestScriptIndividualTestMap", value)
    endFunction
endProperty

float property CurrentlyRunningTestScriptIndividualTestStartTime
    float function get()
        return JMap.getFlt(CurrentState, "currentlyRunningTestScriptIndividualTestStartTime")
    endFunction
    function set(float value)
        JMap.setFlt(CurrentState, "currentlyRunningTestScriptIndividualTestStartTime", value)
    endFunction
endProperty

int property CurrentlyRunningTestScriptIndividualTestExpectationsArray
    int function get()
        return JMap.getInt(CurrentState, "currentlyRunningTestScriptIndividualTestExpectationsArray")
    endFunction
    function set(int value)
        JMap.setInt(CurrentState, "currentlyRunningTestScriptIndividualTestExpectationsArray", value)
    endFunction
endProperty

; This is for SkyUnitTest.Test(<test name>)
; The current script is 
function BeginTest(string testName)
    Debug("Begin Test " + testName + " in suite " + CurrentTestSuiteName)

    ; Check if the previous test is "Still Open", i.e. it's PENDING with no Fn()
    if CurrentlyRunningTestScriptIndividualTestMap
        Debug("Previous test not closed, calling EndTest() now")
        EndTest()
    endIf

    ; CurrentlyRunningTestScriptTestsMap
    ; ^---- this maps Test Name ==> Test Object (for the currently running test script)
    Debug("Setting up and saving a new Map for this test")
    int testMap = JMap.object()
    JMap.setObj(CurrentlyRunningTestScriptTestsMap, testName, testMap)
    JMap.setStr(testMap, "name", testName)
    Debug("Defaulting test to PENDING")
    JMap.setStr(testMap, "status", SkyUnit2.TestStatus_PENDING()) ; Default to PENDING (no Fn() hooked up)

    ; Setup expectations array :)
    int expectations = JArray.object()
    JMap.setObj(testMap, "expectations", expectations)

    ; Quick lookups for Fn() and Expectation Data (etc) !
    CurrentlyRunningTestScriptIndividualTestMap = testMap
    CurrentlyRunningTestScriptIndividualTestExpectationsArray = expectations

    CurrentlyRunningTestScriptIndividualTestStartTime = Utility.GetCurrentRealTime()
    JMap.setFlt(testMap, "startTime", CurrentlyRunningTestScriptIndividualTestStartTime)
    ; Now it'll run! If Fn() is provided.
endFunction

; This is called by Fn()
; Or at the end of all of the tests if no Fn() was called
; This should cleanup CurrentlyRunningTestScriptIndividualTestMap
; which is how we know whether or not Fn() was called
function EndTest(bool fnCalled = false)
    Debug("End Test")

    CurrentlyRunningTestScript.AfterEach()
    float endTime = Utility.GetCurrentRealTime()
    JMap.setFlt(CurrentlyRunningTestScriptIndividualTestMap, "endTime", endTime)
    JMap.setFlt(CurrentlyRunningTestScriptIndividualTestMap, "durationTime", endTime - CurrentlyRunningTestScriptIndividualTestStartTime)

    ; If it was ended by calling Fn() then mark the function as PASSED if it was previously PENDING
    ; i.e. if there were no assertions. We could keep no assertions at PENDING but... if you do Fn() we'll make it NOT PENDING
    if fnCalled
        Debug("This was called via Fn()")
        ; If nothing failed in the BeforeEach / Test / AfterEach then status will still be PENDING. Update it to PASSED.
        ; But only if Fn() was provided.
        if JMap.getStr(CurrentlyRunningTestScriptIndividualTestMap, "status") == SkyUnit2.TestStatus_PENDING()
            JMap.setStr(CurrentlyRunningTestScriptIndividualTestMap, "status", SkyUnit2.TestStatus_PASS())
        endIf
    endIf

    ; Test is done :) Reset
    CurrentlyRunningTestScriptIndividualTestMap = 0
    CurrentlyRunningTestScriptIndividualTestStartTime = 0.0
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expectations & Expectation Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

int property CurrentlyRunningExpectation
    int function get()
        return JMap.getInt(CurrentState, "CurrentlyRunningExpectation")
    endFunction
    function set(int value)
        JMap.setInt(CurrentState, "CurrentlyRunningExpectation", value)
    endFunction
endProperty

int property CurrentlyRunningExpectationDataMap
    int function get()
        return JMap.getInt(CurrentState, "CurrentlyRunningExpectationDataMap")
    endFunction
    function set(int value)
        JMap.setInt(CurrentState, "CurrentlyRunningExpectationDataMap", value)
    endFunction
endProperty

int property CurrentlyRunningExpectationMainDataMap
    int function get()
        return JMap.getInt(CurrentState, "CurrentlyRunningExpectationMainDataMap")
    endFunction
    function set(int value)
        JMap.setInt(CurrentState, "CurrentlyRunningExpectationMainDataMap", value)
    endFunction
endProperty

int property CurrentlyRunningExpectationCustomDataMap
    int function get()
        return JMap.getInt(CurrentState, "CurrentlyRunningExpectationCustomDataMap")
    endFunction
    function set(int value)
        JMap.setInt(CurrentState, "CurrentlyRunningExpectationCustomDataMap", value)
    endFunction
endProperty

int property CurrentlyRunningExpectationAssertionDataMap
    int function get()
        return JMap.getInt(CurrentState, "CurrentlyRunningExpectationAssertionDataMap")
    endFunction
    function set(int value)
        JMap.setInt(CurrentState, "CurrentlyRunningExpectationAssertionDataMap", value)
    endFunction
endProperty

function SetNotExpectation()
    if JMap.getInt(CurrentlyRunningExpectation, "not")
        JMap.setInt(CurrentlyRunningExpectation, "not", 0)
    else
        JMap.setInt(CurrentlyRunningExpectation, "not", 1)
    endIf
endFunction

bool function GetNotExpectation()
    return JMap.getInt(CurrentlyRunningExpectation, "not")
endFunction

function SetCustomFailureMessage(string failureMessage)
    JMap.setStr(CurrentlyRunningExpectation, "customFailureMessage", failureMessage)
endFunction

function BeginExpectation(string expectationName)
    CurrentlyRunningExpectation = JMap.object()
    JArray.addObj(CurrentlyRunningTestScriptIndividualTestExpectationsArray, CurrentlyRunningExpectation)
    JMap.setStr(CurrentlyRunningExpectation, "expectationName", expectationName)
    CurrentlyRunningExpectationDataMap = JMap.object()
    ; Setup data maps for storing expectation and assertion data
    JMap.setObj(CurrentlyRunningExpectation, "data", CurrentlyRunningExpectationDataMap)
    CurrentlyRunningExpectationMainDataMap = JMap.object()
    JMap.setObj(CurrentlyRunningExpectationDataMap, "main", CurrentlyRunningExpectationMainDataMap)
    CurrentlyRunningExpectationCustomDataMap = JMap.object()
    JMap.setObj(CurrentlyRunningExpectationDataMap, "custom", CurrentlyRunningExpectationCustomDataMap)
    CurrentlyRunningExpectationAssertionDataMap = JMap.object()
    JMap.setObj(CurrentlyRunningExpectationDataMap, "assertion", CurrentlyRunningExpectationAssertionDataMap)
endFunction

function PassExpectation(string assertionName)
    JMap.setStr(CurrentlyRunningExpectation, "assertionName", assertionName)
    JMap.setInt(CurrentlyRunningExpectation, "failed", 0)
endFunction

function FailExpectation(string assertionName, string failureMessage)
    JMap.setStr(CurrentlyRunningExpectation, "assertionName", assertionName)
    JMap.setStr(CurrentlyRunningTestScriptIndividualTestMap, "status", SkyUnit2.TestStatus_FAIL())
    JMap.setInt(CurrentlyRunningExpectation, "failed", 1)
    JMap.setStr(CurrentlyRunningExpectation, "failureMessage", failureMessage)

    ; Mark the whole test as failing because there was at least 1 failed expectation
    JMap.setInt(CurrentlyRunningTestScriptIndividualTestMap, "failed", 1)
    JMap.setStr(CurrentlyRunningTestScriptIndividualTestMap, "status", SkyUnit2.TestStatus_FAIL())

    ; Also, fail the whole script!
    JMap.setInt(CurrentlyRunningTestScriptMap, "failed", 1)
    JMap.setStr(CurrentlyRunningTestScriptMap, "status", SkyUnit2.TestStatus_FAIL())
endFunction

bool property IsCurrentlyRunningExpectationFailed
    bool function get()
        return JMap.getInt(CurrentlyRunningExpectation, "failed") == 1
    endFunction
endProperty

string property CurrentlyRunningExpectationFailureMessage
    string function get()
        return JMap.getStr(CurrentlyRunningExpectation, "failureMessage")
    endFunction
endProperty
