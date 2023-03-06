*** Setting ***
Resource    ../../DCTLibrary.txt
Resource    Keywords.txt
Resource    ../../Regression Test/Keywords.txt
Library    dctSeleniumLibrary
Library    Collections

Suite Setup    Create Custom Field Which Name Contain "${specialCharacters2}"

Test Setup    Run Keywords    On The Items List Page
...           AND             Create Custom Field Which Name Contain "${specialCharacters1}"
...           AND             Items List::Open Show/Hide Columns Menu
...           AND             Refresh Show/Hide Columns Menu
...           AND             Store Text of All Existing Fields And Its Subclass
Test Teardown    Run Keywords    Delete All Custom Fields Via Http Request
...              AND             Logoff

*** Variables ***
@{selectClass} =    Cabinet
&{searchStringsAndResults} =    &{EMPTY}
${specialCharacters1} =    \&?'!“#$%()
${specialCharacters2} =    *+,-./:;<=

*** Test Cases ***
DCT-14883-8-2-0 Delete Custom Field
    [Setup]    Run Keywords    Create Custom Field Which Name Contain "${specialCharacters1}"
    ...        AND             On The Field Management Page
    ...        AND             Field Management::Open Sub-tab    Custom Fields
    Field Management::Delete Custom Field    ${specialCharacters1}
    Custom Field Should Be Deleted    ${specialCharacters1}

DCT-14883-8-2-1 Search string with special characters "\&?'!“#$%()"
    Search With The Special Characters "${specialCharacters1}"
    Search Results Should Match Any Part Of Name

DCT-14883-8-2-2 Search string with special characters "*+,-./:;<="
    Search With The Special Characters "${specialCharacters2}"
    Search Results Should Match Any Part Of Name

*** Keywords ***
Create Custom Field Which Name Contain ${specialCharacters}
    Create Custom Field Via Http Request    Custom field with special characters: ${specialCharacters}    ${selectClass}    Text

Search With The Special Characters "${specialCharacters}"
    Search With "${specialCharacters}"

Create Several Custom Fields Which Name Contain Special Characters
    Create Custom Field Which Name Contain "${specialCharacters1}"
    Create Custom Field Which Name Contain "${specialCharacters2}"

Custom Field Should Be Deleted
    [Arguments]    ${customField}
    Field Management::Wait Until Custom Field Deleted    ${customField}

On The dcTrack Settings Page
    [Documentation]
    ...    Open browser and login dcTrack (default: _admin_) and enter the dctrack setting page.
    ...
    ...    Usage:
    ...    | On The dcTrack Settings Page |
    ...
    ...    Usage:
    ...    | On The dcTrack Settings Page | name=operator | password=Operator1!!! |
    [Arguments]    ${user}=${EMPTY}
    Run Keyword If    "${user}" != "${EMPTY}"    Login    &{user}
    ...    ELSE    Login    &{administrator}
    # FIXME retry
    Run Keyword If    "${user}" != "${EMPTY}"    Re-Login If Dashahboard Is Not Visible    times=3    &{user}
    ...       ELSE    Re-Login If Dashahboard Is Not Visible    times=3   &{administrator}
    Click Tab    Settings    dcTrack Settings