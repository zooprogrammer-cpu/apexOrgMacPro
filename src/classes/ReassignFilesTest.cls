@isTest
public class ReassignFilesTest {
    @isTest
    static void testReassignFiles() {
        // crate a test account
        Account acc = new Account(Name='ACME', Active__c = 'Yes');
//        acc.Id = '001dx000001dTSzAAM';
        insert acc;
        // Create a test Order record
        Order testOrder = new Order(
                Name = 'TestOrder123',
                AccountId = acc.Id,
                EffectiveDate = Date.today(),
                Status = 'Draft'
        );
        insert testOrder;

        // Create a ContentVersion record
        ContentVersion contentVersion = new ContentVersion(
                Title = 'TestOrder123',
                PathOnClient = 'testfile.pdf',
                VersionData = Blob.valueOf('Test file content')
        );
        insert contentVersion;

        // Retrieve the ContentDocumentId from the ContentVersion record
        ContentDocument contentDoc = [SELECT Id FROM ContentDocument WHERE Id = :contentVersion.ContentDocumentId LIMIT 1];

        // Create a ContentDocumentLink record linked to the Order
        ContentDocumentLink contentLink = new ContentDocumentLink(
                ContentDocumentId = contentDoc.Id,
                LinkedEntityId = testOrder.Id,
                ShareType = 'V'
        );
        insert contentLink;

        // Create another test Order record to reassign the file
        Order newOrder = new Order(
                Name = 'TestOrder123'
        );
        insert newOrder;

        // Call the reassignFiles method
        Test.startTest();
        ReassignFiles.reassignFiles(testOrder.Id);
        Test.stopTest();

        // Verify that the file was reassigned to the new Order
        List<ContentDocumentLink> newLinks = [
                SELECT ContentDocumentId, LinkedEntityId
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :newOrder.Id
        ];

        System.assertEquals(1, newLinks.size(), 'The file should have been reassigned to the new Order');
        System.assertEquals(contentDoc.Id, newLinks[0].ContentDocumentId, 'The ContentDocumentId should match');
    }
}