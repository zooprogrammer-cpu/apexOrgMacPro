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
                    PathOnClient = '/' + 'testfile' + i,
                    VersionData = Blob.valueOf('Test file content ' + i)
            );
            insert contentVersion;

            // Add a delay to give the platform enough time to create the associated ContentDocument record
//            Test.startTest();
//            Integer start = Limits.getCpuTime();
//            while(Limits.getCpuTime() - start < 2000) {}
//            Test.stopTest();

            //////
            ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
            contentDocumentLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;
            contentDocumentLink.LinkedEntityId = originalOrder.Id;
            contentDocumentLink.ShareType = 'V';
            contentDocumentLink.Visibility = 'AllUsers';
            insert contentDocumentLink;
            ////////

            // Retrieve the ContentDocumentId from the ContentVersion record
//            ContentDocument contentDoc = [SELECT Id FROM ContentDocument WHERE Id = :contentVersion.ContentDocumentId LIMIT 1];

            // Create a ContentDocumentLink record linked to the Order
//            ContentDocumentLink contentLink = new ContentDocumentLink(
//                    ContentDocumentId = contentDoc.Id,
//                    LinkedEntityId = originalOrder.Id,
//                    ShareType = 'V'
//            );
//            insert contentLink;
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

        ////
        for (Integer i=0; i<3; i++) {
            String rpmOrderNumber= 'TestOrder123' + i;
            Order order = [SELECT Id FROM Order WHERE RPM_Order_Number__c =: rpmOrderNumber];
            List<ContentDocumentLink> newLink = [
                    SELECT ContentDocumentId, LinkedEntityId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :order.Id
            ];

//            System.assertEquals(1, newLink.size(), 'The file should have been reassigned to the new Order');
//            System.assertEquals(order.Id, newLink[0].ContentDocumentId, 'The ContentDocumentId should match');
            System.debug('newLink:' + newLink[0]);
            System.assertNotEquals(null, newLink[0], 'ContentDocumentLink should have been created');
            System.assertEquals(order.Id, newLink[0].LinkedEntityId, 'ContentDocumentLink should be linked to the Order');
        }


        ////
//        Order order0 = [SELECT Id FROM Order WHERE RPM_Order_Number__c = 'TestOrder1230' ];
//
//        ContentDocumentLink contentDocumentLink = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :order0.Id LIMIT 1];
//        System.assertNotEquals(null, contentDocumentLink, 'ContentDocumentLink should have been created');
//        System.assertEquals(order0.Id, contentDocumentLink.LinkedEntityId, 'ContentDocumentLink should be linked to the Order');




//        Order order0 = [SELECT Id FROM Order WHERE RPM_Order_Number__c = 'TestOrder1230' ];
//        List<ContentDocumentLink> newLink = [
//                SELECT ContentDocumentId, LinkedEntityId
//                FROM ContentDocumentLink
//                WHERE LinkedEntityId = :order0.Id
//        ];
//
//        System.assertEquals(1, newLink.size(), 'The file should have been reassigned to the new Order');
//        System.assertEquals(order0.Id, newLink[0].ContentDocumentId, 'The ContentDocumentId should match');

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