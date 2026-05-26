public interface ICsvGenerator {
    String generate(List<SObject> records, List<CsvExportModels.ExportField> fields);
}
