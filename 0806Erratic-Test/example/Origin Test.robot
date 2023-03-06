*** Setting ***
Resource    ../../DCTLibrary.txt
Resource    Keywords.txt
Resource    ../../Regression Test/Keywords.txt
Library    dctSeleniumLibrary
Library    Collections

Suite Setup    Run Keywords    On The Items List Page
...            AND             Create Several Custom Fields Which Name Contain Special Characters
...            AND             Items List::Open Show/Hide Columns Menu
...            AND             Refresh Show/Hide Columns Menu
...            AND             Store Text of All Existing Fields And Its Subclass
Suite Teardown    Run Keywords    Delete All Custom Fields Via Http Request
...               AND             Logoff

*** Variables ***
@{selectClass} =    Cabinet
&{searchStringsAndResults} =    &{EMPTY}
${specialCharacters1} =    \&?'!“#$%()
${specialCharacters2} =    *+,-./:;<=

*** Test Cases ***
DCT-14883-8-2-1 Search string with special characters "\&?'!“#$%()"
    Search With The Special Characters "${specialCharacters1}"
    Search Results Should Match Any Part Of Name

DCT-14883-8-2-2 Search string with special characters "*+,-./:;<="
    Search With The Special Characters "${specialCharacters2}"
    Search Results Should Match Any Part Of Name

*** Keywords ***
Create Custom Field Which Name Contain ${specialCharacters}
    Create Custom Field Via Http Request    ${specialCharacters}    ${selectClass}    Text

Search With The Special Characters "${specialCharacters}"
    Search With "${specialCharacters}"

Create Several Custom Fields Which Name Contain Special Characters
    Create Custom Field Which Name Contain "${specialCharacters1}"
    Create Custom Field Which Name Contain "${specialCharacters2}"