# `SkyUnit`

> SkyUnit is a Unit Testing Framework for Skyrim Papyrus Scripts

![SkyUnit Logo](Images/Logo.jpg)

---

# Getting Started

## #1. Install Dependencies

- [SKSE64][] ( _because "duh"_ )
- [JContainers][] ( _for making it all work_ )
- [UIExtensions][] ( _for the UI which is used to choose tests to run_ )
- [PapyrusUtil][] ( _for printing out to the console_ )

[SKSE64]: https://skse.silverlock.org/
[JContainers]: https://www.nexusmods.com/skyrimspecialedition/mods/16495?tab=files
[PapyrusUtil]: https://www.nexusmods.com/skyrimspecialedition/mods/13048?tab=files
[UIExtensions]: https://www.nexusmods.com/skyrimspecialedition/mods/17561?tab=files

## #2. [Download][latest] the [latest release][latest] from GitHub.

> _NexusMods release coming very soon!_

[latest]: https://github.com/mrowrpurr/SkyUnit/releases/download/v1.0-alpha/SkyUnit.7z

_And then obviously install it with your favorite mod manager :)_

## #3. Create a new Quest

> e.g. `MyCoolModTests`

The quest will have attached `Scripts` for each group of tests that you write.

- **Disable** `Start Game Enabled`
- **Disable** `Run Once`

## #4. Add a new script

> e.g. `MyCoolModTests.psc`

This script will have a group of tests!

You can organize your tests into multiple scripts or simply use one script.

## #5. Update script to `extends SkyUnit2Test`

### Example:

```psc
scriptName MyCoolModTests extends SkyUnit2Test
```

## #6. Create a `function Tests()`

In this function, you will declare all of your tests.

Each test maps to a function which you define!

### Example:

```psc
scriptName MyCoolModTests extends SkyUnit2Test

function Tests()
    Test("Quest starts OK").Fn(<name of test function>())
endFunction
```

_See below for creating test functions._

## #7. Create functions for each test scenario

> e.g. `function QuestStartsOkTest()`

### Example:

```psc
scriptName MyCoolModTests extends SkyUnit2Test

function Tests()
    Test("Quest starts OK").Fn(QuestStartsOkTest())
endFunction

function QuestStartsOkTest()
    ; Test goes here!
endFunction
```

## #8. Add some "Expect" assertions to the test

> e.g. `ExpectString("Hello").To(EqualString("Hello"))`

Note: certain expectations are built-in to `SkyUnit2Test`:
- `ExpectString`, `ExpectInt`, `ExpectFloat`, `ExpectBool`, `ExpectForm`
- `ExpectStringArray`, `ExpectIntArray`, `ExpectFloatArray`, `ExpectBoolArray`, `ExpectFormArray`

Other expectations are available via the `import` statement:

> e.g. `import QuestAssertions`

You'll soon be able to find documentation for all available assertions on the [Wiki][],

### Example:

```psc
scriptName MyCoolModTests extends SkyUnit2Test

; As an example, maybe you added some properties
; including a reference to a quest and an actor
; who is initially disabled until the quest starts
Quest property MyCoolQuest auto
Actor property MyCoolNpc   auto

; Import Expect* functions for Actors and Quests
import ActorAssertions
import QuestAssertions

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

## #9. Run the game & run the tests!

Once in game, your tests should be automatically detected!

Use the `[SkyUnit] Run Tests` power to popup the test run chooser.

Note: if any tests are detected, this power will be automatically equipped for you, so you can simply run the game and then press `Z`

---

_Documentation and videos coming soon!_

[Wiki]: https://github.com/mrowrpurr/SkyUnit/wiki