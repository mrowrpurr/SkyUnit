scriptName SkyUnit2VersionManager extends ReferenceAlias  
{Private Version Management API for SkyUnit.

DO NOT USE.

This script is used to support OnPlayerLoadGame() events
and upgrade SkyUnit to newly released versions.
}

; Load Game Event Handler
;
; Currently simply delegates this event to the private API
event OnPlayerLoadGame()
    SkyUnit2PrivateAPI.GetPrivateAPI().OnPlayerLoadGame()
endEvent
