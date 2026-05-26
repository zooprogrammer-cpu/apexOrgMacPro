public with sharing class StandardCsvGenerator implements ICsvGenerator {
    public String generate(List<SObject> records, List<CsvExportModels.ExportField> fields) {
        List<String> lines = new List<String>();
        List<String> headerCells = new List<String>();

        for (CsvExportModels.ExportField fieldDef : fields) {
            String header = String.isBlank(fieldDef.headerLabel) ? fieldDef.fieldPath : fieldDef.headerLabel;
            headerCells.add(escapeForCsv(header));
        }
        lines.add(String.join(headerCells, ','));

        for (SObject row : records) {
            List<String> cells = new List<String>();
            for (CsvExportModels.ExportField fieldDef : fields) {
                cells.add(getValueByPath(row, fieldDef.queryPath));
            }
            lines.add(String.join(cells, ','));
        }

        return String.join(lines, '\r\n') + '\r\n';
    }

    private static String getValueByPath(SObject recordRow, String path) {
        if (recordRow == null || String.isBlank(path)) {
            return '';
        }

        List<String> tokens = path.split('\\.');
        SObject current = recordRow;

        for (Integer i = 0; i < tokens.size() - 1; i++) {
            if (current == null) {
                return '';
            }
            current = current.getSObject(tokens[i]);
        }

        if (current == null) {
            return '';
        }

        Object raw = current.get(tokens[tokens.size() - 1]);
        if (raw == null) {
            return '';
        }

        return normalizeValue(raw).escapeCsv();
    }

    private static String normalizeValue(Object value) {
        String text = String.valueOf(value);
        return text.replaceAll('\r\n|\n|\r|\t', ' ');
    }

    private static String escapeForCsv(String text) {
        return (text == null ? '' : text).escapeCsv();
    }
}
