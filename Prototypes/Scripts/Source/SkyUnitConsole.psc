scriptName SkyUnitConsole hidden
{Skyrim ~ console integration for SkyUnit to print to the console

*Compiling this script* requires a few libraries.

*Executing this script* requires zero libraries
(but nothing will happen if none of the supported libraries are available)}

function Print(string text) global
    ; TODO
    ; ...
    ; Right now, let's just use PapyrusUtil:
    MiscUtil.PrintConsole(text)
endFunction