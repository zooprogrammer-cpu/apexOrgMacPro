public with sharing class CsvExportMetadataConfigProvider implements ICsvExportConfigProvider {
    public List<CsvExportModels.ExportConfig> getByRootObjectApiName(String rootObjectApiName) {
        List<CsvExportModels.ExportConfig> mappedConfigs = new List<CsvExportModels.ExportConfig>();
        if (String.isBlank(rootObjectApiName)) {
            return mappedConfigs;
        }

        List<CSV_Export_Config__mdt> configs = [
                SELECT DeveloperName, Config_Key__c, Root_Object_API_Name__c, Child_Object_API_Name__c,
                        Child_Relationship_Field_API_Name__c, File_Name_Template__c, Max_Record_Count__c, Is_Active__c
                FROM CSV_Export_Config__mdt
                WHERE Root_Object_API_Name__c = :rootObjectApiName
                    AND Is_Active__c = true
                ORDER BY DeveloperName ASC
        ];

        if (configs.isEmpty()) {
            return mappedConfigs;
        }

        Set<String> configKeys = new Set<String>();
        Map<String, CsvExportModels.ExportConfig> byKey = new Map<String, CsvExportModels.ExportConfig>();

        for (CSV_Export_Config__mdt cfg : configs) {
            CsvExportModels.ExportConfig mapped = new CsvExportModels.ExportConfig();
            mapped.configKey = cfg.Config_Key__c;
            mapped.rootObjectApiName = cfg.Root_Object_API_Name__c;
            mapped.childObjectApiName = cfg.Child_Object_API_Name__c;
            mapped.childRelationshipFieldApiName = cfg.Child_Relationship_Field_API_Name__c;
            mapped.fileNameTemplate = cfg.File_Name_Template__c;
            mapped.maxRecordCount = cfg.Max_Record_Count__c == null ? null : cfg.Max_Record_Count__c.intValue();
            mapped.isActive = cfg.Is_Active__c;

            if (!String.isBlank(mapped.configKey)) {
                configKeys.add(mapped.configKey);
                byKey.put(mapped.configKey, mapped);
                mappedConfigs.add(mapped);
            }
        }

        if (!configKeys.isEmpty()) {
            for (CSV_Export_Field__mdt f : [
                    SELECT Config_Key__c, Field_Path__c, Header_Label__c, Sort_Order__c, Is_Active__c
                    FROM CSV_Export_Field__mdt
                    WHERE Config_Key__c IN :configKeys
                        AND Is_Active__c = true
                    ORDER BY Sort_Order__c ASC, DeveloperName ASC
            ]) {
                if (!byKey.containsKey(f.Config_Key__c)) {
                    continue;
                }

                CsvExportModels.ExportField ef = new CsvExportModels.ExportField();
                ef.fieldPath = f.Field_Path__c;
                ef.headerLabel = f.Header_Label__c;
                ef.sortOrder = f.Sort_Order__c == null ? null : f.Sort_Order__c.intValue();
                byKey.get(f.Config_Key__c).fields.add(ef);
            }
        }

        return mappedConfigs;
    }
}
