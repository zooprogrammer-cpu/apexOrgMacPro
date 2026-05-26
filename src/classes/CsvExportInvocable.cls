public with sharing class CsvExportInvocable {
    @InvocableMethod(
            label='Generate Related CSV Files'
            description='Generates related-object CSV files from the current record using metadata configuration.'
    )
    public static List<Result> exportCsv(List<Request> requests) {
        List<CsvExportModels.ExportRequest> serviceRequests = new List<CsvExportModels.ExportRequest>();
        if (requests == null) {
            requests = new List<Request>();
        }

        for (Request request : requests) {
            CsvExportModels.ExportRequest mapped = new CsvExportModels.ExportRequest();
            mapped.rootRecordId = request.rootRecordId;
            serviceRequests.add(mapped);
        }

        CsvExportService service = new CsvExportService(
                new CsvExportMetadataConfigProvider(),
                new StandardCsvGenerator(),
                new ContentVersionExportOutputHandler()
        );
        List<CsvExportModels.ExportResult> serviceResults = service.process(serviceRequests);

        List<Result> outputs = new List<Result>();
        for (CsvExportModels.ExportResult serviceResult : serviceResults) {
            Result outVal = new Result();
            outVal.status = serviceResult.status;
            outVal.message = serviceResult.message;
            outVal.warnings = serviceResult.warnings;
            outVal.configKey = serviceResult.configKey;
            outVal.childObjectApiName = serviceResult.childObjectApiName;
            outVal.rootRecordId = serviceResult.rootRecordId;
            outVal.contentDocumentId = serviceResult.contentDocumentId;
            outVal.contentVersionId = serviceResult.contentVersionId;
            outVal.fileTitle = serviceResult.fileTitle;
            outVal.recordCount = serviceResult.recordCount;
            outputs.add(outVal);
        }

        return outputs;
    }

    public class Request {
        @InvocableVariable(label='Current Record Id' required=true)
        public Id rootRecordId;
    }

    public class Result {
        @InvocableVariable(label='Status')
        public String status;

        @InvocableVariable(label='Message')
        public String message;

        @InvocableVariable(label='Warnings')
        public String warnings;

        @InvocableVariable(label='Config Key')
        public String configKey;

        @InvocableVariable(label='Child Object API Name')
        public String childObjectApiName;

        @InvocableVariable(label='Root Record Id')
        public Id rootRecordId;

        @InvocableVariable(label='ContentDocumentId')
        public Id contentDocumentId;

        @InvocableVariable(label='ContentVersionId')
        public Id contentVersionId;

        @InvocableVariable(label='File Title')
        public String fileTitle;

        @InvocableVariable(label='Record Count')
        public Integer recordCount;
    }
}
