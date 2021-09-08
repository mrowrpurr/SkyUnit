scriptName SkyUnitVersionManager extends ReferenceAlias  
{Handles OnPlayerLoadGame and OnInit mod installation events for SkyUnit}

float property CurrentlyInstalledVersion auto

event OnInit()
    CurrentlyInstalledVersion = 1.0
endEvent
