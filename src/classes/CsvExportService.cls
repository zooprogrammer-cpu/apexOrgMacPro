public with sharing class CsvExportService {
    public static final String STATUS_SUCCESS = 'SUCCESS';
    public static final String STATUS_PARTIAL_SUCCESS = 'PARTIAL_SUCCESS';
    public static final String STATUS_FAILED = 'FAILED';
    public static final Integer DEFAULT_MAX_RECORD_COUNT = 5000;

    private final ICsvExportConfigProvider configProvider;
    private final ICsvGenerator csvGenerator;
    private final IExportOutputHandler outputHandler;

    public CsvExportService(
            ICsvExportConfigProvider configProvider,
            ICsvGenerator csvGenerator,
            IExportOutputHandler outputHandler
    ) {
        this.configProvider = configProvider;
        this.csvGenerator = csvGenerator;
        this.outputHandler = outputHandler;
    }

    public List<CsvExportModels.ExportResult> process(List<CsvExportModels.ExportRequest> requests) {
        List<CsvExportModels.ExportResult> results = new List<CsvExportModels.ExportResult>();
        if (requests == null || requests.isEmpty()) {
            results.add(fail(new CsvExportModels.ExportResult(), 'No requests provided.'));
            return results;
        }

        for (CsvExportModels.ExportRequest request : requests) {
            results.addAll(processSingleRequest(request));
        }
        return results;
    }

    private List<CsvExportModels.ExportResult> processSingleRequest(CsvExportModels.ExportRequest request) {
        List<CsvExportModels.ExportResult> results = new List<CsvExportModels.ExportResult>();

        if (request == null || request.rootRecordId == null) {
            results.add(fail(new CsvExportModels.ExportResult(), 'rootRecordId is required.'));
            return results;
        }

        String rootObjectApiName = request.rootRecordId.getSObjectType().getDescribe().getName();
        List<CsvExportModels.ExportConfig> configs = configProvider.getByRootObjectApiName(rootObjectApiName);

        if (configs == null || configs.isEmpty()) {
            CsvExportModels.ExportResult noConfig = new CsvExportModels.ExportResult();
            noConfig.rootRecordId = request.rootRecordId;
            results.add(partialNoFile(noConfig, new List<String>(),
                    'No active export configs found for root object: ' + rootObjectApiName));
            return results;
        }

        for (CsvExportModels.ExportConfig config : configs) {
            results.add(processConfig(request.rootRecordId, rootObjectApiName, config));
        }

        return results;
    }

    private CsvExportModels.ExportResult processConfig(
            Id rootRecordId,
            String rootObjectApiName,
            CsvExportModels.ExportConfig config
    ) {
        CsvExportModels.ExportResult result = new CsvExportModels.ExportResult();
        result.rootRecordId = rootRecordId;
        result.configKey = config == null ? null : config.configKey;
        result.childObjectApiName = config == null ? null : config.childObjectApiName;

        List<String> warnings = new List<String>();

        try {
            if (config == null) {
                return fail(result, 'Config was null.');
            }
            if (config.isActive != true) {
                return partialNoFile(result, warnings, 'Config is inactive: ' + config.configKey);
            }
            if (!equalsIgnoreCase(config.rootObjectApiName, rootObjectApiName)) {
                return fail(result, 'Config root object does not match request root object.');
            }
            if (String.isBlank(config.childObjectApiName)) {
                return fail(result, 'Config Child_Object_API_Name__c is required.');
            }
            if (String.isBlank(config.childRelationshipFieldApiName)) {
                return fail(result, 'Config Child_Relationship_Field_API_Name__c is required.');
            }

            Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
            Schema.SObjectType childType = globalDescribe.get(config.childObjectApiName);
            if (childType == null) {
                return partialNoFile(result, warnings,
                        'Child object not found: ' + config.childObjectApiName);
            }

            Schema.DescribeSObjectResult childDescribe = childType.getDescribe();
            if (!childDescribe.isAccessible()) {
                return partialNoFile(result, warnings,
                        'Child object not accessible: ' + config.childObjectApiName);
            }

            String relationshipFieldApi = findFieldApiName(
                    childDescribe.fields.getMap(),
                    config.childRelationshipFieldApiName
            );
            if (String.isBlank(relationshipFieldApi)) {
                return fail(result, 'Relationship field not found on child object: ' + config.childRelationshipFieldApiName);
            }

            Schema.DescribeFieldResult relationshipFieldDescribe = childDescribe.fields.getMap().get(relationshipFieldApi).getDescribe();
            if (!relationshipFieldDescribe.isAccessible()) {
                return partialNoFile(result, warnings,
                        'Relationship field not accessible: ' + relationshipFieldApi);
            }

            Integer maxRows = config.maxRecordCount == null || config.maxRecordCount <= 0
                    ? DEFAULT_MAX_RECORD_COUNT
                    : config.maxRecordCount;

            List<CsvExportModels.ExportField> selectedFields = new List<CsvExportModels.ExportField>();
            for (CsvExportModels.ExportField configuredField : config.fields) {
                FieldPathResolution resolution = resolveFieldPath(childType, configuredField.fieldPath);
                if (!resolution.valid) {
                    warnings.add('Invalid field path skipped: ' + configuredField.fieldPath);
                    continue;
                }
                if (!resolution.accessible) {
                    warnings.add('Inaccessible field path skipped: ' + configuredField.fieldPath);
                    continue;
                }

                CsvExportModels.ExportField selected = new CsvExportModels.ExportField();
                selected.fieldPath = configuredField.fieldPath;
                selected.queryPath = resolution.normalizedPath;
                selected.sortOrder = configuredField.sortOrder;
                selected.headerLabel = String.isBlank(configuredField.headerLabel)
                        ? resolution.defaultLabel
                        : configuredField.headerLabel;
                selectedFields.add(selected);
            }

            if (selectedFields.isEmpty()) {
                return partialNoFile(result, warnings, 'No valid and accessible fields configured.');
            }

            List<String> selectColumns = new List<String>{ 'Id', relationshipFieldApi };
            for (CsvExportModels.ExportField f : selectedFields) {
                if (!String.isBlank(f.queryPath) && !selectColumns.contains(f.queryPath)) {
                    selectColumns.add(f.queryPath);
                }
            }

            String soql = 'SELECT ' + String.join(selectColumns, ',')
                    + ' FROM ' + config.childObjectApiName
                    + ' WHERE ' + relationshipFieldApi + ' = :rootRecordId'
                    + ' ORDER BY Id'
                    + ' LIMIT ' + (maxRows + 1);

            List<SObject> records = Database.query(soql);
            if (records.size() > maxRows) {
                return fail(result, 'Records exceed max allowed (' + maxRows + ') for config ' + config.configKey + '.');
            }

            result.recordCount = records.size();
            if (records.isEmpty()) {
                warnings.add('No related records found.');
                return partialNoFile(result, warnings, 'No records exported for config ' + config.configKey + '.');
            }

            String csv = csvGenerator.generate(records, selectedFields);
            String fileTitle = resolveFileName(config, config.childObjectApiName);
            CsvExportModels.OutputSaveResult saved = outputHandler.save(fileTitle, csv, rootRecordId);

            result.contentDocumentId = saved.contentDocumentId;
            result.contentVersionId = saved.contentVersionId;
            result.fileTitle = fileTitle;
            result.status = warnings.isEmpty() ? STATUS_SUCCESS : STATUS_PARTIAL_SUCCESS;
            result.message = warnings.isEmpty() ? 'Export completed.' : 'Export completed with warnings.';
            result.warnings = warnings.isEmpty() ? null : String.join(warnings, ' | ');
            return result;
        } catch (Exception e) {
            return fail(result, e.getMessage());
        }
    }

    private static CsvExportModels.ExportResult partialNoFile(
            CsvExportModels.ExportResult result,
            List<String> warnings,
            String message
    ) {
        result.status = STATUS_PARTIAL_SUCCESS;
        result.message = message;
        result.warnings = warnings.isEmpty() ? null : String.join(warnings, ' | ');
        return result;
    }

    private static CsvExportModels.ExportResult fail(CsvExportModels.ExportResult result, String message) {
        result.status = STATUS_FAILED;
        result.message = message;
        return result;
    }

    private static String resolveFileName(CsvExportModels.ExportConfig config, String objectApiName) {
        String template = String.isBlank(config.fileNameTemplate)
                ? 'Export_{ObjectApiName}_{DateTime}'
                : config.fileNameTemplate;

        String datePart = Datetime.now().format('yyyy-MM-dd');
        String dateTimePart = Datetime.now().format('yyyy-MM-dd_HH-mm-ss');

        return template
                .replace('{ConfigKey}', config.configKey)
                .replace('{ObjectApiName}', objectApiName)
                .replace('{Date}', datePart)
                .replace('{DateTime}', dateTimePart);
    }

    private static Boolean equalsIgnoreCase(String a, String b) {
        return String.valueOf(a).toLowerCase() == String.valueOf(b).toLowerCase();
    }

    private static FieldPathResolution resolveFieldPath(Schema.SObjectType rootType, String configuredPath) {
        FieldPathResolution result = new FieldPathResolution();
        if (rootType == null || String.isBlank(configuredPath)) {
            return result;
        }

        List<String> tokens = configuredPath.split('\\.');
        if (tokens.isEmpty()) {
            return result;
        }

        Schema.SObjectType currentType = rootType;
        List<String> normalizedTokens = new List<String>();
        List<String> labelTokens = new List<String>();

        for (Integer i = 0; i < tokens.size(); i++) {
            String token = tokens[i] == null ? null : tokens[i].trim();
            if (String.isBlank(token)) {
                return result;
            }

            Boolean isLast = i == tokens.size() - 1;
            if (!isLast) {
                RelationshipResolution rr = resolveRelationship(currentType, token);
                if (rr == null || rr.referenceType == null) {
                    return result;
                }
                if (rr.relationshipFieldDescribe != null && !rr.relationshipFieldDescribe.isAccessible()) {
                    result.valid = true;
                    result.accessible = false;
                    return result;
                }

                normalizedTokens.add(rr.relationshipName);
                labelTokens.add(rr.relationshipLabel);
                currentType = rr.referenceType;
            } else {
                Map<String, Schema.SObjectField> fieldMap = currentType.getDescribe().fields.getMap();
                String finalApiName = findFieldApiName(fieldMap, token);
                if (String.isBlank(finalApiName)) {
                    return result;
                }

                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(finalApiName).getDescribe();
                result.valid = true;
                result.accessible = fieldDescribe.isAccessible();
                result.normalizedPath = normalizedTokens.isEmpty()
                        ? finalApiName
                        : String.join(normalizedTokens, '.') + '.' + finalApiName;
                labelTokens.add(fieldDescribe.getLabel());
                result.defaultLabel = String.join(labelTokens, ' . ');
                return result;
            }
        }

        return result;
    }

    private static RelationshipResolution resolveRelationship(Schema.SObjectType sourceType, String token) {
        Map<String, Schema.SObjectField> fieldMap = sourceType.getDescribe().fields.getMap();

        Schema.SObjectField resolvedField;
        Schema.DescribeFieldResult fieldDescribe;

        String relationshipFieldApi = token.endsWith('__r')
                ? token.substring(0, token.length() - 3) + '__c'
                : token;

        String directFieldApi = findFieldApiName(fieldMap, relationshipFieldApi);
        if (!String.isBlank(directFieldApi)) {
            resolvedField = fieldMap.get(directFieldApi);
            fieldDescribe = resolvedField.getDescribe();
        } else {
            for (Schema.SObjectField sf : fieldMap.values()) {
                Schema.DescribeFieldResult d = sf.getDescribe();
                if (d.getRelationshipName() != null && d.getRelationshipName().toLowerCase() == token.toLowerCase()) {
                    resolvedField = sf;
                    fieldDescribe = d;
                    break;
                }
            }
        }

        if (fieldDescribe == null || fieldDescribe.getReferenceTo().isEmpty()) {
            return null;
        }

        RelationshipResolution rr = new RelationshipResolution();
        rr.relationshipFieldDescribe = fieldDescribe;
        rr.relationshipName = fieldDescribe.getRelationshipName();
        rr.relationshipLabel = fieldDescribe.getLabel();
        rr.referenceType = fieldDescribe.getReferenceTo()[0];
        return rr;
    }

    private static String findFieldApiName(Map<String, Schema.SObjectField> fieldMap, String candidate) {
        if (String.isBlank(candidate) || fieldMap == null) {
            return null;
        }
        if (fieldMap.containsKey(candidate)) {
            return candidate;
        }
        for (String key : fieldMap.keySet()) {
            if (key.toLowerCase() == candidate.toLowerCase()) {
                return key;
            }
        }
        return null;
    }

    private class FieldPathResolution {
        Boolean valid = false;
        Boolean accessible = false;
        String normalizedPath;
        String defaultLabel;
    }

    private class RelationshipResolution {
        Schema.DescribeFieldResult relationshipFieldDescribe;
        String relationshipName;
        String relationshipLabel;
        Schema.SObjectType referenceType;
    }
}
