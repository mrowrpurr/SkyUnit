scriptName SkyUnitTests_TrackingScripts extends SkyUnitTest
{Tests for registering and tracking SkyUnitTest scripts}

function Tests()
    Test("Can register test scripts")
    Test("Different instances of SkyUnit have different sets of test scripts")
    Test("Can get a SkyUnit instance's script by name")
    Test("Can get the names of all test scripts in a SkyUnit instance")
    Test("Can clear an instance's list of scripts")
    Test("Can register over a thousand test scripts")
endFunction

function CanRegisterTestScripts()
endFunction
