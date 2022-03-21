path = "C:/Users/Honey-cake/RubymineProjects/untitled/chromedriver/chromedriver.exe"
Given(/^I open a browser$/) do
  @browser = Selenium::WebDriver.for :chrome, driver_path:path
  url ="http://test-app.d6.dev.devcaz.com/admin/login"
  @browser.navigate.to url
end

When(/^I login user name "([^"]*)" and password "([^"]*)"$/) do |username, password|
  @browser.find_element(xpath: ".//*[@id='UserLogin_username']").send_keys username
  @browser.find_element(xpath: ".//*[@id='UserLogin_password']").send_keys password
  @browser.find_element(xpath: ".//*[@type='submit']").click
end

Then(/^I verify Slotegrator page loaded$/) do
  @browser.find_element(xpath: "//span[.='Users']")
end