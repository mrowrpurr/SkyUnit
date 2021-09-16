scriptName SkyUnitTestRunner extends ActiveMagicEffect  
{This runs when the player casts the spell (Shout) to run SkyUnit tests.
It displays a list of all available tests to be run.}

event OnEffectStart(Actor target, Actor caster)
    SkyUnitAPI.ShowUI()
endEvent
