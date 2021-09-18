scriptName SkyUnitTests_Assertions_Generic extends SkyUnitAssertionTestBase
{Tests for generic assertions which work for various types, e.g. `ContainsText("")`}

function Tests()
    Test("ContainText")
    Test("HaveLength")
    Test("BeTrue")
    Test("BeFalse")
endFunction
