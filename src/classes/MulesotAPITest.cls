@isTest
private class MulesoftAPITest {
    @isTest static void testGetAccountWithAccounts() {
        // Arrange
        Account testAccount = new Account(Name='Test Account', Phone='1234567890');
        insert testAccount;

        // Act
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/showAccountsDetails';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        List<Account> accounts = MulesoftAPI.getAccount();

        // Assert
        System.assertEquals(1, accounts.size(), 'Expected one account');
        System.assertEquals(testAccount.Name, accounts[0].Name, 'Expected account name to match');
        System.assertEquals(testAccount.Phone, accounts[0].Phone, 'Expected account phone to match');
    }

    @isTest static void testGetAccountWithoutAccounts() {
        // Arrange
        // No accounts are created

        // Act
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/showAccountsDetails';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        List<Account> accounts = MulesoftAPI.getAccount();

        // Assert
        System.assertEquals(0, accounts.size(), 'Expected no accounts');
    }
}