@IsTest
private class ContentVersionExportOutputHandlerTest {
    @IsTest
    static void testSaveWithoutLinkCreatesContentVersionAndReturnsIds() {
        ContentVersionExportOutputHandler handler = new ContentVersionExportOutputHandler();

        Test.startTest();
        CsvExportModels.OutputSaveResult result = handler.save('Accounts_Export', 'Name\nAcme', null);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should be returned.');
        System.assertNotEquals(null, result.contentVersionId, 'ContentVersion Id should be populated.');
        System.assertNotEquals(null, result.contentDocumentId, 'ContentDocument Id should be populated.');

        ContentVersion insertedCv = [
            SELECT Id, Title, PathOnClient, IsMajorVersion, ContentDocumentId
            FROM ContentVersion
            WHERE Id = :result.contentVersionId
            LIMIT 1
        ];

        System.assertEquals('Accounts_Export', insertedCv.Title);
        System.assertEquals('Accounts_Export.csv', insertedCv.PathOnClient);
        System.assertEquals(false, insertedCv.IsMajorVersion);
        System.assertEquals(result.contentDocumentId, insertedCv.ContentDocumentId);
    }

    @IsTest
    static void testSaveWithLinkCreatesContentDocumentLink() {
        Account a = new Account(Name = 'File Link Target');
        insert a;

        ContentVersionExportOutputHandler handler = new ContentVersionExportOutputHandler();

        Test.startTest();
        CsvExportModels.OutputSaveResult result = handler.save('Contacts_Export', 'Name\nSmith', a.Id);
        Test.stopTest();

        System.assertNotEquals(null, result.contentVersionId, 'ContentVersion Id should be populated.');
        System.assertNotEquals(null, result.contentDocumentId, 'ContentDocument Id should be populated.');

        ContentDocumentLink link = [
            SELECT Id, ContentDocumentId, LinkedEntityId, ShareType, Visibility
            FROM ContentDocumentLink
            WHERE ContentDocumentId = :result.contentDocumentId
              AND LinkedEntityId = :a.Id
            LIMIT 1
        ];

        System.assertEquals(result.contentDocumentId, link.ContentDocumentId);
        System.assertEquals(a.Id, link.LinkedEntityId);
        System.assertEquals('V', link.ShareType);
        System.assertEquals('AllUsers', link.Visibility);
    }
}
