scriptName SkyUnitUI extends ReferenceAlias
{Main script for the UI of SkyUnit}

; Returns the instance of the SkyUnitUI script
SkyUnitUI function GetInstance() global
    Quest skyUnitQuest = Game.GetFormFromFile(0x806, "SkyUnit.esp") as Quest
    return skyUnitQuest.GetAliasByName("PlayerRef") as SkyUnitUI
endFunction