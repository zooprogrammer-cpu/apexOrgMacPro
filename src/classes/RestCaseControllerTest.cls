@isTest
private class RESTCaseControllerTest {
    @isTest static void testCreateNewCase() {
        // Arrange
        List<String> companyName = new List<String>{'Company', 'Name'};
        String caseType = 'Test Case';

        // Act
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/FieldCase';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        String result = RESTCaseController.createNewCase(companyName, caseType);

        // Assert
        System.assertEquals('This is a test for CompanyNameTest Case', result, 'Expected string does not match');
    }
}