scriptName SkyUnitTests_TestSuites extends SkyUnitTests_BaseTest
{Tests for managing SkyUnit test suites}

import ArrayAssertions

; Note: we cannot test resetting *all* test suites
;       via the SkyUnit tests because it would
;       also clear the SkyUnit tests for SkyUnit!
;
; There may be numberous test suites active at the time of this test
; so we just do a really minimal check to see that we can add
; and remove a simple test suite by name.
;
; See other tests for more in-depth testing, e.g. TrackingScripts

function Tests()
    Test("Can add a test suite").Fn(CanAddTestSuite_Test())
    Test("Can remove a test suite").Fn(CanRemoveTestSuiteByName_Test())
endFunction

function CanAddTestSuite_Test()
    string suiteName = "CoolTestSuite"
    ExpectStringArray(SkyUnit2.GetTestSuiteNames()).Not().To(ContainString(suiteName))

    SkyUnit2.CreateTestSuite(suiteName)

    ExpectStringArray(SkyUnit2.GetTestSuiteNames()).To(ContainString(suiteName))
endFunction

function CanRemoveTestSuiteByName_Test()
    string suiteName = "CoolTestSuite"
    SkyUnit2.CreateTestSuite(suiteName)
    ExpectStringArray(SkyUnit2.GetTestSuiteNames()).To(ContainString(suiteName))

    SkyUnit2.DeleteTestSuite(suiteName)

    ExpectStringArray(SkyUnit2.GetTestSuiteNames()).Not().To(ContainString(suiteName))
endFunction
