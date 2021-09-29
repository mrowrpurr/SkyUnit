---
title: "Getting Started"
layout: singleWithoutTitle
permalink: /docs
author_profile: true
sidebar:
    nav: sidebar
toc: true
toc_label: "Getting Started"
toc_icon: "fad fa-graduation-cap"
---

# <i class="fad fa-graduation-cap"></i> Getting Started

Welcome! Are you ready to write tests for your Skyrim mods?

# <i class="fad fa-download"></i> Download SkyUnit

First off, download SkyUnit from NexusMods:

<i class="fas fa-gamepad-alt"></i> &nbsp;[SkyUnit on NexusMods](https://www.nexusmods.com/skyrimspecialedition/mods/56006)

You'll need to download a few dependencies:

- [SKSE64](https://skse.silverlock.org/) ( _core dependency_ )
- [JContainers](https://www.nexusmods.com/skyrimspecialedition/mods/16495?tab=files) ( _core dependency_ )
- [UIExtensions](https://www.nexusmods.com/skyrimspecialedition/mods/17561?tab=files) ( _used for the SkyUnit UI_ )

# <i class="fad fa-laptop"></i> Create Test

Let's create a mod from scratch. How does that sound?

And we'll add a test.

You can _optionally_ add tests to a separate `.esp` from your mod.

I think most folks will want to do this. So let's do it!

## Create New Mod to Store Tests

In Mod Organizer 2, create an Empty Mod.

> Or do this however you normally do it  
> in your favorite mod manager

[![Screenshot](/assets/images/screenshots/1 - Empty Mod.png)](/assets/images/screenshots/1 - Empty Mod.png)

## Save a New `.esp`

> Note: you can alternatively save your tests scripts  
> in your mod's main `.esp`, it's up to you.
>
> If you do, your tests will be available to any players
> who have SkyUnit installed.

[![Screenshot](/assets/images/screenshots/2 - Save ESP.png)](/assets/images/screenshots/2 - Save ESP.png)

## Create a New Quest

Create a quest which will store all of your test scripts.

> Every individual script represents a "test suite".
>
> You can (_and should_) have _multiple_ scripts.  
> Don't add all of your tests into one file.  

Make sure that your quest is `Start Game Enabled`

[![Screenshot](/assets/images/screenshots/3 - New Quest.png)](/assets/images/screenshots/3 - New Quest.png)

## Add a Script to the Quest to store our Tests

Create a new Quest script under the `Scripts` tab of the Quest.

> Note: it must be a Quest script, you cannot use a  
> Quest Alias `ReferenceAlias` as a test script.

[![Screenshot](/assets/images/screenshots/4 - A New Script.png)](/assets/images/screenshots/4 - A New Script.png)

## Name Your New Test Script

> Reminder: this is just your _first_ test script.
> 
> You will want to add more scripts to this Quests
> as you add more tests for your mod.

[![Screenshot](/assets/images/screenshots/4 - B Name New Script.png)](/assets/images/screenshots/4 - B Name New Script.png)

## Edit the Source of the Script

Make sure you have SkyUnit installed correctly by updating your script
so that it `extends SkyUnitTest` instead of `extends Quest`

[![Screenshot](/assets/images/screenshots/5 - Edit Source.png)](/assets/images/screenshots/5 - Edit Source.png)

## Compile Script

Use `Ctrl-S` to compile the script and make sure it compiles OK!

If you get an error like `variable JMap is undefined`  
then make sure you installed [JContainers](https://www.nexusmods.com/skyrimspecialedition/mods/16495?tab=files)

If you get an error like `variable SkyUnitTest is undefined`  
then make sure you installed SkyUnit

[![Screenshot](/assets/images/screenshots/6 - Compile OK.png)](/assets/images/screenshots/6 - Compile OK.png)

## Open Test Code in Text Editor

Do not try to write your tests in the `Edit Source` area of Creation Kit.

Open your newly created mod in [Visual Studio Code](https://code.visualstudio.com/) or whichever editor you use for Papyrus scripts.

To be effective writing tests, you **MUST HAVE CODE COMPLETION.**

You could try to use SkyUnit without code completion, but it is _highly recommended_ to use a modern editor with
Papyrus support.

[![Screenshot](/assets/images/screenshots/7 - VSCode.png)](/assets/images/screenshots/7 - VSCode.png)

## Add Tests

Time to add tests!

[![Screenshot](/assets/images/screenshots/8 - Test Code.png)](/assets/images/screenshots/8 - Test Code.png)

```php
scriptName MyFirstTest extends SkyUnitTest  
{This is my first test using SkyUnit}

; # Create a Tests() function to define all of your tests
function Tests()
    ; # Define each test case using Test()
    ; # and connect it to a function where the test
    ; # is defined using Fn([test function]())
    Test("This should pass").Fn(ThisShouldPass_Test())

    ; # Add another test case 
    Test("This should fail").Fn(ThisShouldFail_Test())

    ; # This test case has no connected function.
    ; # It will show up in the SkyUnit UI as a "pending" test.
    ; # Useful for tracking TODO lists of tests.
    Test("We should write this one later")
endFunction

function ThisShouldPass_Test()
    Expect(1).To(Equal(1))
endFunction

function ThisShouldFail_Test()
    Expect(1).To(Equal(2))
endFunction
```

Now **save and compile!**

# <i class="fad fa-gamepad-alt"></i> Run Test

Time to _boot up the game!_

> Make sure you have your new `.esp` containing the tests included.

When you boot up the game and `coc [somewhere]`, you should see  
a `1 Tests Found` notification!

If you see this, you will _automatically_ have a Lesser Power equipped (_which opens up the SkyUnit UI_)

[![Screenshot](/assets/images/screenshots/9 - Test Found.png)](/assets/images/screenshots/9 - Test Found.png)

## SkyUnit UI

You can open the SkyUnit UI using the `[SkyUnit - Run Tests]` power.

This should be automatically equipped, so simply press `Z` to open the SkyUnit UI menu.

[![Screenshot](/assets/images/screenshots/10 - Shout.png)](/assets/images/screenshots/10 - Shout.png)

## Main Menu

From the main menu, you can run all Test Suites (_all discovered test scripts_)
or click on an individual test suite to run it.

> Note: if you know the name of a single test suite you want to run,  
> you can tap the `F` key (_for **f**ilter_) to filter test suites.  
> Just type part of the test suite name and it will run.  
> This is useful if you have multiple test suites defined.

[![Screenshot](/assets/images/screenshots/11 - Main Menu.png)](/assets/images/screenshots/11 - Main Menu.png)

## Test Suite Results

After the test suite runs, you can see the results of each test!

If you want to see details about an individual test, e.g. see the failure messages in a failed test, click `View Tests`.

> Note: sometimes not all tests will show up in this dialog due to text length limitation.
> In these cases, use `View Tests` to see a full list of tests and view individual failed tests.

[![Screenshot](/assets/images/screenshots/12 - Test Suite Results.png)](/assets/images/screenshots/12 - Test Suite Results.png)

## View Individual Test

You can choose individual tests to view.

Failed tests are highlighted with `[FAIL]` and pending tests are highlighted with `*`

[![Screenshot](/assets/images/screenshots/13 - Choose Test.png)](/assets/images/screenshots/13 - Choose Test.png)

## Test Details

Viewing a test will show you all of the failing expectations and their failure messages.

> Note: sometimes not all expectations will show up in this dialog due to text length limitation.
> In these cases, use `View Expectations` to see a full list of expectations and view individual failed expectations.

[![Screenshot](/assets/images/screenshots/14 - Test Result.png)](/assets/images/screenshots/14 - Test Result.png)
