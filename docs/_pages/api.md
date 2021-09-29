---
title: "API Reference"
layout: singleWithoutTitle
permalink: /api
author_profile: true
sidebar:
    nav: sidebar
toc: true
toc_label: "API Reference"
toc_icon: "fad fa-book"
---

# <i class="fad fa-book"></i> API Reference

# Expectations

Every test needs "expectations".

You do something in your tests.

Then you "expect" something to equal something else.

Or you might `ExpectActor(npc).To(BeDead())`.

It all starts with `Expect*`.

SkyUnit uses the following language:  
(_because we need words to define things_)

- `ExpectActor(npc)` is referred to as an "expectation"
- `BeDead()` is referred to as an "assertion"
- The whole thing, overall, may also be referred to as an "expectation"

Below is a list of the built-in expectations:

 - `Expect(string actual)` (_alias for ExpectString_)
 - `ExpectString(string actual)`
 - `ExpectInt(int actual)`
 - `ExpectBool(bool actual)`
 - `ExpectFloat(float actual)`
 - `ExpectForm(Form actual)`
 - `ExpectPlayer()`
 - `ExpectActor(Actor actual)`
 - `ExpectActorBase(ActorBase actual)`
 - `ExpectSpell(Spell actual)`
 - `ExpectShout(Shout actual)`
 - `ExpectQuest(Quest actual)`
 - `ExpectEnchantment(Enchantment actual)`
 - `ExpectScroll(Scroll actual)`
 - `ExpectPerk(Perk actual)`
 - `ExpectIngredient(Ingredient actual)`
 - `ExpectFormList(FormList actual)`
 - `ExpectArmor(Armor actual)`
 - `ExpectWeapon(Weapon actual)`
 - `ExpectPotion(Potion actual)`
 - `ExpectCell(Cell actual)`
 - `ExpectLocation(Location actual)`
 - `ExpectLight(Light actual)`
 - `ExpectGlobalVariable(GlobalVariable actual)`
 - `ExpectFaction(Faction actual)`
 - `ExpectPackage(Package actual)`
 - `ExpectScene(Scene actual)`
 - `ExpectObjectReference(ObjectReference actual)`
 - `ExpectMagicEffect(MagicEffect actual)`
 - `ExpectActiveMagicEffect(ActiveMagicEffect actual)`
 - `ExpectAlias(Alias actual)`
 - `ExpectStringArray(string[] actual)`
 - `ExpectIntArray(int[] actual)`
 - `ExpectFloatArray(float[] actual)`
 - `ExpectFormArray(Form[] actual)`
 - `ExpectBoolArray(bool[] actual)`

## Custom Expectations

If you'd like to make your own custom `Expect[Something]`:

```r
SkyUnitTest function ExpectSomething(Form actual)
    ; # Tell SkyUnit about your expectation and its name (this is required)
    SkyUnitExpectation.BeginExpectation("ExpectSomething")
    ; # If your expectation takes an actual value, e.g. ExpectString(actual)
    ; # then you'll want to store the "actual value".
    ; # To do that, use SkyUnitExpectation.SetActual[Type](actual)
    ; # The types available are:
    ; # - SetActualString()
    ; # - SetActualBool()
    ; # - SetActualInt()
    ; # - SetActualForm()
    ; # - SetActualFloat()
    ; # - SetActualAlias()
    ; # - SetActualActiveMagicEffect()
    ; # - SetActualStringArray()
    ; # - SetActualBoolArray()
    ; # - SetActualIntArray()
    ; # - SetActualFloatArray()
    ; # - SetActualFloatArray()
    ; # If your object is a totally custom script, you'll want to store
    ; # it yourself somewhere and read it from your custom assertion(s)
    SkyUnitExpectation.SetActualString(actual)
    ; # You MUST return SkyUnitExpectation.CurrentTest() for SkyUnit to work.
    ; # This is what allows for the syntax: ExpectSomething().To(...)
    return SkyUnitExpectation.CurrentTest()
endFunction
```

# Basic Assertions

Once you have an expectation,  
e.g. `ExpectString([actual string])`  
then you assert something about the "actual" value:

```r
ExpectString("Hello").To(EqualString("World"))
```

The rest of this page provides a list of the available build-in assertions.

See [Custom Assertions](#custom-assertions) to build your own custom assertions.

## Equality Assertions

 - `Equal(string expected)`
 - `EqualString(string expected)`
 - `EqualInt(int expected)`
 - `EqualBool(bool expected)`
 - `EqualFloat(float expected)`
 - `EqualForm(Form expected)`

## Array Assertions

 - `EqualStringArray(string[] expected)`

> **Coming Soon**  
> - _more array assertions_

## Generic Assertions

- `BeFalse()` (_currently only works with Bool values_)
- `BeTrue()` (_currently only works with Bool values_)
- `ContainText(string expected)`

> **Coming Soon**
> - `BeEmpty`
> - `HaveLength`
> - `BeGreaterThan`
> - `BeGreaterThanOrEqualTo`
> - `BeLessThan`
> - `BeLessThanOrEqualTo`

# Actor Assertions

- `X(Y expected)`

> **Coming Soon**
> - `Z`

# Form Assertions

- `X(Y expected)`

> **Coming Soon**
> - `Z`

# Object Assertions

- `X(Y expected)`

> **Coming Soon**
> - `Z`

# Quest Assertions

- `X(Y expected)`

> **Coming Soon**
> - `Z`

# Custom Assertions
