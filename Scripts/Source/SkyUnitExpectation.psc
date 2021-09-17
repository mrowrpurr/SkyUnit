scriptName SkyUnitExpectation hidden
{Global functions used for implementing custom expectations.
This script is also used for implementing all built-in SkyUnit expectations.

Example Custom Expectation:

```
;TODO
```

Example Custom Assertion:

```
;TODO
```
}

function Begin(string expectationName = "") global
endFunction

function Fail(string failureMessage = "") global
endFunction

function Pass(string passMessage = "") global
endFunction

function SetDataType(string type, int expectationId = 0) global
endFunction

string function GetDataType(int expectationId = 0) global
endFunction

function SetString(string dataKey, string value, int expectationId = 0) global
    if ! expectationId
        
    endIf
endFunction

string function GetString(string dataKey, int expectationId = 0) global
endFunction
