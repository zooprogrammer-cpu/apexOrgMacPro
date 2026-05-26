@IsTest
private class StandardCsvGeneratorTest {
    @IsTest
    static void generate_shouldBuildCsvWithHeadersRelationshipAndEscaping() {
        Account acct = new Account(Name = 'Acme, "HQ"');
        insert acct;

        Contact con = new Contact(
            LastName = 'Smith, "Jr"',
            AccountId = acct.Id,
            Description = 'Line1\nLine2\tTabbed'
        );
        insert con;

        Contact source = [
            SELECT LastName, Account.Name, Description
            FROM Contact
            WHERE Id = :con.Id
        ];

        CsvExportModels.ExportField f1 = new CsvExportModels.ExportField();
        f1.fieldPath = 'LastName';
        f1.queryPath = 'LastName';
        f1.headerLabel = 'Contact Name';

        CsvExportModels.ExportField f2 = new CsvExportModels.ExportField();
        f2.fieldPath = 'Account.Name';
        f2.queryPath = 'Account.Name';
        f2.headerLabel = '';

        CsvExportModels.ExportField f3 = new CsvExportModels.ExportField();
        f3.fieldPath = 'Description';
        f3.queryPath = 'Description';
        f3.headerLabel = 'Notes';

        List<CsvExportModels.ExportField> fields = new List<CsvExportModels.ExportField>{ f1, f2, f3 };

        StandardCsvGenerator generator = new StandardCsvGenerator();
        String csv = generator.generate(new List<SObject>{ source }, fields);

        String expectedHeader = String.join(
            new List<String>{
                'Contact Name'.escapeCsv(),
                'Account.Name'.escapeCsv(),
                'Notes'.escapeCsv()
            },
            ','
        );

        String normalizedDescription = source.Description.replaceAll('\r\n|\n|\r|\t', ' ');
        String expectedRow = String.join(
            new List<String>{
                source.LastName.escapeCsv(),
                source.Account.Name.escapeCsv(),
                normalizedDescription.escapeCsv()
            },
            ','
        );

        String expectedCsv = expectedHeader + '\r\n' + expectedRow + '\r\n';
        System.assertEquals(expectedCsv, csv, 'CSV output should include escaped headers, values, and CRLF line endings.');
    }

    @IsTest
    static void generate_shouldHandleNullRowsBlankPathsAndNullValues() {
        CsvExportModels.ExportField f1 = new CsvExportModels.ExportField();
        f1.fieldPath = 'Name';
        f1.queryPath = 'Name';
        f1.headerLabel = null;

        CsvExportModels.ExportField f2 = new CsvExportModels.ExportField();
        f2.fieldPath = 'BlankPath';
        f2.queryPath = '';
        f2.headerLabel = 'Blank';

        CsvExportModels.ExportField f3 = new CsvExportModels.ExportField();
        f3.fieldPath = 'Phone';
        f3.queryPath = 'Phone';
        f3.headerLabel = 'Phone';

        List<CsvExportModels.ExportField> fields = new List<CsvExportModels.ExportField>{ f1, f2, f3 };

        Account inMemory = new Account(Name = 'Plain Name');

        StandardCsvGenerator generator = new StandardCsvGenerator();
        String csv = generator.generate(new List<SObject>{ null, inMemory }, fields);

        String expectedHeader = 'Name,Blank,Phone';
        String expectedRow1 = ',,';
        String expectedRow2 = 'Plain Name,,';
        String expectedCsv = expectedHeader + '\r\n' + expectedRow1 + '\r\n' + expectedRow2 + '\r\n';

        System.assertEquals(expectedCsv, csv, 'CSV should gracefully handle null rows, blank query paths, and null field values.');
    }
}
