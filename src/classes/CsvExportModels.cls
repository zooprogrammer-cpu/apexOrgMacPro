public class CsvExportModels {
    public class ExportField {
        public String fieldPath;
        public String queryPath;
        public String headerLabel;
        public Integer sortOrder;
    }

    public class ExportConfig {
        public String configKey;
        public String rootObjectApiName;
        public String childObjectApiName;
        public String childRelationshipFieldApiName;
        public String fileNameTemplate;
        public Integer maxRecordCount;
        public Boolean isActive;
        public List<ExportField> fields = new List<ExportField>();
    }

    public class ExportRequest {
        public Id rootRecordId;
    }

    public class ExportResult {
        public String status;
        public String message;
        public String warnings;
        public String configKey;
        public String childObjectApiName;
        public Id rootRecordId;
        public Id contentDocumentId;
        public Id contentVersionId;
        public String fileTitle;
        public Integer recordCount;
    }

    public class OutputSaveResult {
        public Id contentDocumentId;
        public Id contentVersionId;
    }
}
