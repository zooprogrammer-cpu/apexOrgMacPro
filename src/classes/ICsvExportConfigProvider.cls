public interface ICsvExportConfigProvider {
    List<CsvExportModels.ExportConfig> getByRootObjectApiName(String rootObjectApiName);
}
