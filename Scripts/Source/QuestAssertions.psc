scriptName QuestAssertions hidden
{SkyUnit test assertions for Quests}

SkyUnitTest function ExpectQuest(Quest theQuest) global
    SkyUnit.BeginExpectation()
    SkyUnit.SetExpectationData_Form("Quest", theQuest)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectQuestObjective(Quest theQuest, int objective) global
    SkyUnit.BeginExpectation()
    SkyUnit.SetExpectationData_Form("Quest", theQuest)
    SkyUnit.SetExpectationData_Int("Objective", objective)
    return SkyUnit.CurrentTest()
endFunction

function BeComplete() global
    Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
    int objective = SkyUnit.GetExpectationData_Int("Objective", -1)
    bool not = SkyUnit.Not()
    if theQuest && objective > -1
        if not && theQuest.IsObjectiveCompleted(objective)
            SkyUnit.FailExpectation("Expected quest objective " + objective + " not to be completed - " + theQuest)
        elseIf ! not && ! theQuest.IsObjectiveCompleted(objective)
            SkyUnit.FailExpectation("Expected quest objective " + objective + " to be completed - " + theQuest)
        endIf
    elseIf theQuest
        if not && theQuest.IsCompleted()
            SkyUnit.FailExpectation("Expected quest not to be completed - " + theQuest)
        elseIf ! not && ! theQuest.IsCompleted()
            SkyUnit.FailExpectation("Expected quest to be completed - " + theQuest)
        endIf
    endIf
endFunction

function BeFailed() global
    Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
    int objective = SkyUnit.GetExpectationData_Int("Objective", -1)
    bool not = SkyUnit.Not()
    if theQuest && objective > -1
        if not && theQuest.IsObjectiveFailed(objective)
            SkyUnit.FailExpectation("Expected quest objective " + objective + " not to be failed - " + theQuest)
        elseIf ! not && ! theQuest.IsObjectiveFailed(objective)
            SkyUnit.FailExpectation("Expected quest objective " + objective + " to be failed - " + theQuest)
        endIf
    else
        SkyUnit.GetInstance().Log("BeFailed() called without ExpectQuestObjective()")
    endIf
endFunction

function BeDisplayed() global
    Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
    int objective = SkyUnit.GetExpectationData_Int("Objective", -1)
    bool not = SkyUnit.Not()
    if theQuest && objective > -1
        if not && theQuest.IsObjectiveDisplayed(objective)
            SkyUnit.FailExpectation("Expected quest objective " + objective + " not to be displayed - " + theQuest)
        elseIf ! not && ! theQuest.IsObjectiveDisplayed(objective)
            SkyUnit.FailExpectation("Expected quest objective " + objective + " to be displayed - " + theQuest)
        endIf
    else
        SkyUnit.GetInstance().Log("BeDisplayed() called without ExpectQuestObjective()")
    endIf
endFunction

; BeStarted()

; BeStopped()

; BeRunning()

; BeActive()

; BeDone()

function BeAtStage(int stageNumber) global
    Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
    bool not = SkyUnit.Not()
    int currentStage = theQuest.GetStage()
    if not && (currentStage == stageNumber)
        SkyUnit.FailExpectation("Expected quest stage not to be " + stageNumber)
    elseIf ! not && (currentStage != stageNumber)
        SkyUnit.FailExpectation("Expected quest stage to be " + stageNumber + " but was " + currentStage)
    endIf
endFunction
