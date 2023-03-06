## Page Object Library For Robot Framework

### What is Page Object Library
***
PageObjectLibrary is a lightweight Robot Framework keyword library that makes it possible to use the Page Object pattern.

### Example
***
#### A Typical Test Without Page Objects
```robotframework=
*** Test Cases ***
| Login with valid credentials
| | Go to | ${ROOT}/Login.html
| | Wait for page to contain | id=id_username
| | Input text | id=id_username | ${USERNAME}
| | Input text | id=id_password | ${PASSWORD}
| | Click button | id=id_form_submit
| | Wait for page to contain | Your Dashboard
| | Location should be | ${ROOT}/dashboard.html
```
#### The Same Test, Using Page Objects
```robotframework=
*** Test Cases ***
| Login with valid credentials
| | Go to page | LoginPage
| | Login as a normal user
| | The current page should be | DashboardPage
```
### Class Diagram
***
![](https://i.imgur.com/TzvipPp.jpg)


### Page Object Library Source Code
***

#### Reference
Page Object Library: https://github.com/boakley/robotframework-pageobjectlibrary

