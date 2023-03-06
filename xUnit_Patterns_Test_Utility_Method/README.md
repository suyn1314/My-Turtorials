# **Test Utility Method**

### Introduction

We encapsulate the test logic we want to reuse behind a suitably named utility method.

<img src = "pictures/Test Utility Method.gif">

### When To Use It

We should use a `Test Utility Method` whenever test logic appears in several tests and we want to be able to reuse it.

## Verification Method

Assertion that interact directly with the `system under test (SUT)` thus relieving their callers from this task.

## Custom Assertion

Create a purpose-built `Assertion Method` that compares only those attributes of the object that define test-specific equality.
The key difference between this and a `Verification Method` is that the latter interacts with the SUT.

<img src = "pictures/Custom Assertion.gif">

### When To Use It

We should consider creating a `Custom Assertion` whenever any of the following are true:

* `Test Code Duplication` : The same assertion logic in test after test.
* `Conditional Test Logic` : Calls to `Assertion Methods` are embedded in _if_ statements or loops.
* `Obscure TestUsing` : Using `procedural` rather than `declarative` result verification.
* `Frequent Debugging` : Do not provide enough information.

### Custom Equality Assertion

The `Custom Assertions` must be passed an `Expected` Object and the `Actual` object to be verified. I

### Object Attribute Equality Assertion

Take one `Actual` object and several different `Expected` Objects that need to be compared with specific attributes of the actual object.

### Domain Assertion

A `Domain Assertion` is a `Stated Outcome Assertion` that states something that should be true in domain-specific terms.

## Example

### Test Case 1

```
Function to edit Item Name
    Go To Capacity
    Set Cabinet Conditions For Search    specifyBy=Model    make=911 Enable    model=EGW    quantityPerCabinet=2
    Place All Items To Cabinet    itemName=3F
    @{cabinetItems} =    Capacity::Get Item Names From Edit Item Names Modal
    Items Should Exist On Items List Page    @{cabinetItems}
    Go To Capacity
    Color Of Cell Should Be Red With Duplicate Item Name
    Color Of Cell Should Be Green With Unique Item Name
```

### Exercising Verification Method

```
Color Of Cell Should Be Green With Unique Item Name
    Capacity::Rename Item By Index    index=1    newName=UNIQUENAME14933-1
    Capacity::Cell Color Of Item Name Should Be Green    index=1
    Capacity::Rename Item By Index    index=2    newName=UNIQUENAME14933-2
    Capacity::Cell Color Of Item Name Should Be Green    index=2

Color Of Cell Should Be Red With Duplicate Item Name
    Capacity::Rename Item By Index    index=1    newName=DUPLICATENAME14933
    Capacity::Cell Color Of Item Name Should Be Red    index=1
    Capacity::Rename Item By Index    index=2    newName=DUPLICATENAME14933
    Capacity::Cell Color Of Item Name Should Be Red    index=2
```

### Domain Assertion

```
Capacity::Cell Color Of Item Name Should Be Green
    [Arguments]    ${index}
    Select Frame    ${capacityFrame}
    ${itemNameColumnId} =    Get Column Id By Column Name    Item name
    Wait Until Element Is Not Visible    xpath:(//*[@id='idModalDataPort']//*[contains(@class, 'ui-grid-row')]//*[contains(@class, '${itemNameColumnId}')]//div)[${index}][contains(@class, 'alert-danger')]    timeout=${shortPeriodOfTime}    error=Color of cell should be green.
    ${cellColor} =    Get Computed Style Of Element    xpath:(//*[@id='idModalDataPort']//*[contains(@class, 'ui-grid-row')]//*[contains(@class, '${itemNameColumnId}')]//div)[${index}]    color
    Should Be Equal    ${cellColor}    rgb(60, 118, 61)
    [Teardown]    Unselect Frame

Capacity::Cell Color Of Item Name Should Be Red
    [Arguments]    ${index}
    Select Frame    ${capacityFrame}
    ${itemNameColumnId} =    Get Column Id By Column Name    Item name
    Wait Until Element Is Visible    xpath:(//*[@id='idModalDataPort']//*[contains(@class, 'ui-grid-row')]//*[contains(@class, '${itemNameColumnId}')]//div)[${index}][contains(@class, 'alert-danger')]    timeout=${shortPeriodOfTime}    error=Color of cell should be red.
    ${cellColor} =    Get Computed Style Of Element    xpath:(//*[@id='idModalDataPort']//*[contains(@class, 'ui-grid-row')]//*[contains(@class, '${itemNameColumnId}')]//div)[${index}]    color
    Should Be Equal    ${cellColor}    rgb(169, 68, 66)
    [Teardown]    Unselect Frame
```
## Conclusion

By pulling out all the common calls to `Assertion Methods` we will be left with only the differences in each test.
The tests will become significantly smaller and more intent revealing. 

## Reference

xUnit Patterns : http://xunitpatterns.com/Test%20Utility%20Method.html