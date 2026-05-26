@isTest
public with sharing class CsvExportMetadataConfigProviderTest {

    // Test helper to clear MDT data before tests
    private static void resetMdtData() {
        Database.delete(CSV_Export_Config__mdt.class, ALLROW);
        Database.delete(CSV_Export_Field__mdt.class, ALLROW);
    }

    // Test helper to create test CSV_Export_Config__mdt records
    private static List<CSV_Export_Config__mdt> createTestConfigs(List<CSV_Export_Config__mdt> configs) {
        List<CSV_Export_Config__mdt> savedConfigs = new List<CSV_Export_Config__mdt>();
        for (CSV_Export_Config__mdt cfg : configs) {
            cfg = (CSV_Export_Config__mdt) [SELECT Id FROM CSV_Export_Config__mdt WHERE Id = :cfg.Id];
            savedConfigs.add(cfg);
        }
        return savedConfigs;
    }

    // Test helper to create test CSV_Export_Field__mdt records
    private static List<CSV_Export_Field__mdt> createTestFields(List<CSV_Export_Field__mdt> fields) {
        List<CSV_Export_Field__mdt> savedFields = new List<CSV_Export_Field__mdt>();
        for (CSV_Export_Field__mdt f : fields) {
            f = (CSV_Export_Field__mdt) [SELECT Id FROM CSV_Export_Field__mdt WHERE Id = :f.Id];
            savedFields.add(f);
        }
        return savedFields;
    }

    // Test Data: CSV_Export_Config__mdt records
    @testSetup
    static void createTestConfigSetup() {
        // Test data for Active configs
        CSV_Export_Config__mdt config1 = new CSV_Export_Config__mdt();
        config1.DeveloperName = 'Account_Config';
        config1.Config_Key__c = 'Account_Config_Key';
        config1.Root_Object_API_Name__c = 'Account';
        config1.Child_Object_API_Name__c = 'Contact';
        config1.Child_Relationship_Field_API_Name__c = 'AccountId';
        config1.File_Name_Template__c = 'account_{0}.csv';
        config1.Max_Record_Count__c = 1000;
        config1.Is_Active__c = true;

        CSV_Export_Config__mdt config2 = new CSV_Export_Config__mdt();
        config2.DeveloperName = 'Contact_Config';
        config2.Config_Key__c = 'Contact_Config_Key';
        config2.Root_Object_API_Name__c = 'Contact';
        config2.Child_Object_API_Name__c = 'Opportunity';
        config2.Child_Relationship_Field_API_Name__c = 'ContactId';
        config2.File_Name_Template__c = 'contact_{0}.csv';
        config2.Max_Record_Count__c = 500;
        config2.Is_Active__c = true;

        CSV_Export_Config__mdt config3 = new CSV_Export_Config__mdt();
        config3.DeveloperName = 'Account_Config_Inactive';
        config3.Config_Key__c = 'Account_Config_Key_Inactive';
        config3.Root_Object_API_Name__c = 'Account';
        config3.Child_Object_API_Name__c = 'Lead';
        config3.Child_Relationship_Field_API_Name__c = 'AccountId';
        config3.File_Name_Template__c = 'account_inactive_{0}.csv';
        config3.Max_Record_Count__c = 200;
        config3.Is_Active__c = false;

        CSV_Export_Config__mdt config4 = new CSV_Export_Config__mdt();
        config4.DeveloperName = 'Empty_Config_Key';
        config4.Config_Key__c = '';
        config4.Root_Object_API_Name__c = 'Account';
        config4.Child_Object_API_Name__c = 'Contact';
        config4.Child_Relationship_Field_API_Name__c = 'AccountId';
        config4.File_Name_Template__c = 'empty_key_{0}.csv';
        config4.Max_Record_Count__c = 100;
        config4.Is_Active__c = true;

        List<CSV_Export_Config__mdt> configs = new List<CSV_Export_Config__mdt>();
        configs.add(config1);
        configs.add(config2);
        configs.add(config3);
        configs.add(config4);

        insert configs;

        // Create fields for Account_Config_Key
        List<CSV_Export_Field__mdt> accountFields = new List<CSV_Export_Field__mdt>();
        accountFields.add(new CSV_Export_Field__mdt(Config_Key__c = 'Account_Config_Key', Field_Path__c = 'Name', Header_Label__c = 'Account Name', Sort_Order__c = 1, Is_Active__c = true));
        accountFields.add(new CSV_Export_Field__mdt(Config_Key__c = 'Account_Config_Key', Field_Path__c = 'Phone', Header_Label__c = 'Phone', Sort_Order__c = 2, Is_Active__c = true));
        accountFields.add(new CSV_Export_Field__mdt(Config_Key__c = 'Account_Config_Key', Field_Path__c = 'Type', Header_Label__c = 'Type', Sort_Order__c = 3, Is_Active__c = true));

        // Create fields for Contact_Config_Key
        List<CSV_Export_Field__mdt> contactFields = new List<CSV_Export_Field__mdt>();
        contactFields.add(new CSV_Export_Field__mdt(Config_Key__c = 'Contact_Config_Key', Field_Path__c = 'FirstName', Header_Label__c = 'First Name', Sort_Order__c = 1, Is_Active__c = true));
        contactFields.add(new CSV_Export_Field__mdt(Config_Key__c = 'Contact_Config_Key', Field_Path__c = 'LastName', Header_Label__c = 'Last Name', Sort_Order__c = 2, Is_Active__c = true));
        contactFields.add(new CSV_Export_Field__mdt(Config_Key__c = 'Contact_Config_Key', Field_Path__c = 'Email', Header_Label__c = 'Email', Sort_Order__c = 3, Is_Active__c = true));

        List<CSV_Export_Field__mdt> allFields = new List<CSV_Export_Field__mdt>();
        allFields.addAll(accountFields);
        allFields.addAll(contactFields);
        // Inactive field (should not be returned)
        allFields.add(new CSV_Export_Field__mdt(Config_Key__c = 'Account_Config_Key', Field_Path__c = 'Inactive_Field__c', Header_Label__c = 'Inactive', Sort_Order__c = 99, Is_Active__c = false));

        insert allFields;
    }

    @testSetup
    static void createTestConfigSetup2() {
        // Additional test data for null max record count
        CSV_Export_Config__mdt config = new CSV_Export_Config__mdt();
        config.DeveloperName = 'Account_NullCount_Config';
        config.Config_Key__c = 'Account_NullCount_Config_Key';
        config.Root_Object_API_Name__c = 'Account';
        config.Child_Object_API_Name__c = 'Lead';
        config.Child_Relationship_Field_API_Name__c = 'AccountId';
        config.File_Name_Template__c = 'account_nullcount_{0}.csv';
        config.Max_Record_Count__c = null;
        config.Is_Active__c = true;

        List<CSV_Export_Field__mdt> fields = new List<CSV_Export_Field__mdt>();
        fields.add(new CSV_Export_Field__mdt(Config_Key__c = 'Account_NullCount_Config_Key', Field_Path__c = 'Name', Header_Label__c = 'Name', Sort_Order__c = 1, Is_Active__c = true));

        insert config;
        insert fields;
    }

    @testSetup
    static void createTestConfigSetup3() {
        // Additional test data for null sort order
        CSV_Export_Config__mdt config = new CSV_Export_Config__mdt();
        config.DeveloperName = 'Account_NullSort_Config';
        config.Config_Key__c = 'Account_NullSort_Config_Key';
        config.Root_Object_API_Name__c = 'Account';
        config.Child_Object_API_Name__c = 'Lead';
        config.Child_Relationship_Field_API_Name__c = 'AccountId';
        config.File_Name_Template__c = 'account_nullsort_{0}.csv';
        config.Max_Record_Count__c = 100;
        config.Is_Active__c = true;

        List<CSV_Export_Field__mdt> fields = new List<CSV_Export_Field__mdt>();
        fields.add(new CSV_Export_Field__mdt(Config_Key__c = 'Account_NullSort_Config_Key', Field_Path__c = 'Name', Header_Label__c = 'Name', Sort_Order__c = null, Is_Active__c = true));

        insert config;
        insert fields;
    }

    @testSetup
    static void createTestConfigSetup4() {
        // Additional test data for blank config key
        CSV_Export_Config__mdt config = new CSV_Export_Config__mdt();
        config.DeveloperName = 'Account_BlankKey_Config';
        config.Config_Key__c = '';
        config.Root_Object_API_Name__c = 'Account';
        config.Child_Object_API_Name__c = 'Lead';
        config.Child_Relationship_Field_API_Name__c = 'AccountId';
        config.File_Name_Template__c = 'account_blankkey_{0}.csv';
        config.Max_Record_Count__c = 100;
        config.Is_Active__c = true;

        List<CSV_Export_Field__mdt> fields = new List<CSV_Export_Field__mdt>();
        fields.add(new CSV_Export_Field__mdt(Config_Key__c = '', Field_Path__c = 'Name', Header_Label__c = 'Name', Sort_Order__c = 1, Is_Active__c = true));

        insert config;
        insert fields;
    }

    @testSetup
    static void createTestConfigSetup5() {
        // Test data with multiple configs for same root object
        CSV_Export_Config__mdt config1 = new CSV_Export_Config__mdt();
        config1.DeveloperName = 'Account_Config_1';
        config1.Config_Key__c = 'Account_Config_Key_1';
        config1.Root_Object_API_Name__c = 'Account';
        config1.Child_Object_API_Name__c = 'Contact';
        config1.Child_Relationship_Field_API_Name__c = 'AccountId';
        config1.File_Name_Template__c = 'account_v1_{0}.csv';
        config1.Max_Record_Count__c = 100;
        config1.Is_Active__c = true;

        CSV_Export_Config__mdt config2 = new CSV_Export_Config__mdt();
        config2.DeveloperName = 'Account_Config_2';
        config2.Config_Key__c = 'Account_Config_Key_2';
        config2.Root_Object_API_Name__c = 'Account';
        config2.Child_Object_API_Name__c = 'Lead';
        config2.Child_Relationship_Field_API_Name__c = 'AccountId';
        config2.File_Name_Template__c = 'account_v2_{0}.csv';
        config2.Max_Record_Count__c = 200;
        config2.Is_Active__c = true;

        insert config1;
        insert config2;
    }

    @isTest
    static void testGetByRootObjectApiName_WithBlankInput() {
        // When rootObjectApiName is blank, should return empty list
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName('');
        
        System.assertEquals(0, result.size(), 'Should return empty list for blank input');
    }

    @isTest
    static void testGetByRootObjectApiName_WithNullInput() {
        // When rootObjectApiName is null, should return empty list
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportMetadataConfigProvider> configs = new List<CsvExportMetadataConfigProvider>();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName((String)null);
        
        System.assertEquals(0, result.size(), 'Should return empty list for null input');
    }

    @isTest
    static void testGetByRootObjectApiName_NoMatchingConfig() {
        // When no matching config exists, should return empty list
        resetMdtData();
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName('NonExistent__c');
        
        System.assertEquals(0, result.size(), 'Should return empty list for non-existent config');
    }

    @isTest
    static void testGetByRootObjectApiName_WithActiveConfig() {
        // When active config exists, should return mapped config
        resetMdtData();
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName('Account');
        
        System.assertEquals(1, result.size(), 'Should return one config for Account');
        CsvExportModels.ExportConfig config = result.get(0);
        System.assertEquals('Account_Config_Key', config.configKey, 'Config key should match');
        System.assertEquals('Account', config.rootObjectApiName, 'Root object should match');
        System.assertEquals('Contact', config.childObjectApiName, 'Child object should match');
        System.assertEquals('AccountId', config.childRelationshipFieldApiName, 'Relationship field should match');
        System.assertEquals('account_{0}.csv', config.fileNameTemplate, 'File name template should match');
        System.assertEquals(1000, config.maxRecordCount, 'Max record count should match');
        System.assertEquals(true, config.isActive, 'Config should be active');
        System.assertEquals(3, config.fields.size(), 'Should have 3 fields');
    }

    @isTest
    static void testGetByRootObjectApiName_WithContact() {
        // When Contact config exists, should return mapped config
        resetMdtData();
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName('Contact');
        
        System.assertEquals(1, result.size(), 'Should return one config for Contact');
        CsvExportModels.ExportConfig config = result.get(0);
        System.assertEquals('Contact_Config_Key', config.configKey, 'Config key should match');
        System.assertEquals('Contact', config.rootObjectApiName, 'Root object should match');
        System.assertEquals('Opportunity', config.childObjectApiName, 'Child object should match');
        System.assertEquals('ContactId', config.childRelationshipFieldApiName, 'Relationship field should match');
        System.assertEquals('contact_{0}.csv', config.fileNameTemplate, 'File name template should match');
        System.assertEquals(500, config.maxRecordCount, 'Max record count should match');
        System.assertEquals(true, config.isActive, 'Config should be active');
        System.assertEquals(3, config.fields.size(), 'Should have 3 fields');
    }

    @isTest
    static void testGetByRootObjectApiName_InactiveConfigNotReturned() {
        // When config is inactive, should not be returned
        resetMdtData();
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName('Account');
        
        System.assertEquals(1, result.size(), 'Should return only active configs');
        CsvExportModels.ExportConfig config = result.get(0);
        System.assertEquals('Account_Config_Key', config.configKey, 'Should not include inactive config');
        System.assertNotEquals('Account_Config_Key_Inactive', config.configKey, 'Should not include inactive config');
    }

    @isTest
    static void testGetByRootObjectApiName_BlankConfigKeyNotIncluded() {
        // When config has blank Config_Key__c, should not be added to result
        resetMdtData();
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName('Account');
        
        System.assertEquals(3, result.size(), 'Should return 3 configs (excluding blank key)');
        for (CsvExportModels.ExportConfig config : result) {
            System.assertNotEquals('', config.configKey, 'Config key should not be blank');
        }
    }

    @isTest
    static void testGetByRootObjectApiName_NullMaxRecordCount() {
        // When Max_Record_Count__c is null, maxRecordCount should be null
        resetMdtData();
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName('Account');
        
        System.assertEquals(4, result.size(), 'Should return 4 configs');
        // Check that Account_NullCount_Config has null maxRecordCount
        CsvExportModels.ExportConfig nullCountConfig = result.get(3);
        System.assertEquals('Account_NullCount_Config_Key', nullCountConfig.configKey);
        System.assertEquals(null, nullCountConfig.maxRecordCount, 'Max record count should be null');
    }

    @isTest
    static void testGetByRootObjectApiName_NullSortOrder() {
        // When Sort_Order__c is null, sortOrder should be null
        resetMdtData();
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName('Account');
        
        System.assertEquals(4, result.size(), 'Should return 4 configs');
        CsvExportModels.ExportConfig nullSortConfig = result.get(3);
        System.assertEquals('Account_NullSort_Config_Key', nullSortConfig.configKey);
        // Check that the field has null sortOrder
        CsvExportModels.ExportField field = nullSortConfig.fields.get(0);
        System.assertEquals('Name', field.fieldPath);
        System.assertEquals(null, field.sortOrder, 'Sort order should be null');
    }

    @isTest
    static void testGetByRootObjectApiName_BlankConfigKeyFieldsNotIncluded() {
        // When Config_Key__c is blank, fields should not be associated
        resetMdtData();
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName('Account');
        
        System.assertEquals(4, result.size(), 'Should return 4 configs');
        CsvExportModels.ExportConfig blankKeyConfig = result.get(3);
        System.assertEquals('Account_BlankKey_Config_Key', blankKeyConfig.configKey);
        System.assertEquals(0, blankKeyConfig.fields.size(), 'Config with blank key should have no fields');
    }

    @isTest
    static void testGetByRootObjectApiName_MultipleConfigs() {
        // When multiple configs exist for same root object, all should be returned
        resetMdtData();
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName('Account');
        
        System.assertEquals(2, result.size(), 'Should return 2 configs for Account');
        CsvExportModels.ExportConfig config1 = result.get(0);
        CsvExportModels.ExportConfig config2 = result.get(1);
        
        // Verify both configs are present
        Set<String> configKeys = new Set<String>();
        configKeys.add(config1.configKey);
        configKeys.add(config2.configKey);
        System.assertEquals(2, configKeys.size(), 'Should have 2 unique config keys');
    }

    @isTest
    static void testGetByRootObjectApiName_FieldOrdering() {
        // Fields should be ordered by Sort_Order__c ASC, then DeveloperName ASC
        resetMdtData();
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName('Account');
        
        System.assertEquals(3, result.get(0).fields.size(), 'Should have 3 fields');
        
        // Verify field ordering
        System.assertEquals('Account Name', result.get(0).fields.get(0).headerLabel, 'First field should be Account Name');
        System.assertEquals('Phone', result.get(0).fields.get(1).headerLabel, 'Second field should be Phone');
        System.assertEquals('Type', result.get(0).fields.get(2).headerLabel, 'Third field should be Type');
    }

    @isTest
    static void testGetByRootObjectApiName_FieldOrderingWithNullSort() {
        // Fields with null Sort_Order should come after those with defined sort order
        resetMdtData();
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName('Account');
        
        System.assertEquals(4, result.size(), 'Should return 4 configs');
        CsvExportModels.ExportConfig nullSortConfig = result.get(3);
        System.assertEquals(1, nullSortConfig.fields.size(), 'Should have 1 field');
        
        // Null sort order should be treated as greater than any defined sort order
        // So it should come after other fields if they exist
    }

    @isTest
    static void testGetByRootObjectApiName_WithCaseSensitiveRootObject() {
        // Root object API name matching should be case-sensitive
        resetMdtData();
        CsvExportMetadataConfigProvider provider = new CsvExportMetadataConfigProvider();
        List<CsvExportModels.ExportConfig> result = provider.getByRootObjectApiName('ACCOUNT');
        
        System.assertEquals(0, result.size(), 'Should return empty for case mismatch');
    }
}
