# __Page Object Pattern__

## `Problem`
No POM problem:
- It's hard to unify webdriver time out
- locator are hard to reuse, EX: xpath etc.

<br>
<br>

## `What is Page Object ?`
`Page Object` pattern is a design pattern for test automation.
At the begining, we write our test logic to the test case and seperate from other pages.
Next, each page will collocate with its own locators(xpath, id etc.). And this page will become a independent page object. Then through inheriting base page, letting page object do their own operation.
<br>

| nonPOM   |   POM    |
| :------: | :------: |
|![nonPOM](./picture/nonPom.png) | ![POM](./picture/POM.png)|


### `test case`
![robotTestMethod](./picture/robot1.png)
### `page object`
![robotPO](./picture/robot3.png)<br>
![robotPO](./picture/circuits1.png)

### `Class Diagram`
![UML1](./picture/UML1.png)

| PageObject | ScreenShot |
| :------: |:------: |
| Basepage<br>(BasePage.py)| ![Basepage](./picture/basePage.jpg) |
| CircuitsListPage<br>(CircuitsListPage.py)| ![CircuitsListPage](./picture/CircuitsListPage.jpg)|
| LoginPage<br>(LoginPage.py)| ![LoginPage](./picture/loginPage.jpg)|
| HomePage<br>(HomePage.py)| ![HomePage](./picture/homePage.jpg)|
| RequestPage<br>(request.py)| ![RequestPage](./picture/requestPage.png)|
| Locators<br>(Locators.py)| ![Locators](./picture/locators.png)|


## `Advantage`
- Creating reusable code
- If the user interface changes, the fix needs changes in only one place
- high maintainance



## `Reference`
[selenium-Python](https://selenium-python.readthedocs.io/page-objects.html)<br>
[medium](https://medium.com/drunk-wis/python-selenium-webdriver-page-object-model-design-pattern-%E7%9A%84%E4%B8%80%E4%BA%9B%E6%83%B3%E6%B3%95-6d8cc0e156a6)