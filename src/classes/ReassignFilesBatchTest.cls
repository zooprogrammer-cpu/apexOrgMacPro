@IsTest
private class ReassignFilesBatchTest {
    @IsTest
    static void shouldReassignFilesToMatchingOrders() {
        // Setup test data
        // ...
        // crate a test account
        Account acc = new Account(Name='ACME', Active__c = 'Yes');
//        acc.Id = '001dx000001dTSzAAM';
        insert acc;

        // Create the original order record
        Order originalOrder = new Order(
                AccountId = acc.Id,
                EffectiveDate = Date.today(),
                Status = 'Draft'
        );
        insert originalOrder;

        // Create three PDF documents and link them to the original order
        for (Integer i = 0; i < 3; i++) {
            // Create a ContentVersion record
            ContentVersion contentVersion = new ContentVersion(
                    Title = 'TestOrder123' + i,
                    PathOnClient = 'testfile' + i + '.pdf',
                    VersionData = Blob.valueOf('Test file content ' + i)
            );
            insert contentVersion;

            // Retrieve the ContentDocumentId from the ContentVersion record
            ContentDocument contentDoc = [SELECT Id FROM ContentDocument WHERE Id = :contentVersion.ContentDocumentId LIMIT 1];

            // Create a ContentDocumentLink record linked to the Order
            ContentDocumentLink contentLink = new ContentDocumentLink(
                    ContentDocumentId = contentDoc.Id,
                    LinkedEntityId = originalOrder.Id,
                    ShareType = 'V'
            );
            insert contentLink;
        }

        // Create three orders with the same account as the original order
        for (Integer i = 0; i < 3; i++) {
            Order newOrder = new Order(
                    AccountId = acc.Id,
                    RPM_Order_Number__c = 'TestOrder123' + i,
                    EffectiveDate = Date.today(),
                    Status = 'Draft'
            );
            insert newOrder;
        }


        Test.startTest();
        ReassignFilesBatch batch = new ReassignFilesBatch(originalOrder.Id);
        Database.executeBatch(batch);
        Test.stopTest();

        // Assertions to verify that files were reassigned to matching orders
        // ...
    }

//    @IsTest
//    static void shouldNotReassignFilesWhenNoMatchingOrders() {
//        // Setup test data
//        // ...
//
//        Test.startTest();
//        ReassignFilesBatch batch = new ReassignFilesBatch(originalRecordId);
//        Database.executeBatch(batch);
//        Test.stopTest();
//
//        // Assertions to verify that files were not reassigned when no matching orders
//        // ...
//    }

//    @IsTest
//    static void shouldHandleExceptionsGracefully() {
//        // Setup test data
//        // ...
//
//        Test.startTest();
//        ReassignFilesBatch batch = new ReassignFilesBatch(originalRecordId);
//        Database.executeBatch(batch);
//        Test.stopTest();
//
//        // Assertions to verify that exceptions were handled gracefully
//        // ...
//    }
}