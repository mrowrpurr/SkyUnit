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
    Debug.Trace("[SkyUnit] [Debug] " + text)
endFunction

; Log() goes to the Papyrus log and the ~ console (if ~ console support available)
function Log(string text)
    Debug.Trace("[SkyUnit] " + text)
    SkyUnitConsole.Print("[SkyUnit] " + text)
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

        ; Every suite has a top-level "tests" key
        ; which stores a map of [Test Script Name] => [...]
        JMap.setObj(suite, "tests", JMap.object())
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

int _skyUnitTestScript_AvailableSlots_TemplateArray

; For support of multiple test suites or large test suites,
; we support 1,280 scripts being loaded at one time
SkyUnitTest[] _skyUnitTestScripts0
SkyUnitTest[] _skyUnitTestScripts1
SkyUnitTest[] _skyUnitTestScripts2
SkyUnitTest[] _skyUnitTestScripts3
SkyUnitTest[] _skyUnitTestScripts4
SkyUnitTest[] _skyUnitTestScripts5
SkyUnitTest[] _skyUnitTestScripts6
SkyUnitTest[] _skyUnitTestScripts7
SkyUnitTest[] _skyUnitTestScripts8
SkyUnitTest[] _skyUnitTestScripts9

function SkyUnitTestScriptArraySetup()
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
    _skyUnitTestScripts0 = new SkyUnitTest[128]
    _skyUnitTestScripts1 = new SkyUnitTest[128]
    _skyUnitTestScripts2 = new SkyUnitTest[128]
    _skyUnitTestScripts3 = new SkyUnitTest[128]
    _skyUnitTestScripts4 = new SkyUnitTest[128]
    _skyUnitTestScripts5 = new SkyUnitTest[128]
    _skyUnitTestScripts6 = new SkyUnitTest[128]
    _skyUnitTestScripts7 = new SkyUnitTest[128]
    _skyUnitTestScripts8 = new SkyUnitTest[128]
    _skyUnitTestScripts9 = new SkyUnitTest[128]
endFunction

; You can pass this function a script object (even though it takes a string parameter)
string function GetScriptName(string script)
    return StringUtil.Substring(script, 1, StringUtil.Find(script, " ") - 1)
endFunction