## Selenium Grid

### Selenium Info

Selenium 是一個瀏覽器自動化的套件 (Package) ，可以利用 Python 撰寫自動化的腳本來執行各種的網站，包含開啟瀏覽器、填寫表單、點擊按鈕及取得網站內容等。

- Selenium IDE
- Selenium Webdriver
    使用不同的瀏覽器進行測試，需要相對應得 Browser Drivers
    * Microsoft Edge : Microsoft Edge Driver/Microsoft WebDriver
    * Google Chrome : chromedriver
    * Internet Explorer 11 : IEDriverServer
    * Mozilla Firefox : geckodriver
    * Opera : operachromiumdriver
    * Safari : safaridriver
- Selenium Grid

### Robot Framework with Selenium and Python with Selenium
![](https://i.imgur.com/Vzb7hno.png)

Python
```python=
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import time
 
options = Options()
options.add_argument("--disable-notifications")
 
chrome = webdriver.Chrome('./chromedriver')
chrome.get("https://www.facebook.com/")
```
Robot Framework
```python=
*** Settings ***
Library           SeleniumLibrary
 
*** Variables ***
${URL}    https://www.facebook.com/

*** Test Cases ***
Open Facebook
    Open Browser    ${URL}    chrome
```

---

## Selenium Grid

Selenium Grid 是 Selenium 專門用於在不同瀏覽器、作業系統和機器上並行執行的元件。使用 hub-nodes 的結構，可以在 hub 上啟動測試，不過測試則會在不同的機器 node 上執行。

![](https://i.imgur.com/QmZKtSh.png)

* Hub
    - 所有測試的中央入口點
    - 每一個 Selenium Grid 僅由一個 hub 組成。
    - 該 hub 需要可以從相對應的客戶端(Client)啟動。
    - 該 hub 將連接一個或是多個 nodes 進行委託測試。
* Nodes
    - 管理和控制瀏覽器所執行的環境
    - 並行執行測試
    - 跨平台測試
    - 負載均衡
    - 作為 node 的機器不必與 hub 或其他 node 具有相同的平台或瀏覽器。


### Advantages of selenium grid 

* Selenium Grid gives the flexibility to distribute your test cases for execution.
* Reduces batch processing time.
* Can perform multi-browser testing.
* Can perform multi-OS testing.

### Disavantages of selenium grid 

* The Selenium Grid is less secure than a cloud-based lab.

### How to use Selenium Grid

- 安裝 Selenium Server (Grid)
- 安裝 Java Developer Kit (JDK)

1. 啟用 Hub

```
java -jar selenium-server-standalone-3.141.59.jar -role hub 
```
```
java -jar selenium-server-standalone-<version>.jar -role hub -port <port>
- default port is 4444.
```
![](https://i.imgur.com/aFOQKPw.png)

2. 註冊 nodes
```
java -jar selenium-server-standalone-3.141.59.jar -role node -hub http://140.124.181.129:4444/grid/register
```
![](https://i.imgur.com/6YKCSpv.png)

![](https://i.imgur.com/IMgCoM9.png)


3. 確認 hub 已經有連接到 nodes
```
http://localhost:4444/grid/console
```
![](https://i.imgur.com/ooAQdC1.png)

4. Setting
```json
{
    "capabilities": [
        {
            "browserName": "firefox",
            "marionette": true,
            "maxInstances": 1,
            "seleniumProtocol": "WebDriver"
        },
        {
            "browserName": "chrome",
            "maxInstances": 2,
            "seleniumProtocol": "WebDriver"
        },
        {
            "browserName": "safari",
            "technologyPreview": false,
            "platform": "MAC",
            "maxInstances": 3,
            "seleniumProtocol": "WebDriver"
        }
    ],
    "proxy": "org.openqa.grid.selenium.proxy.DefaultRemoteProxy",
    "maxSession": 5,
    "port": -1,
    "register": true,
    "registerCycle": 5000,
    "hub": "http://localhost:4444",
    "nodeStatusCheckTimeout": 5000,
    "nodePolling": 5000,
    "role": "node",
    "unregisterIfStillDownAfter": 60000,
    "downPollingLimit": 2,
    "debug": false,
    "servlets": [],
    "withoutServlets": [],
    "custom": {}
}
```
```
# filename : nodeConfig.json

java -jar selenium-server-standalone-<version>.jar -role node -nodeConfig nodeConfig.json
```
---
### Python with Selenium Grid

```python
from selenium import webdriver
import os
 
chrome_driver = os.path.abspath(r"C:\\Users\\lab1321\Desktop\\remote\\chromedriver")
os.environ["webdriver.chrome.driver"] = chrome_driver
chrome_capabilities = {
    "browserName": "chrome",
    "version": "",
    "platform": "ANY",
    "javascriptEnabled": True,
    "webdriver.chrome.driver": chrome_driver
}
# node 1
driver = webdriver.Remote("http://140.124.181.129:4444/wd/hub", desired_capabilities=chrome_capabilities)
driver.get("http://www.facebook.com")
print(driver.title)
driver.quit()
# node 2
driver = webdriver.Remote("http://140.124.181.129:4444/wd/hub", desired_capabilities=chrome_capabilities)
driver.get("http://www.google.com")
print(driver.title)
driver.quit()

```
### Robot Framework with Selenium Grid

```python=
*** Settings ***
Documentation         This is just a tutorial
Library               Selenium2Library
Suite Setup           Start Browser
Suite Teardown        Close Browser

*** Variables ***
${SERVER}             https://www.google.com
${BROWSER}            chrome

*** Keywords ***
Start Browser
    [Documentation]   Start chrome browser on Selenium Grid
    Open Browser      ${SERVER}   ${BROWSER}   None    http://127.0.0.1:4444/wd/hub

*** Test Cases ***
Open Google
    [Documentation]   Check the page title
    Title Should Be   Google
```
![](https://i.imgur.com/Cql6deL.gif)

![](https://i.imgur.com/tMaf85d.gif)
