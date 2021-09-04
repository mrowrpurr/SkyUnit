scriptName QuestAssertions hidden
{SkyUnit test assertions for Quests}

SkyUnit2Test function ExpectQuest(Quest theQuest) global
    SkyUnit2.BeginExpectation("ExpectQuest")
    SkyUnit.SetExpectationData_Form("Quest", theQuest)
    return SkyUnit2.CurrentTest()
endFunction

SkyUnit2Test function ExpectQuestObjective(Quest theQuest, int objective) global
    SkyUnit2.BeginExpectation("ExpectQuest")
    SkyUnit.SetExpectationData_Form("Quest", theQuest)
    SkyUnit.SetExpectationData_Int("Objective", objective)
    return SkyUnit2.CurrentTest()
endFunction

SkyUnit2Test function ExpectQuestStage(Quest theQuest, int stage) global
    SkyUnit2.BeginExpectation("ExpectQuest")
    SkyUnit.SetExpectationData_Form("Quest", theQuest)
    SkyUnit.SetExpectationData_Int("Stage", stage)
    return SkyUnit2.CurrentTest()
endFunction

function BeComplete() global
    Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
    int objective = SkyUnit.GetExpectationData_Int("Objective", -1)
    int stage = SkyUnit.GetExpectationData_Int("Stage", -1)
    bool not = SkyUnit.Not()
    if theQuest && objective > -1
        if not && theQuest.IsObjectiveCompleted(objective)
            SkyUnit.FailExpectation("Expected quest objective " + objective + " not to be completed - " + theQuest)
        elseIf ! not && ! theQuest.IsObjectiveCompleted(objective)
            SkyUnit.FailExpectation("Expected quest objective " + objective + " to be completed - " + theQuest)
        endIf
    elseIf theQuest && stage > -1
        if not && theQuest.IsStageDone(stage)
            SkyUnit.FailExpectation("Expected quest stage " + stage + " not to be done - " + theQuest)
        elseIf ! not && ! theQuest.IsStageDone(stage)
            SkyUnit.FailExpectation("Expected quest stage " + stage + " to be done - " + theQuest)
        endIf
    elseIf theQuest
        if not && theQuest.IsCompleted()
            SkyUnit.FailExpectation("Expected quest not to be completed - " + theQuest)
        elseIf ! not && ! theQuest.IsCompleted()
            SkyUnit.FailExpectation("Expected quest to be completed - " + theQuest)
        endIf
    else
        SkyUnit.GetInstance().Log("BeComplete() or BeDone() called without ExpectQuest[Stage|Objective]()")
    endIf
endFunction

function BeDone() global
    BeComplete()
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

function BeRunning() global
    Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
    if theQuest
        bool not = SkyUnit.Not()
        int currentStage = theQuest.GetStage()
        if not && theQuest.IsRunning()
            SkyUnit.FailExpectation("Expected quest not to be running - " + theQuest)
        elseIf ! not && ! theQuest.IsRunning()
            SkyUnit.FailExpectation("Expected quest to be running - " + theQuest)
        endIf
    else
        SkyUnit.GetInstance().Log("BeRunning() called without ExpectQuest()")
    endIf
endFunction

function BeActive() global
    Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
    if theQuest
        bool not = SkyUnit.Not()
        int currentStage = theQuest.GetStage()
        if not && theQuest.IsActive()
            SkyUnit.FailExpectation("Expected quest not to be active - " + theQuest)
        elseIf ! not && ! theQuest.IsActive()
            SkyUnit.FailExpectation("Expected quest to be active - " + theQuest)
        endIf
    else
        SkyUnit.GetInstance().Log("BeActive() called without ExpectQuest()")
    endIf
endFunction

function BeStopped() global
    Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
    if theQuest
        bool not = SkyUnit.Not()
        int currentStage = theQuest.GetStage()
        if not && theQuest.IsStopped()
            SkyUnit.FailExpectation("Expected quest not to be stopped - " + theQuest)
        elseIf ! not && ! theQuest.IsStopped()
            SkyUnit.FailExpectation("Expected quest to be stopped - " + theQuest)
        endIf
    else
        SkyUnit.GetInstance().Log("BeStopped() called without ExpectQuest()")
    endIf
endFunction

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
