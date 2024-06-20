@IsTest
private class ReassignFilesBatchTest {
    @TestSetup
    static void makeData() {
        // Setup test data
        Account acc = new Account(Name='ACME', Active__c = 'Yes');
        insert acc;

        // Create the original order record
        Order originalOrder = new Order(
                AccountId = acc.Id,
                EffectiveDate = Date.today(),
                Status = 'Draft',
                Name = 'Original Order'
        );
        insert originalOrder;

// Create three PDF documents and link them to the original order
        List<ContentVersion> contentVersions = new List<ContentVersion>();
        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();

        for (Integer i = 0; i < 3; i++) {
            // Create a ContentVersion record
            ContentVersion contentVersion = new ContentVersion(
                    Title = 'TestOrder123' + i,
                    PathOnClient = '/' + 'testfile' + i,
                    VersionData = Blob.valueOf('Test file content ' + i)
            );
            contentVersions.add(contentVersion);
        }

        insert contentVersions;

        for (ContentVersion contentVersion : contentVersions) {
            ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
            contentDocumentLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;
            contentDocumentLink.LinkedEntityId = originalOrder.Id;
            contentDocumentLink.ShareType = 'V';
            contentDocumentLink.Visibility = 'AllUsers';
            contentDocumentLinks.add(contentDocumentLink);
        }

        insert contentDocumentLinks;

        // Create orders with the same account as the original order
        List<Order> ordersToInsert = new List<Order>();
        for (Integer i = 0; i < 3; i++) {
            Order newOrder = new Order(
                    AccountId = acc.Id,
                    RPM_Order_Number__c = 'TestOrder123' + i,
                    EffectiveDate = Date.today(),
                    Status = 'Draft'
            );
            ordersToInsert.add(newOrder);
        }

        insert ordersToInsert;

    }
    @IsTest
    static void shouldReassignFilesToMatchingOrders() {
        List<Order> originalOrders = [SELECT Id, RPM_Order_Number__c FROM Order WHERE Name = 'Original Order'];
        Test.startTest();
        ReassignFilesBatch batch = new ReassignFilesBatch(originalOrders[0].Id);
        Database.executeBatch(batch);
        Test.stopTest();

        // Assertions to verify that files were reassigned to matching orders
        for (Integer i=0; i<3; i++) {
            String rpmOrderNumber= 'TestOrder123' + i;
            Order order = [SELECT Id FROM Order WHERE RPM_Order_Number__c =: rpmOrderNumber];
            List<ContentDocumentLink> newLink = [
                    SELECT ContentDocumentId, LinkedEntityId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :order.Id
            ];

            System.debug('newLink:' + newLink[0]);
            System.assertNotEquals(null, newLink[0], 'ContentDocumentLink should have been created');
            System.assertEquals(order.Id, newLink[0].LinkedEntityId, 'ContentDocumentLink should be linked to the Order');
        }

    }

}