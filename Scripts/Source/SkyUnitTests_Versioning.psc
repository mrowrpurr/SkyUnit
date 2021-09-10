scriptName SkyUnitTests_Versioning extends SkyUnitTests_BaseTest
{Tests for upgrading SkyUnit etc

To start with, this simply verifies users can get the current version

When new versions come out, this test will test upgrading to/from various versions}

function Tests()
    Test("Can get current version of SkyUnit").Fn(GetCurrentVersion_Test())
endFunction

function GetCurrentVersion_Test()
    ExpectFloat(SkyUnit2.GetVersion()).To(EqualFloat(1.0))
endFunction
