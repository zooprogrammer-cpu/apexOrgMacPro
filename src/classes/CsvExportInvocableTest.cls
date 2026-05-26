@IsTest
private class CsvExportInvocableTest {
    @IsTest
    static void testExportCsv_success_mapsServiceResults() {
        Account acc = new Account(Name = 'CSV Invocable Test');
        insert acc;

        insert new Contact(LastName = 'Contact One', AccountId = acc.Id);
        insert new Opportunity(
                Name = 'Opp One',
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Amount = 1000,
                AccountId = acc.Id
        );

        CsvExportInvocable.Request req = new CsvExportInvocable.Request();
        req.rootRecordId = acc.Id;

        Test.startTest();
        List<CsvExportInvocable.Result> outputs = CsvExportInvocable.exportCsv(
                new List<CsvExportInvocable.Request>{ req }
        );
        Test.stopTest();

        System.assertNotEquals(0, outputs.size(), 'Expected at least one export result.');

        Map<String, CsvExportInvocable.Result> byConfigKey = new Map<String, CsvExportInvocable.Result>();
        Integer successCount = 0;
        for (CsvExportInvocable.Result output : outputs) {
            if (!String.isBlank(output.configKey)) {
                byConfigKey.put(output.configKey, output);
            }
            if (output.status == CsvExportService.STATUS_SUCCESS) {
                successCount++;
            }
        }

        System.assert(byConfigKey.containsKey('ACC_DEFAULT_EXPORT'),
                'Expected Account -> Contact export config result.');
        System.assert(byConfigKey.containsKey('ACC_OPPTY_EXPORT'),
                'Expected Account -> Opportunity export config result.');

        CsvExportInvocable.Result contactResult = byConfigKey.get('ACC_DEFAULT_EXPORT');
        System.assertEquals(CsvExportService.STATUS_SUCCESS, contactResult.status);
        System.assertEquals('Contact', contactResult.childObjectApiName);
        System.assertEquals(acc.Id, contactResult.rootRecordId);
        System.assertEquals(1, contactResult.recordCount);
        System.assertNotEquals(null, contactResult.contentDocumentId);
        System.assertNotEquals(null, contactResult.contentVersionId);
        System.assert(contactResult.fileTitle.startsWith('Export_Contact_'));

        CsvExportInvocable.Result opportunityResult = byConfigKey.get('ACC_OPPTY_EXPORT');
        System.assertEquals(CsvExportService.STATUS_SUCCESS, opportunityResult.status);
        System.assertEquals('Opportunity', opportunityResult.childObjectApiName);
        System.assertEquals(acc.Id, opportunityResult.rootRecordId);
        System.assertEquals(1, opportunityResult.recordCount);
        System.assertNotEquals(null, opportunityResult.contentDocumentId);
        System.assertNotEquals(null, opportunityResult.contentVersionId);
        System.assert(opportunityResult.fileTitle.startsWith('Export_Opportunity_'));

        Integer linkedFileCount = [
                SELECT count()
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :acc.Id
        ];
        System.assertEquals(successCount, linkedFileCount,
                'Each successful export should create one linked file.');
    }

    @IsTest
    static void testExportCsv_nullRequests_returnsFailedResult() {
        Test.startTest();
        List<CsvExportInvocable.Result> outputs = CsvExportInvocable.exportCsv(null);
        Test.stopTest();

        System.assertEquals(1, outputs.size());
        System.assertEquals(CsvExportService.STATUS_FAILED, outputs[0].status);
        System.assert(outputs[0].message.contains('No requests provided.'));
    }

    @IsTest
    static void testExportCsv_nullRootRecordId_returnsFailedResult() {
        CsvExportInvocable.Request req = new CsvExportInvocable.Request();
        req.rootRecordId = null;

        Test.startTest();
        List<CsvExportInvocable.Result> outputs = CsvExportInvocable.exportCsv(
                new List<CsvExportInvocable.Request>{ req }
        );
        Test.stopTest();

        System.assertEquals(1, outputs.size());
        System.assertEquals(CsvExportService.STATUS_FAILED, outputs[0].status);
        System.assert(outputs[0].message.contains('rootRecordId is required.'));
    }
}
