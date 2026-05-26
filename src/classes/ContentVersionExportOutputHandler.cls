public with sharing class ContentVersionExportOutputHandler implements IExportOutputHandler {
    public CsvExportModels.OutputSaveResult save(String fileTitle, String csvContent, Id linkToRecordId) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = Blob.valueOf(csvContent);
        cv.Title = fileTitle;
        cv.PathOnClient = fileTitle + '.csv';
        cv.IsMajorVersion = false;
        insert cv;

        cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];

        if (linkToRecordId != null) {
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cv.ContentDocumentId;
            cdl.LinkedEntityId = linkToRecordId;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl;
        }

        CsvExportModels.OutputSaveResult outVal = new CsvExportModels.OutputSaveResult();
        outVal.contentDocumentId = cv.ContentDocumentId;
        outVal.contentVersionId = cv.Id;
        return outVal;
    }
}
