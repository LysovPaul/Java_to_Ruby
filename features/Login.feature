Feature: Basic authentication

  Scenario: User with valid credentials
    Given I open a browser
    When I login user name "admin1" and password "[9k<k8^z!+$$GkuP"
    Then I verify Slotegrator page loaded