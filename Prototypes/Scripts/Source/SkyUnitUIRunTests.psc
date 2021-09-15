scriptName SkyUnitUIRunTests extends ActiveMagicEffect  
{Spell effect which opens up the test script chooser menu}

event OnEffectStart(Actor target, Actor caster)
    SkyUnitUI.GetInstance().ShowTestChooser()
endEvent