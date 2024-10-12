@IsTest
private class CalculateTitlePriorityTest {

    @IsTest
    static void testCalculatePriorities_withValidInputs() {
        // GIVEN
        Contact contact = new Contact(FirstName = 'John', LastName = 'Doe');
        Account account = new Account(Name = 'ACME Corp');
        insert contact;
        insert account;

        CalculateTitlePriority.ActionRequest request = new CalculateTitlePriority.ActionRequest();
        request.contactObj = contact;
        request.accountObj = account;

        List<CalculateTitlePriority.ActionRequest> inputs = new List<CalculateTitlePriority.ActionRequest>{ request };

        // WHEN
        Test.startTest();
        List<CalculateTitlePriority.ActionResult> results = CalculateTitlePriority.calculatePriorities(inputs);
        Test.stopTest();

        // THEN
        System.assertEquals(1, results.size(), 'Expected one result');
        System.assertEquals(contact.Id, results[0].contacts[0].Id, 'Contact Id should match');
        System.assertEquals(account.Id, results[0].accounts[0].Id, 'Account Id should match');
    }

    @IsTest
    static void testCalculatePriorities_withNullInputs() {
        // GIVEN
        CalculateTitlePriority.ActionRequest request = new CalculateTitlePriority.ActionRequest();
        request.contactObj = null;
        request.accountObj = null;

        List<CalculateTitlePriority.ActionRequest> inputs = new List<CalculateTitlePriority.ActionRequest>{ request };

        // WHEN
        Test.startTest();
        List<CalculateTitlePriority.ActionResult> results = CalculateTitlePriority.calculatePriorities(inputs);
        Test.stopTest();

        // THEN
        System.assertEquals(0, results.size(), 'Expected no results');
    }

    @IsTest
    static void testCalculatePriorities_withEmptyInputs() {
        // GIVEN
        List<CalculateTitlePriority.ActionRequest> inputs = new List<CalculateTitlePriority.ActionRequest>();

        // WHEN
        Test.startTest();
        List<CalculateTitlePriority.ActionResult> results = CalculateTitlePriority.calculatePriorities(inputs);
        Test.stopTest();

        // THEN
        System.assertEquals(0, results.size(), 'Expected no results');
    }
}