# **Suggested Robot Framework coding style**

### Introduction


*  Most important guideline is keeping test cases as easy to understand as possible for people familiar with the domain.

    *  This typically also eases maintenance.

# Naming

## Test case names

*   Case names should be as descriptive as possible.
    *  Example
    ```
    *** Test Cases ***
    Columns With Text Should Be Filtered Correctly For Sessions Without Data Rates And Models
    [Template]    Columns With Text For Sessions Without Data Rates And Models Should Be Filtered Correctly
    Data Connectors    Connector    test RJ11    RJ11
    Power Connectors    Connector    test BS1363    BS1363
    Protocols    Protocol    test FCoE    FCoE
    Breakers & Fuses    Breaker/Fuse    test CB01    CB01
    Makes    Make    test 3Com    3Com
    ```
*   Name is exactly the same as you specified in the test case file without any conversion.

    For example, if we have tests related to filter by class in a file TMD-15733 Filter by class.robot, these would be OK test case names:
    ```
    *** Test Cases ***
        [Template]  Custom Fields List's Class Filter Should Work
        Cabinet
        CRAC
        Data Panel
        Device
        Floor PDU
        Network
        Power Outlet
        Probe
        Rack PDU
        UPS
    ```
    These names are too long:
    ```
    *** Test Cases ***
        Custom Fields List's Cabinet Class Filter Should Work
        Custom Fields List's CRAC Class Filter Should Work
        Custom Fields List's Device Panel Class Filter Should Work
        Custom Fields List's Floor PDU Class Filter Should Work
        Custom Fields List's Network Class Filter Should Work
        Custom Fields List's Power Outlet Class Filter Should Work
        Custom Fields List's Probe Class Filter Should Work
        Custom Fields List's Rack PDU Class Filter Should Work
        Custom Fields List's UPS Class Filter Should Work
    ```

## Keyword names

*  Keyword names should be readable and clear.
*  Keywrod names should explain what the keyword does,not how it does.
    *  Example

    Good:
    ```
    Model Detail::Click Save Button
    ```
    Bad:
    ```
    Model Detail::Save Button Should Be Enable  And Click Save Button 
    ```
*  There isn't clear guideline on whether a keyword should be fully title cased or have only the first letter be uppercase.
    *  Title casing is often used when the keyword name is short.(example:`Click Button`)
    *  Only first letter is uppercase that works better with keywords that are like sentences(example:`Administrator logs into system`).
        *  These type of keywords are often higher level.
    *  Example

    Good:
    ```
    Model Detail::Close Tab
    Capacity::Wait until all cells of column contain
    ```
    Bad:
    ```
    Model Detail::Close tab
    Capacity::Wait Until All Cells Of Column Contain
    ```

## Naming setup and teardown
*  Try to use name that describes what is done.
    *  Possibly use an existing keyword.
*   More abstract names are acceptable if a setup or teardown contains unrelated steps.
    *   Often better to use something generic(example:`Prepare system`).
*   Using keyword `Run Keywords` can work well if keywords implementing lower level steps already exist.
    *   Example
    
    Good:
    ```
    Suite Teardown    Run Keywords    Models Library::Close Models Library Update Process
    ...                        AND    Logoff

    ```
    Bad:
    ```
    *** Settings ***
    Suite Teardown     Models Library::Close Models Library Update Process, Logoff
    ```

# Documentation

## User keyword documentation

*   Not needed if keyword is relatively simple.
    *   Good keyword, argument names and clear structure should be enough.
*   Important usage is documenting arguments and return values.
    *   Example
    ```
    Models Library::All Items Flag Should Be As Expected
    [Documentation]
    ...    The expected flag of all items should be Ok, Warning, or Error.
    ...
    ...    Example:
    ...    | Models Library::All Items Flag Should Be As Expected | Error |
    ...    | Models Library::All Items Flag Should Be As Expected | Warning |
    [Arguments]    ${flagValue}
    ```

# Variables

## Variable naming

*   Name should be clear but not too long.
*   Use case consistently:
    *   Lower case with local variables only available inside a certain scope.
        *   Example

        Good:
        ```
        Models Library::Choose File
        ${input_file} =    Set Variable    //*[@id='raritan-file-input' and @type='file']
        ```
        Bad:
        ```
        Models Library::Choose File
        ${inputFile} =    Set Variable    //*[@id='raritan-file-input' and @type='file']
        ```
    *   Upper case with others(global, suite or test level).
        *   Example

        Good:
        ```
        *** Variables ***
        ${ASSETS FRAME} =    xpath://iframe[@id='id_assets_frame']
        ```
        Bad:
        ```
        *** Variables ***
        ${assetsFrame} =    xpath://iframe[@id='id_assets_frame']
        ```
    *   Both space and underscore can be used as a word separator.


## Avoid sleeping

*   Sleeping is a very fragile way to synchronize tests.
*   Instead of sleeps, use keyword that polls has a certain action occurred.
    *   often using `wait until ...` to instead sleeping.
        *   Example
        ```
        Capacity::No Matching Result Message Should Be Shown
        Select Frame    ${capacityFrame}
        ${noMatchingResultMessage} =    Set Variable    //*[contains(@class, 'capacity-report-empty')]//*[normalize-space()='No cabinets were found maching ALL specified criteria.']
        Wait Until Page Contains Element    ${noMatchingResultMessage}    timeout=${normalPeriodOfTime}   error=No matching result message should be shown.
        Wait Until Element Is Visible    ${noMatchingResultMessage}    timeout=${normalPeriodOfTime}   error=No matching result message should be shown.
        [Teardown]    Unselect Frame
        ```

## Reference

[How to write good test cases using Robot Framework](https://github.com/robotframework/HowToWriteGoodTestCases/blob/master/HowToWriteGoodTestCases.rst#naming)

[Robot Framework Dos And Don'ts](https://www.slideshare.net/pekkaklarck/robot-framework-dos-and-donts)