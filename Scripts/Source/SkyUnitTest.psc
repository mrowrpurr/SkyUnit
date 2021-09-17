scriptName SkyUnitTest extends Quest hidden
{Extend this script to create SkyUnit tests.}

; ~ Do not override ~
;
; Initializes this SkyUnit test.
;
; If you must override this, please be sure to call parent.OnInit()
event OnInit()
    SkyUnitPrivateAPI.RegisterTestSuite(self)
endEvent

; Override the `Tests()` function to define your test cases
;
; Example:
;
; ```
;   scriptName MyTests extend SkyUnitTest
;
;   function Tests()
;       ; Tests without .Fn() functions are considered "PENDING".
;       ; This can be useful for tracking a TODO list of tests to write.
;       Test("Pending test")
;
;       Test("My passing test").Fn(PassingTest())
;   endFunction
;
;   function PassingTest()
;       ExpectString("Hello").To(EqualString("Hello"))
;   endFunction
; ```
function Tests()
endFunction

; Defines a test in this test suite
;
; Example:
;
; ```
;   scriptName MyTests extend SkyUnitTest
;
;   function Tests()
;       ; Tests without .Fn() functions are considered "PENDING".
;       ; This can be useful for tracking a TODO list of tests to write.
;       Test("Pending test")
;
;       Test("My passing test").Fn(PassingTest())
;   endFunction
;
;   function PassingTest()
;       ExpectString("Hello").To(EqualString("Hello"))
;   endFunction
; ```
SkyUnitTest function Test(string testName)
    SkyUnitPrivateAPI.Test_BeginTestRun(SkyUnitPrivateAPI.ScriptDisplayName(self), testName)
    return self
endFunction

; Usage: call your test function inside of the `Fn()` parameter
;
; Example:
;
; ```
;   scriptName MyTests extend SkyUnitTest
;
;   function Tests()
;       ; Note the that function passed to Fn()
;       ; must be invoked using () parenthesis:
;       Test("My passing test").Fn(PassingTest())
;   endFunction
;
;   function PassingTest()
;       ExpectString("Hello").To(EqualString("Hello"))
;   endFunction
; ```
function Fn(bool testFunction)
    SkyUnitPrivateAPI.Fn_EndTestRun()
endFunction

; Marks this as a "not" assertion, e.g. `ExpectString("").Not().To(EqualString(""))`
SkyUnitTest function Not()
    SkyUnitExpectation.ToggleNotExpectation()
    return self
endFunction

; Provide an assertion, e.g. `ExpectString("").To(EqualString(""))`
function To(bool assertionFunction)
endFunction

; TODO
; TODO
; TODO
; TODO
function BeforeAll()
endFunction
function AfterAll()
endFunction
function BeforeEach()
endFunction
function AfterEach()
endFunction
; TODO
; TODO
; TODO
; TODO

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simple Assert() and Fail()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Simplest assertion.
; If the provided expression does not evaluate to true, this will fail.
function Assert(bool actual, string failureMessage = "")
    if actual
        Pass()
    else
        Fail(failureMessage)
    endIf
endFunction

; Fails the current test with the provided message.
; The failure message will be shown in the test results.
function Fail(string failureMessage)
    SkyUnitExpectation.BeginExpectation("Fail")
    SkyUnitExpectation.Fail("Fail", failureMessage)
endFunction

; Pass the current test (unless test has any failing expectations)
function Pass()
    SkyUnitExpectation.BeginExpectation("Pass")
    SkyUnitExpectation.Pass("Pass")
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expectation Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function ExpectString(string actual)
    SkyUnitExpectation.SetActualString(actual)
endFunction

function ExpectInt(int actual)
    SkyUnitExpectation.SetActualInt(actual)
endFunction

function ExpectBool(bool actual)
    SkyUnitExpectation.SetActualBool(actual)
endFunction

function ExpectFloat(float actual)
    SkyUnitExpectation.SetActualFloat(actual)
endFunction

function ExpectForm(Form actual)
    SkyUnitExpectation.SetActualForm(actual, "Form")
endFunction

function ExpectPlayer()
    Form actual = Game.GetPlayer()
    SkyUnitExpectation.SetActualForm(actual, "Actor")
endFunction

function ExpectActor(Actor actual)
    SkyUnitExpectation.SetActualForm(actual, "Actor")
endFunction

function ExpectActorBase(ActorBase actual)
    SkyUnitExpectation.SetActualForm(actual, "ActorBase")
endFunction

function ExpectSpell(Spell actual)
    SkyUnitExpectation.SetActualForm(actual, "Spell")
endFunction

function ExpectShout(Shout actual)
    SkyUnitExpectation.SetActualForm(actual, "Shout")
endFunction

function ExpectQuest(Quest actual)
    SkyUnitExpectation.SetActualForm(actual, "Quest")
endFunction

function ExpectEnchantment(Enchantment actual)
    SkyUnitExpectation.SetActualForm(actual, "Enchantment")
endFunction

function ExpectScroll(Scroll actual)
    SkyUnitExpectation.SetActualForm(actual, "Scroll")
endFunction

function ExpectPerk(Perk actual)
    SkyUnitExpectation.SetActualForm(actual, "Perk")
endFunction

function ExpectIngredient(Ingredient actual)
    SkyUnitExpectation.SetActualForm(actual, "Ingredient")
endFunction

function ExpectFormList(FormList actual)
    SkyUnitExpectation.SetActualForm(actual, "FormList")
endFunction

function ExpectArmor(Armor actual)
    SkyUnitExpectation.SetActualForm(actual, "Armor")
endFunction

function ExpectWeapon(Weapon actual)
    SkyUnitExpectation.SetActualForm(actual, "Weapon")
endFunction

function ExpectPotion(Potion actual)
    SkyUnitExpectation.SetActualForm(actual, "Potion")
endFunction

function ExpectCell(Cell actual)
    SkyUnitExpectation.SetActualForm(actual, "Cell")
endFunction

function ExpectLocation(Location actual)
    SkyUnitExpectation.SetActualForm(actual, "Location")
endFunction

function ExpectLight(Light actual)
    SkyUnitExpectation.SetActualForm(actual, "Light")
endFunction

function ExpectGlobalVariable(GlobalVariable actual)
    SkyUnitExpectation.SetActualForm(actual, "GlobalVariable")
endFunction

function ExpectFaction(Faction actual)
    SkyUnitExpectation.SetActualForm(actual, "Faction")
endFunction

function ExpectPackage(Package actual)
    SkyUnitExpectation.SetActualForm(actual, "Package")
endFunction

function ExpectScene(Scene actual)
    SkyUnitExpectation.SetActualForm(actual, "Scene")
endFunction

function ExpectObjectReference(ObjectReference actual)
    SkyUnitExpectation.SetActualForm(actual, "ObjectReference")
endFunction

function ExpectMagicEffect(MagicEffect actual)
    SkyUnitExpectation.SetActualForm(actual, "MagicEffect")
endFunction

function ExpectActivetMagicEffect(ActiveMagicEffect actual)
    SkyUnitExpectation.SetActualActiveMagicEffect(actual)
endFunction

function ExpectAlias(Alias actual)
    SkyUnitExpectation.SetActualAlias(actual)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Assertion Functions - Equal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bool function EqualString(string expected)
    SkyUnitExpectation.SetExpectedString(expected)
    string actual
    if SkyUnitExpectation.GetActualType() == "String"
        actual = SkyUnitExpectation.GetActualString()
    else
        actual = SkyUnitExpectation.GetActualText()
    endIf
    bool not = SkyUnitExpectation.Not()
    if not && actual == expected
        return SkyUnitExpectation.Fail("EqualString", "Expected " + \
            SkyUnitExpectation.ActualDescription() + " not to equal " + \
            SkyUnitExpectation.ExpectedDescription())
    elseIf ! not && actual != expected
        return SkyUnitExpectation.Fail("EqualString", "Expected " + \
            SkyUnitExpectation.ActualDescription() + " to equal " + \
            SkyUnitExpectation.ExpectedDescription())
    endIf
    return SkyUnitExpectation.Pass("EqualString")
endFunction

bool function EqualInt(int expected)
    SkyUnitExpectation.SetExpectedInt(expected)
    int actual
    if SkyUnitExpectation.GetActualType() == "Int"
        actual = SkyUnitExpectation.GetActualInt()
    else
        actual = SkyUnitExpectation.GetActualText() as int
    endIf
    bool not = SkyUnitExpectation.Not()
    if not && actual == expected
        return SkyUnitExpectation.Fail("EqualInt", "Expected " + \
            SkyUnitExpectation.ActualDescription() + " not to equal " + \
            SkyUnitExpectation.ExpectedDescription())
    elseIf ! not && actual != expected
        return SkyUnitExpectation.Fail("EqualInt", "Expected " + \
            SkyUnitExpectation.ActualDescription() + " to equal " + \
            SkyUnitExpectation.ExpectedDescription())
    endIf
    return SkyUnitExpectation.Pass("EqualInt")
endFunction

bool function EqualBool(bool expected)
    SkyUnitExpectation.SetExpectedBool(expected)
    bool actual
    if SkyUnitExpectation.GetActualType() == "Bool"
        actual = SkyUnitExpectation.GetActualBool()
    else
        actual = SkyUnitExpectation.GetActualText() as bool
    endIf
    bool not = SkyUnitExpectation.Not()
    if not && actual == expected
        return SkyUnitExpectation.Fail("EqualBool", "Expected " + \
            SkyUnitExpectation.ActualDescription() + " not to equal " + \
            SkyUnitExpectation.ExpectedDescription())
    elseIf ! not && actual != expected
        return SkyUnitExpectation.Fail("EqualBool", "Expected " + \
            SkyUnitExpectation.ActualDescription() + " to equal " + \
            SkyUnitExpectation.ExpectedDescription())
    endIf
    return SkyUnitExpectation.Pass("EqualBool")
endFunction

bool function EqualFloat(float expected)
    SkyUnitExpectation.SetExpectedFloat(expected)
    float actual
    if SkyUnitExpectation.GetActualType() == "Float"
        actual = SkyUnitExpectation.GetActualFloat()
    else
        actual = SkyUnitExpectation.GetActualText() as float
    endIf
    bool not = SkyUnitExpectation.Not()
    if not && actual == expected
        return SkyUnitExpectation.Fail("EqualFloat", "Expected " + \
            SkyUnitExpectation.ActualDescription() + " not to equal " + \
            SkyUnitExpectation.ExpectedDescription())
    elseIf ! not && actual != expected
        return SkyUnitExpectation.Fail("EqualFloat", "Expected " + \
            SkyUnitExpectation.ActualDescription() + " to equal " + \
            SkyUnitExpectation.ExpectedDescription())
    endIf
    return SkyUnitExpectation.Pass("EqualFloat")
endFunction

bool function EqualForm(Form expected)
    SkyUnitExpectation.SetExpectedForm(expected, "Form")
    Form actual
    if SkyUnitExpectation.GetActualType() == "Form"
        actual = SkyUnitExpectation.GetActualForm()
    else
        return SkyUnitExpectation.Fail("EqualForm", "EqualForm() called but no Form-type was provided via an Expect*() function, e.g. ExpectForm() or ExpectActor() etc")
    endIf
    bool not = SkyUnitExpectation.Not()
    if not && actual == expected
        return SkyUnitExpectation.Fail("EqualForm", "Expected " + \
            SkyUnitExpectation.ActualDescription() + " not to equal " + \
            SkyUnitExpectation.ExpectedDescription())
    elseIf ! not && actual != expected
        return SkyUnitExpectation.Fail("EqualForm", "Expected " + \
            SkyUnitExpectation.ActualDescription() + " to equal " + \
            SkyUnitExpectation.ExpectedDescription())
    endIf
    return SkyUnitExpectation.Pass("EqualForm")
endFunction
