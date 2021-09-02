scriptName SkyUnit2PrivateAPI extends Quest hidden
{Private API for SkyUnit.

DO NOT USE.

This includes all of the things which make SkyUnit work!

Data storage and persistence is managed via the SkyUnitPrivateAPI.

If you need to integrate with SkyUnit, please use the SkyUnit script
which provides a stable, documented API for working with SkyUnit.

The internals of SkyUnitPrivateAPI *may change at any time*.
}

SkyUnit2PrivateAPI function GetPrivateAPI() global
    return Game.GetFormFromFile(0x800, "SkyUnit2.esp") as SkyUnit2PrivateAPI
endFunction
