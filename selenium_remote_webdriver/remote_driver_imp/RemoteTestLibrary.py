from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.remote.remote_connection import RemoteConnection
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn

class RemoteTestLibrary:
    def __init__(self):
        self.driver = None

    def __getattr__(self, name):
        if name == 'selenium':
            self.selenium = BuiltIn().get_library_instance('SeleniumLibrary')
            return self.selenium
        return object.__getattribute__(self, name)

    @keyword('Open Google At Remote Side Using Chrome')
    def open_google_at_remote_side_using_chrome(self):
        RemoteConnection.set_timeout(20)
        self.driver = webdriver.Remote(command_executor='http://140.124.181.33:4444/wd/hub',
                                       desired_capabilities={"browserName": "chrome", "platformName": "Windows 8"})
        self.driver.get("https://www.google.com.tw/")

    @keyword('Open dcTrack At Remote Side Using Chrome')
    def open_dcTrack_at_remote_side_using_chrome(self):
        RemoteConnection.set_timeout(20)
        capabilities = DesiredCapabilities.CHROME.copy()
        capabilities['acceptSslCerts'] = True
        capabilities['acceptInsecureCerts'] = True
        capabilities['browserName'] = "chrome"
        capabilities['platformName'] = "Windows 8"
        self.selenium.create_webdriver("Remote",
                                       command_executor='http://140.124.181.33:4444/wd/hub',
                                       desired_capabilities=capabilities)
        """
        Change to remote webdriver:
        self.selenium.create_webdriver("Remote",
                                       command_executor='http://140.124.181.33:4444/wd/hub',
                                       desired_capabilities={"browserName": "chrome", "platformName": "Windows 10"})
        """
        self.selenium.go_to("https://140.124.181.139/")

    @keyword('Google Page Should Be Shown At Remote Side')
    def google_page_should_be_shown_at_remote_side(self, locator, timeout=3):
        wait_element_is_load(self.driver, locator, timeout)
 
    @keyword('Close Remote Side Browser')
    def close_remote_side_browser(self):
        self.driver.quit()

def wait_element_is_load(driver, locator, timeout):
    try:
        WebDriverWait(driver, timeout).until(EC.presence_of_element_located((By.XPATH, locator)))
        WebDriverWait(driver, timeout).until(EC.visibility_of_element_located((By.XPATH, locator)))
    except:
        driver.save_screenshot('./out/remote_fail.png')
        raise Exception('{} not found'.format(locator))
