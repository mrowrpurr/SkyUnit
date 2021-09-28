scriptName SkyUnitTests_Assertions_Quest extends SkyUnitAssertionTestBase
{Tests for Quest and Quest objective assertions, e.g. `BeComplete()`}

; 814
; 10/20 start/finish - 0/1
; 
; ExpectQuest().Objective(1).To() ; ///
; ExpectQuest().Stage(1).To() ; ///

Quest ExampleQuest

int STAGE_START    = 10
int STAGE_COMPLETE = 20
int STAGE_FAIELD   = 30

int OBJECTIVE_ONE = 0
int OBJECTIVE_TWO = 1

function Tests()
    Test("Quest - BeComplete").Fn(Quest_BeComplete_Test())
    Test("Quest - BeFailed")
    Test("Stage - BeComplete")
    Test("Stage - BeCurrentStage").Fn(Stage_BeComplete_Test())
    Test("Objective - BeComplete")
    Test("Objective - BeFailed")
    Test("Objective - BeDisplayed")
endFunction

function BeforeAll()
    parent.BeforeAll()
    ExampleQuest = Game.GetFormFromFile(0x814, "SkyUnitTests.esp") as Quest
endFunction

function BeforeEach()
    parent.BeforeEach()
    ExampleQuest.Stop()
    ExampleQuest.Reset()
endFunction

function Quest_BeComplete_Test()
    ExampleQuest.Start()

    ; Fail
    ExpectExpectation().ToFail(ExpectQuest(ExampleQuest).To(BeComplete()))
    ExpectDescriptionContains("ExpectQuest(Cool Test Quest [Quest <SkyUnitQuestForTesting (")
    ExpectDescriptionContains("814)>]).To(BeComplete())")
    ExpectFailureMessageContains("Expected Quest Cool Test Quest [Quest <SkyUnitQuestForTesting (")
    ExpectFailureMessageContains("814)>] to be complete")
    ExpectActual("Form", "Cool Test Quest " + ExampleQuest)
    Expect(SkyUnitExpectation.GetExpectedType(ExpectationID)).To(Equal("Bool"))
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(ExampleQuest))

    ExampleQuest.SetCurrentStageID(STAGE_COMPLETE)

    ; Pass
    ExpectExpectation().ToPass(ExpectQuest(ExampleQuest).To(BeComplete()))
    ExpectDescriptionContains("ExpectQuest(Cool Test Quest [Quest <SkyUnitQuestForTesting (")
    ExpectDescriptionContains("814)>]).To(BeComplete())")
    ExpectFailureMessage("")
    ExpectActual("Form", "Cool Test Quest " + ExampleQuest)
    Expect(SkyUnitExpectation.GetExpectedType(ExpectationID)).To(Equal("Bool"))
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(ExampleQuest))

    ; Not() Fail
    ExpectExpectation().ToFail(ExpectQuest(ExampleQuest).Not().To(BeComplete()))
    ExpectDescriptionContains("ExpectQuest(Cool Test Quest [Quest <SkyUnitQuestForTesting (")
    ExpectDescriptionContains("814)>]).Not().To(BeComplete())")
    ExpectFailureMessageContains("Expected Quest Cool Test Quest [Quest <SkyUnitQuestForTesting (")
    ExpectFailureMessageContains("814)>] not to be complete")
    ExpectActual("Form", "Cool Test Quest " + ExampleQuest)
    Expect(SkyUnitExpectation.GetExpectedType(ExpectationID)).To(Equal("Bool"))
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(ExampleQuest))

    ExampleQuest.Stop()
    ExampleQuest.Reset()

    ; Not() Pass
    ExpectExpectation().ToPass(ExpectQuest(ExampleQuest).Not().To(BeComplete()))
    ExpectDescriptionContains("ExpectQuest(Cool Test Quest [Quest <SkyUnitQuestForTesting (")
    ExpectDescriptionContains("814)>]).Not().To(BeComplete())")
    ExpectFailureMessage("")
    ExpectActual("Form", "Cool Test Quest " + ExampleQuest)
    Expect(SkyUnitExpectation.GetExpectedType(ExpectationID)).To(Equal("Bool"))
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(ExampleQuest))
endFunction

function Stage_BeComplete_Test()
    ExampleQuest.Start()
    ExampleQuest.SetCurrentStageID(STAGE_START)

    ; Fail
    ExpectExpectation().ToFail(ExpectQuest(ExampleQuest).Stage(STAGE_COMPLETE).To(BeComplete()))
    JValue.writeToFile(ExpectationID, "TheExpectation.json")
    ExpectDescriptionContains("ExpectQuest(Cool Test Quest [Quest <SkyUnitQuestForTesting (")
    ExpectDescriptionContains("814)>]).Stage(20).To(BeComplete())")
    ExpectFailureMessageContains("Expected QuestStage Cool Test Quest [Quest <SkyUnitQuestForTesting (")
    ExpectFailureMessageContains("814)>] Stage 20 to be complete")
    ExpectActual("QuestStage", "Cool Test Quest " + ExampleQuest)
    Expect(SkyUnitExpectation.GetActualType(ExpectationID)).To(Equal("QuestStage"))
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(ExampleQuest))
    ExpectInt(SkyUnitExpectation.GetActualInt(ExpectationID, "stage")).To(EqualInt(20))
    Expect(SkyUnitExpectation.GetExpectedType(ExpectationID)).To(Equal("Bool"))

    ExampleQuest.SetCurrentStageID(STAGE_COMPLETE)

    ; Pass
    ExpectExpectation().ToPass(ExpectQuest(ExampleQuest).Stage(STAGE_COMPLETE).To(BeComplete()))
    ExpectDescriptionContains("ExpectQuest(Cool Test Quest [Quest <SkyUnitQuestForTesting (")
    ExpectDescriptionContains("814)>]).Stage(20).To(BeComplete())")
    ExpectFailureMessage("")
    ExpectActual("QuestStage", "Cool Test Quest " + ExampleQuest)
    Expect(SkyUnitExpectation.GetActualType(ExpectationID)).To(Equal("QuestStage"))
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(ExampleQuest))
    ExpectInt(SkyUnitExpectation.GetActualInt(ExpectationID, "stage")).To(EqualInt(20))
    Expect(SkyUnitExpectation.GetExpectedType(ExpectationID)).To(Equal("Bool"))

    ; Not() Fail
    ExpectExpectation().ToFail(ExpectQuest(ExampleQuest).Stage(STAGE_COMPLETE).Not().To(BeComplete()))
    ExpectDescriptionContains("ExpectQuest(Cool Test Quest [Quest <SkyUnitQuestForTesting (")
    ExpectDescriptionContains("814)>]).Stage(20).Not().To(BeComplete())")
    ExpectFailureMessageContains("Expected QuestStage Cool Test Quest [Quest <SkyUnitQuestForTesting (")
    ExpectFailureMessageContains("814)>] Stage 20 not to be complete")
    ExpectActual("QuestStage", "Cool Test Quest " + ExampleQuest)
    Expect(SkyUnitExpectation.GetActualType(ExpectationID)).To(Equal("QuestStage"))
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(ExampleQuest))
    ExpectInt(SkyUnitExpectation.GetActualInt(ExpectationID, "stage")).To(EqualInt(20))
    Expect(SkyUnitExpectation.GetExpectedType(ExpectationID)).To(Equal("Bool"))

    ExampleQuest.Stop()
    ExampleQuest.Reset()

    ; Not() Pass
    ExpectExpectation().ToPass(ExpectQuest(ExampleQuest).Stage(STAGE_COMPLETE).Not().To(BeComplete()))
    ExpectDescriptionContains("ExpectQuest(Cool Test Quest [Quest <SkyUnitQuestForTesting (")
    ExpectDescriptionContains("814)>]).Stage(20).Not().To(BeComplete())")
    ExpectFailureMessage("")
    ExpectActual("QuestStage", "Cool Test Quest " + ExampleQuest)
    Expect(SkyUnitExpectation.GetActualType(ExpectationID)).To(Equal("QuestStage"))
    ExpectForm(SkyUnitExpectation.GetActualForm(ExpectationID)).To(EqualForm(ExampleQuest))
    ExpectInt(SkyUnitExpectation.GetActualInt(ExpectationID, "stage")).To(EqualInt(20))
    Expect(SkyUnitExpectation.GetExpectedType(ExpectationID)).To(Equal("Bool"))
endFunction
