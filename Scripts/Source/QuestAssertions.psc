scriptName QuestAssertions hidden
{SkyUnit test assertions for Quests}

SkyUnitTest function ExpectQuest(Quest theQuest) global
    SkyUnit.BeginExpectation(type = "Quest", object = theQuest)
    SkyUnit.SetExpectationForm("ExpectationQuest", theQuest)
    return SkyUnit.CurrentTest()
endFunction

Quest function ExpectationQuest() global
    return SkyUnit.GetExpectationForm("ExpectationQuest") as Quest
endFunction

function HaveCompletedObjective(int objective) global
    SkyUnit.SetExpectationInt("Objective", objective)
    bool not = SkyUnit.Not()
    Quest theQuest = ExpectationQuest()
    bool completed = theQuest.IsObjectiveCompleted(objective)
    if not && completed
        SkyUnit.FailExpectation("Objective " + objective + " is complete (expected not complete)")
    elseIf ! completed && ! not
        SkyUnit.FailExpectation("Objective " + objective + " is not complete (expected complete)")
    endIf
endFunction

function HaveFailedObjective(int objective) global
    SkyUnit.SetExpectationInt("Objective", objective)
    bool not = SkyUnit.Not()
    Quest theQuest = ExpectationQuest()
    bool failed = theQuest.IsObjectiveFailed(objective)
    Debug.Trace("SkyUnit Is Objective " + objective + " on quest " + theQuest + " failed? " + failed)
    if not && failed
        SkyUnit.FailExpectation("Objective " + objective + " is failed (expected not failed)")
    elseIf ! failed && ! not
        SkyUnit.FailExpectation("Objective " + objective + " is not failed (expected failed)")
    endIf
endFunction

function BeAtStage(int stageNumber) global
    SkyUnit.SetExpectationInt("Stage Number", stageNumber)
    Quest theQuest = ExpectationQuest()
    bool not = SkyUnit.Not()
    int currentStage = theQuest.GetStage()
    if not && (currentStage == stageNumber)
        SkyUnit.FailExpectation("Expected quest stage not to be " + stageNumber)
    elseIf ! not && (currentStage != stageNumber)
        SkyUnit.FailExpectation("Expected quest stage to be " + stageNumber + " but was " + currentStage)
    endIf
endFunction
