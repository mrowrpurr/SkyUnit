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
    Test("Can get a test suite by name").Fn(CanGetTestSuiteByName_Test())
    Test("Can remove a test suite").Fn(CanRemoveTestSuiteByName_Test())
endFunction

function CanAddTestSuite_Test()
    string suiteName = "CoolTestSuite"
    ExpectStringArray(SkyUnit2.TestSuiteNames()).Not().To(ContainString(suiteName))

    SkyUnit2TestSuite testSuite = SkyUnit2.CreateTestSuite(suiteName)

    ExpectString(testSuite.GetSuiteName()).To(EqualString(suiteName))
    ExpectInt(testSuite.GetSuiteID()).To(BeGreaterThan(0))
    ExpectStringArray(SkyUnit2.TestSuiteNames()).To(ContainString(suiteName))
endFunction

function CanGetTestSuiteByName_Test()
    string suiteName = "CoolTestSuite"
    SkyUnit2TestSuite testSuite = SkyUnit2.GetTestSuite(suiteName)

    SkyUnit2.CreateTestSuite(suiteName)

    testSuite = SkyUnit2.GetTestSuite(suiteName)
    ExpectString(testSuite.GetSuiteName()).To(EqualString(suiteName))
    ExpectStringArray(SkyUnit2.TestSuiteNames()).To(ContainString(suiteName))
endFunction

function CanRemoveTestSuiteByName_Test()
    string suiteName = "CoolTestSuite"
    SkyUnit2.CreateTestSuite(suiteName)
    SkyUnit2TestSuite testSuite = SkyUnit2.GetTestSuite(suiteName)
    ExpectString(testSuite.GetSuiteName()).To(EqualString(suiteName))
    ExpectStringArray(SkyUnit2.TestSuiteNames()).To(ContainString(suiteName))

    SkyUnit2.DeleteTestSuite(suiteName)

    ExpectStringArray(SkyUnit2.TestSuiteNames()).Not().To(ContainString(suiteName))
endFunction
