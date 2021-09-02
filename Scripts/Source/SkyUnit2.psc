scriptName SkyUnit2
{Global interface for integrating with SkyUnit.

For writing tests, please see SkyUnitTest.

To access functionality, use SkyUnit.DefaultTestSuite()
which will give you back a SkyUnit test suite instance with all
of the lovely functions you want for interacting with test suites!

Note: there can be multiple SkyUnit test suites at the same
time. Each stores its own test suite, e.g. SkyUniTest scripts etc.
To get an existing or new instance, see these functions:

  SkyUnitTestSuite testSuite = SkyUnit.CreateTestSuite("<name your test suite>")
  SkyUnitTestSuite testSuite = SkyUnit.GetTestSuite("<name of test suite>")
}

float function GetVersion() global
  return 1.0
endFunction

string[] function TestSuiteNames() global
  SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
  return JMap.allKeysPArray(api.TestSuitesMap)
endFunction

SkyUnit2TestSuite function CreateTestSuite(string name) global
  SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
  int suite = api.CreateTestSuite(name)
  return SkyUnit2TestSuite.GetForID(suite)
endFunction

SkyUnit2TestSuite function GetTestSuite(string name) global
  SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
  int suite = api.GetTestSuite(name)
  return SkyUnit2TestSuite.GetForID(suite)
endFunction

function DeleteTestSuite(string name) global
  SkyUnit2PrivateAPI api = SkyUnit2PrivateAPI.GetPrivateAPI()
  api.DeleteTestSuite(name)
endFunction
