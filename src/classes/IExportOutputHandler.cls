public interface IExportOutputHandler {
    CsvExportModels.OutputSaveResult save(String fileTitle, String csvContent, Id linkToRecordId);
}
