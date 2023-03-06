*** Settings ***
Library    RemoteTestLibrary
Library    SeleniumLibrary
Resource    keywords/assets.txt
Library    dctSeleniumLibrary

*** Variables ***
${admin_password} =    sunbird
&{administrator} =    name=admin    password=${admin_password}

*** Test Cases ***
Remote Driver Test
    Open Google At Remote Side Using Chrome
    Google Page Should Be Shown At Remote Side    //*[@class='ctr-p']
    [Teardown]    Close Remote Side Browser

Remote Driver Test For TMD-2561
    [Setup]    Run Keywords    Login At Remote Side
    ...                 AND    Click Tab    Assets

    Items List::Filter Items By Name    clar
    Items List::Wait Until Items List Is Updated
    All Data In Column Should Contain Text    Name    clar

    [Teardown]    Run Keywords    Logoff
    ...                    AND    Close Browser

*** Keywords ***
Login At Remote Side
    Open dcTrack At Remote Side Using Chrome
    Maximize Browser Window
    Enter Account For Logging In DcTrack    &{administrator}[name]    &{administrator}[password]
