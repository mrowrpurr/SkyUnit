scriptName QuestAssertions hidden
{SkyUnit test assertions for Quests}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Expectations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SkyUnitTest function ExpectQuest(Quest theQuest) global
    SkyUnit.BeginExpectation("ExpectQuest")
    SkyUnit.SetExpectationData_Form("Quest", theQuest)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectQuestObjective(Quest theQuest, int objective) global
    SkyUnit.BeginExpectation("ExpectQuest")
    SkyUnit.SetExpectationData_Form("Quest", theQuest)
    SkyUnit.SetExpectationData_Int("Objective", objective)
    return SkyUnit.CurrentTest()
endFunction

SkyUnitTest function ExpectQuestStage(Quest theQuest, int stage) global
    SkyUnit.BeginExpectation("ExpectQuest")
    SkyUnit.SetExpectationData_Form("Quest", theQuest)
    SkyUnit.SetExpectationData_Int("Stage", stage)
    return SkyUnit.CurrentTest()
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Assertions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Note: clean these up as we go thru and test them, they're not all returning PassExpectation!

; bool function BeComplete() global
;     string expectationName = ""
;     Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
;     int objective = SkyUnit.GetExpectationData_Int("Objective", -1)
;     int stage = SkyUnit.GetExpectationData_Int("Stage", -1)
;     bool not = SkyUnit.Not()
;     if theQuest && objective > -1
;         if not && theQuest.IsObjectiveCompleted(objective)
;             return SkyUnit.FailExpectation("BeComplete", "Expected quest objective " + objective + " not to be completed - " + theQuest)
;         elseIf ! not && ! theQuest.IsObjectiveCompleted(objective)
;             return SkyUnit.FailExpectation("BeComplete", "Expected quest objective " + objective + " to be completed - " + theQuest)
;         endIf
;     elseIf theQuest && stage > -1
;         if not && theQuest.IsStageDone(stage)
;             return SkyUnit.FailExpectation("BeComplete", "Expected quest stage " + stage + " not to be done - " + theQuest)
;         elseIf ! not && ! theQuest.IsStageDone(stage)
;             return SkyUnit.FailExpectation("BeComplete", "Expected quest stage " + stage + " to be done - " + theQuest)
;         endIf
;     elseIf theQuest
;         if not && theQuest.IsCompleted()
;             return SkyUnit.FailExpectation("BeComplete", "Expected quest not to be completed - " + theQuest)
;         elseIf ! not && ! theQuest.IsCompleted()
;             return SkyUnit.FailExpectation("BeComplete", "Expected quest to be completed - " + theQuest)
;         endIf
;     else
;         return SkyUnit.FailExpectation("BeComplete", "BeComplete() or BeDone() called without ExpectQuest[Stage|Objective]()")
;     endIf
;     return SkyUnit.PassExpectation("BeComplete")
; endFunction

; bool function BeDone() global
;     return BeComplete()
; endFunction

; bool function BeFailed() global
;     string expectationName = ""
;     Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
;     int objective = SkyUnit.GetExpectationData_Int("Objective", -1)
;     bool not = SkyUnit.Not()
;     if theQuest && objective > -1
;         if not && theQuest.IsObjectiveFailed(objective)
;             return SkyUnit.FailExpectation("BeFailed", "Expected quest objective " + objective + " not to be failed - " + theQuest)
;         elseIf ! not && ! theQuest.IsObjectiveFailed(objective)
;             return SkyUnit.FailExpectation("BeFailed", "Expected quest objective " + objective + " to be failed - " + theQuest)
;         endIf
;     else
;         return SkyUnit.FailExpectation("BeFailed", "BeFailed() called without ExpectQuestObjective()")
;     endIf
;     return SkyUnit.PassExpectation("BeFailed")
; endFunction

; bool function BeDisplayed() global
;     string expectationName = "BeDisplayed"
;     Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
;     int objective = SkyUnit.GetExpectationData_Int("Objective", -1)
;     bool not = SkyUnit.Not()
;     if theQuest && objective > -1
;         if not && theQuest.IsObjectiveDisplayed(objective)
;             return SkyUnit.FailExpectation(expectationName, "Expected quest objective " + objective + " not to be displayed - " + theQuest)
;         elseIf ! not && ! theQuest.IsObjectiveDisplayed(objective)
;             return SkyUnit.FailExpectation(expectationName, "Expected quest objective " + objective + " to be displayed - " + theQuest)
;         endIf
;     else
;         SkyUnit.GetInstance().Log("BeDisplayed() called without ExpectQuestObjective()")
;     endIf
; endFunction

; bool function BeRunning() global
;     string expectationName = ""
;     Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
;     if theQuest
;         bool not = SkyUnit.Not()
;         int currentStage = theQuest.GetStage()
;         if not && theQuest.IsRunning()
;             return SkyUnit.FailExpectation(expectationName, "Expected quest not to be running - " + theQuest)
;         elseIf ! not && ! theQuest.IsRunning()
;             return SkyUnit.FailExpectation(expectationName, "Expected quest to be running - " + theQuest)
;         endIf
;     else
;         SkyUnit.GetInstance().Log("BeRunning() called without ExpectQuest()")
;     endIf
; endFunction

; bool function BeActive() global
;     string expectationName = ""
;     Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
;     if theQuest
;         bool not = SkyUnit.Not()
;         int currentStage = theQuest.GetStage()
;         if not && theQuest.IsActive()
;             return SkyUnit.FailExpectation(expectationName, "Expected quest not to be active - " + theQuest)
;         elseIf ! not && ! theQuest.IsActive()
;             return SkyUnit.FailExpectation(expectationName, "Expected quest to be active - " + theQuest)
;         endIf
;     else
;         SkyUnit.GetInstance().Log("BeActive() called without ExpectQuest()")
;     endIf
; endFunction

; bool function BeStopped() global
;     string expectationName = ""
;     Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
;     if theQuest
;         bool not = SkyUnit.Not()
;         int currentStage = theQuest.GetStage()
;         if not && theQuest.IsStopped()
;             return SkyUnit.FailExpectation(expectationName, "Expected quest not to be stopped - " + theQuest)
;         elseIf ! not && ! theQuest.IsStopped()
;             return SkyUnit.FailExpectation(expectationName, "Expected quest to be stopped - " + theQuest)
;         endIf
;     else
;         SkyUnit.GetInstance().Log("BeStopped() called without ExpectQuest()")
;     endIf
; endFunction

; bool function BeAtStage(int stageNumber) global
;     string expectationName = "BeAtStage"
;     Quest theQuest = SkyUnit.GetExpectationData_Form("Quest") as Quest
;     bool not = SkyUnit.Not()
;     int currentStage = theQuest.GetStage()
;     if not && (currentStage == stageNumber)
;         return SkyUnit.FailExpectation(expectationName, "Expected quest stage not to be " + stageNumber)
;     elseIf ! not && (currentStage != stageNumber)
;         return SkyUnit.FailExpectation(expectationName, "Expected quest stage to be " + stageNumber + " but was " + currentStage)
;     endIf
; endFunction
