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
        SetupDefaultTestSuite()
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

int property TestSuitesMap
    int function get()
        return JMap.getObj(GlobalDataMap, "testSuites")
    endFunction
endProperty

int function SetupDefaultTestSuite()
    return CreateTestSuite(DEFAULT_TEST_SUITE_NAME)
endFunction

int function CreateTestSuite(string name)
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

int function GetTestSuiteScriptsMap(int suite)
    return JMap.getObj(suite, "testScripts")
endFunction

int function GetTestSuiteTestScriptMap(int suite, SkyUnit2Test script)
    JMap.getObj(GetTestSuiteScriptsMap(suite), GetScriptDisplayName(script))
endFunction

; This does NOT check to see if the test script already exists on this Test Suite (in the test suite's .testScripts map)
int function CreateTestSuiteTestScriptMap(int suite, SkyUnit2Test script, int scriptLookupArraySlotNumber)
    int scriptMap = JMap.object()
    JMap.setObj(GetTestSuiteScriptsMap(suite), GetScriptDisplayName(script), scriptMap)
    JMap.setStr(scriptMap, "name", GetScriptDisplayName(script))
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
    ; 2. Tracking SkyUnit2Test Scripts (used by Test Suites)
    GlobalDataMap = JMap.object()
    JValue.retain(GlobalDataMap)

    ; Map of Test Suite objects keyed on name
    JMap.setObj(GlobalDataMap, "testSuites", JMap.object())

    ; Map of SkyUnit2Test scripts keyed on "display name" (e.g. FooTest rather than [FooText <Something>(123)])
    ; The value of each is an integer which maps to the # "slot" the script is stored in in the arrays
    JMap.setObj(GlobalDataMap, "testScripts", JMap.object())

    ; Setup the arrays which store references to all SkyUnit2Test scripts
    SkyUnit2TestScriptArraySetup()

    ; Add availableScriptIndexes which tracks all of the available "slot #'s" in
    ; the arrays of SkyUnit2Test which are available for usage.
    ; We are currently limited to 1,280 scripts (but this can be very easily expanded if necessary)
    int availableScriptIndexes = JArray.object()
    JMap.setObj(GlobalDataMap, "availableScriptIndexes", availableScriptIndexes)
    JArray.addFromArray(availableScriptIndexes, _skyUnitTestScript_AvailableSlots_TemplateArray) ; Adds the 1,280 elements (very quickly)

    _dataResetInProgress = false
    _dataSetupComplete = true ; Ok, done! API requests may come thru again!
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SkyUnit2Test script instance tracking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

int property TestScriptLookupMap
    int function get()
        return JMap.getObj(GlobalDataMap, "testScripts")
    endFunction
endProperty

int _skyUnitTestScript_AvailableSlots_TemplateArray

; For support of multiple test suites or large test suites,
; we support 1,280 scripts being loaded at one time
; but this number can very easily be increased if necessary
SkyUnit2Test[] _skyUnitTestScripts0
SkyUnit2Test[] _skyUnitTestScripts1
SkyUnit2Test[] _skyUnitTestScripts2
SkyUnit2Test[] _skyUnitTestScripts3
SkyUnit2Test[] _skyUnitTestScripts4
SkyUnit2Test[] _skyUnitTestScripts5
SkyUnit2Test[] _skyUnitTestScripts6
SkyUnit2Test[] _skyUnitTestScripts7
SkyUnit2Test[] _skyUnitTestScripts8
SkyUnit2Test[] _skyUnitTestScripts9

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
function AddScriptToTestSuite(SkyUnit2Test script, int testSuite, float lock = 0.0)
    ; First check to see if it's already in a slot
    int existingIndex = JMap.getInt(TestScriptLookupMap, GetScriptDisplayName(script))
    if existingIndex
        ; Just add it to this suite
        CreateTestSuiteTestScriptMap(testSuite, script, existingIndex)
        return
    endIf

    ; It's not already in a slot, so wait in line to add it to a slot ...
    if lock == 0.0
        lock = Utility.RandomFloat(0.0, 1000.0)
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

function SkyUnit2TestScriptArraySetup()
    ; Create template array to use for script slot tracking
    if _skyUnitTestScript_AvailableSlots_TemplateArray == 0
        _skyUnitTestScript_AvailableSlots_TemplateArray = JArray.object()
        JValue.retain(_skyUnitTestScript_AvailableSlots_TemplateArray)
        int i = 0
        while i < 1280
            JArray.addInt(_skyUnitTestScript_AvailableSlots_TemplateArray, i)
            i += 1
        endWhile
    endIf

    ; Initialize the arrays
    _skyUnitTestScripts0 = new SkyUnit2Test[128]
    _skyUnitTestScripts1 = new SkyUnit2Test[128]
    _skyUnitTestScripts2 = new SkyUnit2Test[128]
    _skyUnitTestScripts3 = new SkyUnit2Test[128]
    _skyUnitTestScripts4 = new SkyUnit2Test[128]
    _skyUnitTestScripts5 = new SkyUnit2Test[128]
    _skyUnitTestScripts6 = new SkyUnit2Test[128]
    _skyUnitTestScripts7 = new SkyUnit2Test[128]
    _skyUnitTestScripts8 = new SkyUnit2Test[128]
    _skyUnitTestScripts9 = new SkyUnit2Test[128]
endFunction

function AddScriptToSlot(SkyUnit2Test script, int slotNumber)
    if slotNumber == 0
        return
    endIf
    int arrayNumber = slotNumber / 128
    int arrayIndex = slotNumber % 128
    if arrayNumber == 0
        _skyUnitTestScripts0[arrayIndex] = script
    elseIf arrayNumber == 1
        _skyUnitTestScripts1[arrayIndex] = script
    elseIf arrayNumber == 2
        _skyUnitTestScripts2[arrayIndex] = script
    elseIf arrayNumber == 3
        _skyUnitTestScripts3[arrayIndex] = script
    elseIf arrayNumber == 4
        _skyUnitTestScripts4[arrayIndex] = script
    elseIf arrayNumber == 5
        _skyUnitTestScripts5[arrayIndex] = script
    elseIf arrayNumber == 6
        _skyUnitTestScripts6[arrayIndex] = script
    elseIf arrayNumber == 7
        _skyUnitTestScripts7[arrayIndex] = script
    elseIf arrayNumber == 8
        _skyUnitTestScripts8[arrayIndex] = script
    elseIf arrayNumber == 9
        _skyUnitTestScripts9[arrayIndex] = script
    endIf
endFunction

SkyUnit2Test function GetScriptFromSlot(int slotNumber)
    if slotNumber == 0
        return None
    endIf
    int arrayNumber = slotNumber / 128
    int arrayIndex = slotNumber % 128
    if arrayNumber == 0
        return _skyUnitTestScripts0[arrayIndex]
    elseIf arrayNumber == 1
        return _skyUnitTestScripts1[arrayIndex]
    elseIf arrayNumber == 2
        return _skyUnitTestScripts2[arrayIndex]
    elseIf arrayNumber == 3
        return _skyUnitTestScripts3[arrayIndex]
    elseIf arrayNumber == 4
        return _skyUnitTestScripts4[arrayIndex]
    elseIf arrayNumber == 5
        return _skyUnitTestScripts5[arrayIndex]
    elseIf arrayNumber == 6
        return _skyUnitTestScripts6[arrayIndex]
    elseIf arrayNumber == 7
        return _skyUnitTestScripts7[arrayIndex]
    elseIf arrayNumber == 8
        return _skyUnitTestScripts8[arrayIndex]
    elseIf arrayNumber == 9
        return _skyUnitTestScripts9[arrayIndex]
    endIf
endFunction

; You can pass this function a script object (even though it takes a string parameter)
string function GetScriptDisplayName(string script)
    return StringUtil.Substring(script, 1, StringUtil.Find(script, " ") - 1)
endFunction
