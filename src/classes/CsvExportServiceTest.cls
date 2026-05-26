@IsTest
private class CsvExportServiceTest {
    private static String lastTitle;
    private static String lastCsv;
    private static Id lastLinkToRecordId;
    private static Integer saveCalls = 0;

    private static void resetCapture() {
        saveCalls = 0;
        lastTitle = null;
        lastCsv = null;
        lastLinkToRecordId = null;
    }

    private class StubConfigProvider implements ICsvExportConfigProvider {
        private Map<String, List<CsvExportModels.ExportConfig>> byRootObject;

        StubConfigProvider(Map<String, List<CsvExportModels.ExportConfig>> byRootObject) {
            this.byRootObject = byRootObject;
        }

        public List<CsvExportModels.ExportConfig> getByRootObjectApiName(String rootObjectApiName) {
            List<CsvExportModels.ExportConfig> found = byRootObject.get(rootObjectApiName);
            return found == null ? new List<CsvExportModels.ExportConfig>() : found;
        }
    }

    private class CapturingOutputHandler implements IExportOutputHandler {
        public CsvExportModels.OutputSaveResult save(String fileTitle, String csvContent, Id linkToRecordId) {
            saveCalls++;
            lastTitle = fileTitle;
            lastCsv = csvContent;
            lastLinkToRecordId = linkToRecordId;

            CsvExportModels.OutputSaveResult outVal = new CsvExportModels.OutputSaveResult();
            outVal.contentDocumentId = null;
            outVal.contentVersionId = null;
            return outVal;
        }
    }

    private static CsvExportModels.ExportConfig buildContactConfig(String key, Integer maxRows) {
        CsvExportModels.ExportConfig cfg = new CsvExportModels.ExportConfig();
        cfg.configKey = key;
        cfg.rootObjectApiName = 'Account';
        cfg.childObjectApiName = 'Contact';
        cfg.childRelationshipFieldApiName = 'AccountId';
        cfg.fileNameTemplate = 'Export_{ObjectApiName}_{DateTime}';
        cfg.maxRecordCount = maxRows;
        cfg.isActive = true;

        CsvExportModels.ExportField f1 = new CsvExportModels.ExportField();
        f1.fieldPath = 'Name';
        f1.headerLabel = 'Contact Name';
        f1.sortOrder = 1;
        cfg.fields.add(f1);

        return cfg;
    }

    @IsTest
    static void testSuccessPath() {
        Account a = new Account(Name = 'Acme Success');
        insert a;
        Contact c = new Contact(LastName = 'Smith', AccountId = a.Id);
        insert c;

        Map<String, List<CsvExportModels.ExportConfig>> configsByRoot =
                new Map<String, List<CsvExportModels.ExportConfig>>{
                        'Account' => new List<CsvExportModels.ExportConfig>{ buildContactConfig('ACC_CONTACTS', 5000) }
                };

        resetCapture();
        CsvExportService service = new CsvExportService(
                new StubConfigProvider(configsByRoot),
                new StandardCsvGenerator(),
                new CapturingOutputHandler()
        );

        CsvExportModels.ExportRequest req = new CsvExportModels.ExportRequest();
        req.rootRecordId = a.Id;

        List<CsvExportModels.ExportResult> results = service.process(new List<CsvExportModels.ExportRequest>{ req });

        System.assertEquals(1, results.size());
        System.assertEquals(CsvExportService.STATUS_SUCCESS, results[0].status);
        System.assertEquals('ACC_CONTACTS', results[0].configKey);
        System.assertEquals('Contact', results[0].childObjectApiName);
        System.assertEquals(1, results[0].recordCount);
        System.assertEquals(1, saveCalls);
        System.assertEquals(a.Id, lastLinkToRecordId);
        System.assert(lastTitle.startsWith('Export_Contact_'));
        System.assert(lastCsv.contains('Contact Name'));
        System.assert(lastCsv.contains('Smith'));
    }

    @IsTest
    static void testPartialSuccessWithInvalidField() {
        Account a = new Account(Name = 'Acme Partial');
        insert a;
        Contact c = new Contact(LastName = 'Jones', AccountId = a.Id);
        insert c;

        CsvExportModels.ExportConfig cfg = buildContactConfig('ACC_CONTACTS_PARTIAL', 5000);
        CsvExportModels.ExportField bad = new CsvExportModels.ExportField();
        bad.fieldPath = 'DoesNotExist__c';
        bad.sortOrder = 2;
        cfg.fields.add(bad);

        Map<String, List<CsvExportModels.ExportConfig>> configsByRoot =
                new Map<String, List<CsvExportModels.ExportConfig>>{
                        'Account' => new List<CsvExportModels.ExportConfig>{ cfg }
                };

        resetCapture();
        CsvExportService service = new CsvExportService(
                new StubConfigProvider(configsByRoot),
                new StandardCsvGenerator(),
                new CapturingOutputHandler()
        );

        CsvExportModels.ExportRequest req = new CsvExportModels.ExportRequest();
        req.rootRecordId = a.Id;

        List<CsvExportModels.ExportResult> results = service.process(new List<CsvExportModels.ExportRequest>{ req });

        System.assertEquals(CsvExportService.STATUS_PARTIAL_SUCCESS, results[0].status);
        System.assert(results[0].warnings.contains('Invalid field path skipped'));
        System.assertEquals(1, saveCalls);
    }

    @IsTest
    static void testMaxRowFailure() {
        Account a = new Account(Name = 'Acme Limit');
        insert a;
        insert new List<Contact>{
                new Contact(LastName = 'One', AccountId = a.Id),
                new Contact(LastName = 'Two', AccountId = a.Id)
        };

        Map<String, List<CsvExportModels.ExportConfig>> configsByRoot =
                new Map<String, List<CsvExportModels.ExportConfig>>{
                        'Account' => new List<CsvExportModels.ExportConfig>{ buildContactConfig('ACC_CONTACTS_LIMIT', 1) }
                };

        resetCapture();
        CsvExportService service = new CsvExportService(
                new StubConfigProvider(configsByRoot),
                new StandardCsvGenerator(),
                new CapturingOutputHandler()
        );

        CsvExportModels.ExportRequest req = new CsvExportModels.ExportRequest();
        req.rootRecordId = a.Id;

        List<CsvExportModels.ExportResult> results = service.process(new List<CsvExportModels.ExportRequest>{ req });

        System.assertEquals(CsvExportService.STATUS_FAILED, results[0].status);
        System.assert(results[0].message.contains('exceed max allowed'));
        System.assertEquals(0, saveCalls);
    }

    @IsTest
    static void testNoActiveConfigReturnsPartial() {
        Account a = new Account(Name = 'Acme None');
        insert a;

        Map<String, List<CsvExportModels.ExportConfig>> configsByRoot =
                new Map<String, List<CsvExportModels.ExportConfig>>();

        resetCapture();
        CsvExportService service = new CsvExportService(
                new StubConfigProvider(configsByRoot),
                new StandardCsvGenerator(),
                new CapturingOutputHandler()
        );

        CsvExportModels.ExportRequest req = new CsvExportModels.ExportRequest();
        req.rootRecordId = a.Id;

        List<CsvExportModels.ExportResult> results = service.process(new List<CsvExportModels.ExportRequest>{ req });

        System.assertEquals(1, results.size());
        System.assertEquals(CsvExportService.STATUS_PARTIAL_SUCCESS, results[0].status);
        System.assert(results[0].message.contains('No active export configs'));
        System.assertEquals(0, saveCalls);
    }

    @IsTest
    static void testInvocableNullInputFailsGracefully() {
        CsvExportInvocable.Request req = new CsvExportInvocable.Request();
        req.rootRecordId = null;

        Test.startTest();
        List<CsvExportInvocable.Result> outVals = CsvExportInvocable.exportCsv(new List<CsvExportInvocable.Request>{ req });
        Test.stopTest();

        System.assertEquals(1, outVals.size());
        System.assertEquals(CsvExportService.STATUS_FAILED, outVals[0].status);
        System.assert(outVals[0].message.contains('rootRecordId is required'));
    }
}
