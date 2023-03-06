*** Setting ***
Resource    ../../DCTLibrary.txt
Resource    Keywords.txt
Resource    ../../Regression Test/Keywords.txt
Library    dctSeleniumLibrary
Library    Collections
Library    SeleniumLibrary
Suite Setup    Login    &{administrator}

Test Setup    Lazy Setup
Test Teardown    Delete All Custom Fields Via Http Request

Suite Teardown    Logoff

*** Variables ***
@{selectClass} =    Cabinet
&{searchStringsAndResults} =    &{EMPTY}
${specialCharacters1} =    \&?'!“#$%()
${specialCharacters2} =    *+,-./:;<=

*** Test Cases ***
DCT-14883-8-2-0 Delete Custom Field
    [Setup]    Run Keywords    Create Several Custom Fields Which Name Contain Special Characters
    ...        AND             Click Tab    Settings    Field Management
    ...        AND             Field Management::Open Sub-tab    Custom Fields
    ...        AND             Field Management::Create Custom Fields    ${specialCharacters1}
    Field Management::Delete Custom Field    ${specialCharacters1}
    Custom Field Should Be Deleted    ${specialCharacters1}

DCT-14883-8-2-1 Search string with special characters "\&?'!“#$%()"
    Search With The Special Characters "${specialCharacters1}"
    Search Results Should Match Any Part Of Name

DCT-14883-8-2-2 Search string with special characters "*+,-./:;<="
    Search With The Special Characters "${specialCharacters2}"
    Search Results Should Match Any Part Of Name

*** Keywords ***
Lazy Setup
    ${isCustomFieldsExisted} =    Is Custom Fields Existed    ${specialCharacters1}    ${specialCharacters2}
    Run Keyword Unless    ${isCustomFieldsExisted}    Create Several Custom Fields Which Name Contain Special Characters
    ${isItemsListShown} =    Is Items List Page Shown
    Run Keyword Unless    ${isItemsListShown}    Click Tab    Assets    Items List
    ${isShow/HideColumnsMenuShown} =    Is Show/Hide Columns Menu Shown
    Run Keyword Unless    ${isShow/HideColumnsMenuShown}    Items List::Open Show/Hide Columns Menu
    Refresh Show/Hide Columns Menu
    Store Text of All Existing Fields And Its Subclass

Is Show/Hide Columns Menu Shown
    Select Frame    ${assetsFrame}
    ${status} =    Run Keyword And Return Status    Element Should Be Visible    xpath://div[@class='modal-content']//*[contains(@class, 'checkbox')]
    [Teardown]    Unselect Frame
    [Return]    ${status}

Create Several Custom Fields Which Name Contain Special Characters
    Create Custom Field Which Name Contain "${specialCharacters1}"
    Create Custom Field Which Name Contain "${specialCharacters2}"

Is Items List Page Shown
    ${status} =    Run Keyword And Return Status    Items List::Wait Until Items List Page Is Visible
    [Return]    ${status}

Is Custom Fields Existed
    [Arguments]    @{customFields}
    :FOR    ${customField}    IN    @{customFields}
    \    ${status} =    Run Keyword And Return Status    Element Should Be Visible    locator
    \    Return From Keyword If    not ${status}    ${False}
    [Return]    ${True}

Create Custom Field Which Name Contain ${specialCharacters}
    Create Custom Field Via Http Request    Custom field with special characters: ${specialCharacters}    ${selectClass}    Text

Search With The Special Characters "${specialCharacters}"
    Search With "${specialCharacters}"

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