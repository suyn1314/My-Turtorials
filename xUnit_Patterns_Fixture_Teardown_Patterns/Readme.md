# Fixture Teardown Patterns

Today we are going to introduce 3 xUnit teardown patterns, and their uses in Robotframework.

## 1. Automated Teardown

![Photo](pictures/Automated%20Teardown.gif) 

### Introduce
`Automated Teardown` is activated when all test cases are finished, or when 

they failed because of some runtime errors.

### When To Use It
Whenever we have some persistent resources that need to be cleaned up to keep the test

environment functioning.

Also, this pattern ensures `Unrepeatable Test` and `Interacting Tests` by keeping objects

created in one test from lingering on into the execution of a subsequent test.

### Example Code

Note: Automated Teardown pattern often implements as "Suite Teardown" in robot-framework.

```
*** Setting ***
//Setup
Suite Setup    Run Keywords    Add A User With Roles    ${gatekeeper15373}    Gatekeeper
//Teardown
Suite Teardown    Run Keywords    Delete User    &{gatekeeper15373}[name]
...                        AND    On The Items List Page
...                        AND    Items List::Delete Views    viewAdmin
...                        AND    Close All Browsers
```

``` 
*** Test Cases ***
//Test Case 1:
Role Based Access Control For Shared View  
    On The Items List Page
    Items List::Filter Items By Name    APP
    Items List::Items Should Exist    @{expectedViewAdmin}
    Items List::Create Shared View    viewName=viewAdmin
    Other User Should Be Able To See Shared Views    ${gatekeeper15373}    viewAdmin

//Test Case 2:
Role Based Access Control For Item
    Relogin To dcTrack Settings Page
    Remove Role From Users
    Go To Items List Page
    Items List::Go To View    viewClass=My Views    name=viewAdmin
    Items List::Items Should Exist    NETAPP CONTROLLER 209U39    
    Items List::Set Permission Of Item With User Name And Role    itemName=NETAPP CONTROLLER 209U39    userName=&{gatekeeper15373}[name]    role=Gatekeeper
    Items List Should Be Default Page After Relogin    user=${gatekeeper15373}
    Items List::Go To View    viewClass=Shared Views    name=viewAdmin
    Items List::Items Should Exist    NETAPP CONTROLLER 209U39
    Items List::Items Should Not Exist    NETAPP CONTROLLER 209U42    NETAPP CONTROLLER 210U39    NETAPP CONTROLLER 210U42

//Test case 3:
Role Based Access Control For Location
    Relogin To Locations Page
    Locations::Set Permission Of Location With User Name And Role    SITE A    &{gatekeeper15373}[name]    Gatekeeper
    Relogin To Locations Page    ${gatekeeper15373}
    Locations::Full Code Path Should Exist    SITE A
```

## 2. Inline Teardown

![Photo](pictures/Inline%20Teardown.gif) 

### Introduce
We execute `Inline Teardown` at the end of each Test Case immediately after the result verification.

### When To Use It
Whenever we have some dependency with other test cases, and we need to 

revert the test data to ensure that they won't affect each other.

We may discover that objects need to be cleaned up because we have `Unrepeatable Tests` or `Slow Tests` 

caused by the accumulation of detritus from many test runs.

### Example Code

Note: Inline Teardown pattern often implements as "teardown inside test cases" in robot-framework.

```
*** Test Cases ***
// Test case 1
Add a new item whose class is "DC Power System" and subclass is "Plant Panel"
    [Tags]    TMD-17289
    Go To Items List Page
    Items List::Create DC Power System Item    name=${plantItem}    make=${make}    model=${plantModel}
    Item Detail::Open Sub-tab    Rectifiers
    Item Detail::Create Rectifier    make=${make}    model=${rectifierModel}    rectifierName=${rectifierPrefix}
    Item Detail::Click Save Button
    Item Detail::Open Sub-tab    Plant Panels
    Item Detail::Create Plant Panel    panelName=${plantPanelItem}    poles=50    rating=40
    Items List::Close Tab
    Items List::Open An Item With View Mode    itemName=${plantPanelItem}
    Item Detail::Class/Subclass Should Be    class/subclass=DC Power System / Plant Panel
    [Teardown]    Run Keywords    Items List::Close Tab
    ...                    AND    Items List::Delete Items    ${plantPanelItem}    ${rectifierItemWithPrefix}    ${plantItem}

// Test case 2
Verify Items List "Subclass" filter supports "DC Power System" item
    [Tags]    TMD-17292
    [Setup]    Add DC Power System Items
    Subclass Dropdown Options Should Contain DC Power System Subclasses
    DC Power System Items Should Be Able To Be Filtered    Plant
    DC Power System Items Should Be Able To Be Filtered    Plant Bay
    DC Power System Items Should Be Able To Be Filtered    Plant Panel
    DC Power System Items Should Be Able To Be Filtered    Rectifier
    [Teardown]    Items List::Delete Items    ${plantPanelItem}    ${rectifierItemWithPrefix}    ${plantItem}    ${plantBayItem}
```

## 3. Implicit Teardown

![Photo](pictures/Implicit%20Teardown.gif) 

### Introduce
`Implicit Teardown` will be executed after every test case finishes.

### When To Use It
Whenever we have some dependency with other test cases, and we need to 

revert the test data to ensure that they won't affect each other.

In addition, the teardown of each test case does the same thing.

We may discover this because we have `Unrepeatable Tests`or `Slow Tests` caused by

the accumulation of detritus from many test runs.

### Example Code

Note: Implicit Teardown pattern often implements as "Test Teardown" in robot-framework.

```
*** Setting ***
//Test template
Test Template    Data Port Can Be Deleted From The Grid By Different Browsers
//Teardown
Test Teardown    Logoff
```

```
*** Test Cases ***
//Test case 1 
Deleting data ports should work in chrome browser    chrome
//Test case 2
Deleting data ports should work in firefox browser    firefox

*** Keywords ***
//Keyword
Data Port Can Be Deleted From The Grid By Different Browsers
    [Arguments]    ${desiredBrowser}
    ${browser} =    Set Variable    ${desiredBrowser}
    Set Test Variable    ${browser}
    On The Models Library Page
    Models Library::Open An Model With Edit Mode    modelName=00FW789
    Model Detail::Open Sub-tab    Data Ports
    Create A Data Port For Test
    Model Detail::Data Ports::Delete All Ports
    Model Detail::Click Save Button
    Model Detail::Click Refresh Button
    Model Detail::Data Ports::Ports Should Not Exist In List    TMD3862-DATAPORT01
```

## Comparison
comparison of these teardown patterns:

|          | Automated Teardown                             | Inline Teardown                                              | Implicit Teardown                               |
| -------- | ---------------------------------------------- | ------------------------------------------------------------ | ----------------------------------------------- |
| 使用時機 | 要在所有test case完成後復原資料狀態            | 在個別test case完成後立即復原資料狀態，才進行下一個test case | 每個test case完成後都要做teardown，且步驟皆相同 |
| 優點     | 1. easy to build<br>2. reuse for little effort | flexible                                                     | less cost than Inline Teardown                  |
| 缺點     | test cases have dependency due to the same fixture | more cost to write code                                      | each test case must run the same teardown       |

## Conclusion 
We can use the `Automated Teardown`, `Inline Teardown`, `Implicit Teardown` patterns in

our robot-framework project to solve problems caused from "Unrepeatable Test", "Interacting Tests",

and "Slow Test".

## Reference
http://xunitpatterns.com/Fixture%20Teardown%20Patterns.html