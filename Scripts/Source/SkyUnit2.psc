scriptName SkyUnit2 extends Quest
{Global interface for integrating with SkyUnit.

For writing tests, please see SkyUnitTest.

To access functionality, use SkyUnit.DefaultTestSuite()
which will give you back a SkyUnit test suite instance with all
of the lovely functions you want for interacting with test suites!

Note: there can be multiple SkyUnit test suites at the same
time. Each stores its own test suite, e.g. SkyUniTest scripts etc.
To get an existing or new instance, see these functions:

  SkyUnit testSuite = SkyUnit.NewTestSuite("<name your test suite>")
  SkyUnit testSuite = SkyUnit.GetTestSuite("<name of test suite>")
}

