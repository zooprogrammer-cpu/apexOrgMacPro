@IsTest
private class CsvExportMetadataConfigProviderTest {
    @IsTest
    static void testBlankRootObjectReturnsEmptyList() {
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();

        List<CsvExportModels.ExportConfig> results = provider.getByRootObjectApiName('');

        System.assertNotEquals(null, results);
        System.assertEquals(0, results.size());
    }

    @IsTest
    static void testUnknownRootObjectReturnsEmptyList() {
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();

        List<CsvExportModels.ExportConfig> results = provider.getByRootObjectApiName('DoesNotExist__c');

        System.assertNotEquals(null, results);
        System.assertEquals(0, results.size());
    }

    @IsTest
    static void testAccountRootMapsConfigsAndFieldsFromMetadata() {
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();

        List<CsvExportModels.ExportConfig> results = provider.getByRootObjectApiName('Account');

        System.assert(results.size() >= 2, 'Expected at least the two seeded Account configs.');

        Map<String, CsvExportModels.ExportConfig> byKey = new Map<String, CsvExportModels.ExportConfig>();
        for (CsvExportModels.ExportConfig cfg : results) {
            byKey.put(cfg.configKey, cfg);
        }

        System.assert(byKey.containsKey('ACC_DEFAULT_EXPORT'), 'ACC_DEFAULT_EXPORT should be returned.');
        System.assert(byKey.containsKey('ACC_OPPTY_EXPORT'), 'ACC_OPPTY_EXPORT should be returned.');

        CsvExportModels.ExportConfig accountContacts = byKey.get('ACC_DEFAULT_EXPORT');
        System.assertEquals('Account', accountContacts.rootObjectApiName);
        System.assertEquals('Contact', accountContacts.childObjectApiName);
        System.assertEquals('AccountId', accountContacts.childRelationshipFieldApiName);
        System.assertEquals('Export_{ObjectApiName}_{DateTime}', accountContacts.fileNameTemplate);
        System.assertEquals(5000, accountContacts.maxRecordCount);
        System.assertEquals(true, accountContacts.isActive);
        System.assertEquals(2, accountContacts.fields.size());
        System.assertEquals('Name', accountContacts.fields[0].fieldPath);
        System.assertEquals('Account Name', accountContacts.fields[0].headerLabel);
        System.assertEquals(1, accountContacts.fields[0].sortOrder);
        System.assertEquals('Owner.Email', accountContacts.fields[1].fieldPath);
        System.assertEquals('Owner Email', accountContacts.fields[1].headerLabel);
        System.assertEquals(2, accountContacts.fields[1].sortOrder);

        CsvExportModels.ExportConfig accountOppties = byKey.get('ACC_OPPTY_EXPORT');
        System.assertEquals('Account', accountOppties.rootObjectApiName);
        System.assertEquals('Opportunity', accountOppties.childObjectApiName);
        System.assertEquals('AccountId', accountOppties.childRelationshipFieldApiName);
        System.assertEquals('Export_{ObjectApiName}_{DateTime}', accountOppties.fileNameTemplate);
        System.assertEquals(5000, accountOppties.maxRecordCount);
        System.assertEquals(true, accountOppties.isActive);
        System.assertEquals(3, accountOppties.fields.size());
        System.assertEquals('Name', accountOppties.fields[0].fieldPath);
        System.assertEquals('Opportunity Name', accountOppties.fields[0].headerLabel);
        System.assertEquals(1, accountOppties.fields[0].sortOrder);
        System.assertEquals('StageName', accountOppties.fields[1].fieldPath);
        System.assertEquals('Stage', accountOppties.fields[1].headerLabel);
        System.assertEquals(2, accountOppties.fields[1].sortOrder);
        System.assertEquals('Amount', accountOppties.fields[2].fieldPath);
        System.assertEquals('Amount', accountOppties.fields[2].headerLabel);
        System.assertEquals(3, accountOppties.fields[2].sortOrder);
    }
}
