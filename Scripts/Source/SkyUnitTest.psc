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

SkyUnitTest function ExpectString(string actual)
    SkyUnitExpectation.BeginExpectation("ExpectString")
    SkyUnitExpectation.SetActualString(actual)
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectInt(int actual)
    SkyUnitExpectation.BeginExpectation("ExpectInt")
    SkyUnitExpectation.SetActualInt(actual)
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectBool(bool actual)
    SkyUnitExpectation.BeginExpectation("ExpectBool")
    SkyUnitExpectation.SetActualBool(actual)
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectFloat(float actual)
    SkyUnitExpectation.BeginExpectation("ExpectFloat")
    SkyUnitExpectation.SetActualFloat(actual)
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectForm(Form actual)
    SkyUnitExpectation.BeginExpectation("ExpectForm")
    SkyUnitExpectation.SetActualForm(actual, "Form")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectPlayer()
    SkyUnitExpectation.BeginExpectation("ExpectPlayer")
    Form actual = Game.GetPlayer()
    SkyUnitExpectation.SetActualForm(actual, "Actor")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectActor(Actor actual)
    SkyUnitExpectation.BeginExpectation("ExpectActor")
    SkyUnitExpectation.SetActualForm(actual, "Actor")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectActorBase(ActorBase actual)
    SkyUnitExpectation.BeginExpectation("ExpectActorBase")
    SkyUnitExpectation.SetActualForm(actual, "ActorBase")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectSpell(Spell actual)
    SkyUnitExpectation.BeginExpectation("ExpectSpell")
    SkyUnitExpectation.SetActualForm(actual, "Spell")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectShout(Shout actual)
    SkyUnitExpectation.BeginExpectation("ExpectShout")
    SkyUnitExpectation.SetActualForm(actual, "Shout")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectQuest(Quest actual)
    SkyUnitExpectation.BeginExpectation("ExpectQuest")
    SkyUnitExpectation.SetActualForm(actual, "Quest")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectEnchantment(Enchantment actual)
    SkyUnitExpectation.BeginExpectation("ExpectEnchantment")
    SkyUnitExpectation.SetActualForm(actual, "Enchantment")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectScroll(Scroll actual)
    SkyUnitExpectation.BeginExpectation("ExpectScroll")
    SkyUnitExpectation.SetActualForm(actual, "Scroll")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectPerk(Perk actual)
    SkyUnitExpectation.BeginExpectation("ExpectPerk")
    SkyUnitExpectation.SetActualForm(actual, "Perk")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectIngredient(Ingredient actual)
    SkyUnitExpectation.BeginExpectation("ExpectIngredient")
    SkyUnitExpectation.SetActualForm(actual, "Ingredient")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectFormList(FormList actual)
    SkyUnitExpectation.BeginExpectation("ExpectFormList")
    SkyUnitExpectation.SetActualForm(actual, "FormList")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectArmor(Armor actual)
    SkyUnitExpectation.BeginExpectation("ExpectArmor")
    SkyUnitExpectation.SetActualForm(actual, "Armor")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectWeapon(Weapon actual)
    SkyUnitExpectation.BeginExpectation("ExpectWeapon")
    SkyUnitExpectation.SetActualForm(actual, "Weapon")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectPotion(Potion actual)
    SkyUnitExpectation.BeginExpectation("ExpectPotion")
    SkyUnitExpectation.SetActualForm(actual, "Potion")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectCell(Cell actual)
    SkyUnitExpectation.BeginExpectation("ExpectCell")
    SkyUnitExpectation.SetActualForm(actual, "Cell")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectLocation(Location actual)
    SkyUnitExpectation.BeginExpectation("ExpectLocation")
    SkyUnitExpectation.SetActualForm(actual, "Location")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectLight(Light actual)
    SkyUnitExpectation.BeginExpectation("ExpectLight")
    SkyUnitExpectation.SetActualForm(actual, "Light")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectGlobalVariable(GlobalVariable actual)
    SkyUnitExpectation.BeginExpectation("ExpectGlobalVariable")
    SkyUnitExpectation.SetActualForm(actual, "GlobalVariable")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectFaction(Faction actual)
    SkyUnitExpectation.BeginExpectation("ExpectFaction")
    SkyUnitExpectation.SetActualForm(actual, "Faction")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectPackage(Package actual)
    SkyUnitExpectation.BeginExpectation("ExpectPackage")
    SkyUnitExpectation.SetActualForm(actual, "Package")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectScene(Scene actual)
    SkyUnitExpectation.BeginExpectation("ExpectScene")
    SkyUnitExpectation.SetActualForm(actual, "Scene")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectObjectReference(ObjectReference actual)
    SkyUnitExpectation.BeginExpectation("ExpectObjectReferece")
    SkyUnitExpectation.SetActualForm(actual, "ObjectReference")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectMagicEffect(MagicEffect actual)
    SkyUnitExpectation.BeginExpectation("ExpectMagicEffect")
    SkyUnitExpectation.SetActualForm(actual, "MagicEffect")
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectActiveMagicEffect(ActiveMagicEffect actual)
    SkyUnitExpectation.BeginExpectation("ExpectActiveMagicEffect")
    SkyUnitExpectation.SetActualActiveMagicEffect(actual)
    return SkyUnitExpectation.CurrentTest()
endFunction

SkyUnitTest function ExpectAlias(Alias actual)
    SkyUnitExpectation.BeginExpectation("ExpectAlias")
    SkyUnitExpectation.SetActualAlias(actual)
    return SkyUnitExpectation.CurrentTest()
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Assertion Functions - Equal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bool function EqualString(string expected)
    SkyUnitPrivateAPI.Info("Equal String " + expected)
    SkyUnitExpectation.SetExpectedString(expected)
    string actual
    if SkyUnitExpectation.GetActualType() == "String"
        actual = SkyUnitExpectation.GetActualString()
    else
        actual = SkyUnitExpectation.GetActualText()
    endIf
    bool not = SkyUnitExpectation.Not()
    Debug.Trace("THIS IS EQUAL STRING AND WE ARE CALLING THE STUPID FUCKING FUNTION")
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
