scriptName StringAssertions hidden
{SkyUnit test assertions for Strings}

function ContainText(string text) global
    string actual = SkyUnit.GetExpectationObjectString()
    bool not = SkyUnit.Not()
    if not && StringUtil.Find(actual, text) > -1
        SkyUnit.FailExpectation("Expected string '" + actual + "' not to contain text '" + text + "'")
    elseIf ! not && StringUtil.Find(actual, text) == -1
        SkyUnit.FailExpectation("Expected string '" + actual + "'s to contain text '" + text + "'")
    endIf
endFunction
