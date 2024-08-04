/**
 * 
 */

@IsTest
private class AddPrimaryContactTest {

    @TestSetup
    static void setup() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i =0 ; i < 50; i++) {
            testAccounts.add(new Account(Name='Parent NY' +i, BillingState = 'NY'));
        }
        for (Integer i =0 ; i < 50; i++) {
            testAccounts.add(new Account(Name='Parent CA' +i, BillingState = 'CA'));
        }
        insert testAccounts;

        // Create a test contact (this contact will be cloned in the queueable job)
        Contact testContact = new Contact(LastName='Test Contact', Email='test@example.com');
        insert testContact;


    }

    @IsTest
    static void testAddPrimaryContactNY() {
        AddPrimaryContact.doChainJob = false;
        // Query for the test contact and a test account with BillingState 'NY'
        Contact testContact = [SELECT Id, LastName FROM Contact WHERE Email='test@example.com' LIMIT 1];
        Account testAccountNY = [SELECT Id FROM Account WHERE BillingState='NY' LIMIT 1];

        // Create our queuable instance
        AddPrimaryContact updater = new AddPrimaryContact(testContact, 'NY');
        //startTest/stopeTest block to for async processes to run
        Test.startTest();
        System.enqueueJob(updater);
        Test.stopTest();

        // Assert that contacts were created and associated with the correct account
        List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE AccountId = :testAccountNY.Id];
        System.assertEquals(1, contacts.size(), 'One contact should be associated with the NY account');

    }

    @IsTest
    static void testAddPrimaryContactCA() {
        AddPrimaryContact.doChainJob = false;
        // Query for the test contact and a test account with BillingState 'CA'
        Contact testContact = [SELECT Id, LastName FROM Contact WHERE Email='test@example.com' LIMIT 1];
        Account testAccountCA = [SELECT Id FROM Account WHERE BillingState='CA' LIMIT 1];

        // Create our queuable instance
        AddPrimaryContact updater = new AddPrimaryContact(testContact, 'CA');
        //startTest/stopeTest block to for async processes to run
        Test.startTest();
        System.enqueueJob(updater);
        Test.stopTest();

        // Assert that contacts were created and associated with the correct account
        List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE AccountId = :testAccountCA.Id];
        System.assertEquals(1, contacts.size(), 'One contact should be associated with the CA account');

    }
}