# `SkyUnit`

> SkyUnit is a Unit Testing Framework for Skyrim Papyrus Scripts

![SkyUnit Logo](Images/Logo.jpg)

---

# Getting Started

## #1. [Download][latest] the [latest release][latest] from GitHub.

> NexusMods release pending

[latest]: #

## #2. Create a new Quest

> e.g. `MyCoolModTests`

The quest will have attached `Scripts` for each group of tests that you write.

- **Disable** `Start Game Enabled`
- **Disable** `Run Once`

## #3. Add a new script

> e.g. `MyCoolModTests.psc`

This script will have a group of tests!

You can organize your tests into multiple scripts or simply use one script.

## #4. Update script to `extends SkyUnitTest`

#### Example:

```psc
scriptName MyCoolModTests extends SkyUnitTest
```

## #5. Create a `function Tests()`

In this function, you will declare all of your tests.

Each test maps to a function which you define!

#### Example:

```psc
scriptName MyCoolModTests extends SkyUnitTest

function Tests()
    Test("Quest starts OK").Fn(<name of test function>())
endFunction
```

_See below for creating test functions._

## #6. Create functions for each test scenario

> e.g. `function QuestStartsOkTest()`

#### Example:

```psc
scriptName MyCoolModTests extends SkyUnitTest

function Tests()
    Test("Quest starts OK").Fn(QuestStartsOkTest())
endFunction

function QuestStartsOkTest()

endFunction
```

## #7. Add some "Expect" assertions to the test

> e.g. `ExpectString("Hello").To(EqualString("Hello"))`

#### Example:

```psc
scriptName MyCoolModTests extends SkyUnitTest

; As an example, maybe you added some properties
; including a reference to a quest and an actor
; who is initially disabled until the quest starts
Quest property MyCoolQuest auto
Actor property MyCoolNpc   auto

function Tests()
    Test("Quest starts OK").Fn(QuestStartsOkTest())
endFunction

function QuestStartsOkTest()
    ExpectActor(MyCoolNpc).To(BeDisabled())
    ExpectQuest(MyCoolQuest).To(BeAtStage(0))
    ExpectQuestObjective(MyCoolQuest, 1).Not().To(BeDisplayed())

    ; Start the quest by doing something!
    ; Here we just manually set the stage to '10'
    ; which starts this quest
    MyCoolQuest.SetStage(10)

    ExpectActor(MyCoolNpc).To(BeEnabled())
    ExpectQuest(MyCoolQuest).To(BeAtStage(10))
    ExpectQuestObjective(MyCoolQuest, 1).To(BeDisplayed())
endFunction
```

## #8. Checkout the [Wiki][] for examples and docs!

> https://github.com/mrowrpurr/SkyUnit/wiki

You can also checkout [this playlist][playlist] on YouTube
for tutorials on using SkyUnit.

[Wiki]: https://github.com/mrowrpurr/SkyUnit/wiki
[playerlist]: #

## #9. Enjoy. Happy Modding!