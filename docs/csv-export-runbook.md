# CSV Export (Metadata-Driven) Runbook

This runbook explains how admins configure and use the reusable Apex CSV export framework from **Screen Flow**.

## What this solution does

- Screen Flow calls invocable Apex: `CsvExportInvocable.exportCsv`
- Flow passes only the **current record Id** (`rootRecordId`)
- Apex derives the root object from that Id (for example, Account)
- Apex loads all active export configs for that root object from Custom Metadata
- Apex queries related child records (for example, Contacts, Opportunities)
- Apex generates **separate CSV files per config**
- Apex saves files as Salesforce Files and links each file to the root record
- Flow receives one output row per generated file/config

---

## Components

### Custom Metadata Types

### 1) `CSV_Export_Config__mdt`
One record = one related-object CSV export definition.

Fields:
- `Config_Key__c` (Text, unique, required)
- `Root_Object_API_Name__c` (Text, required)
  - Example: `Account`
- `Child_Object_API_Name__c` (Text, required)
  - Example: `Contact`, `Opportunity`
- `Child_Relationship_Field_API_Name__c` (Text, required)
  - Field on child object that points to root record
  - Example: `AccountId`
- `File_Name_Template__c` (Text, optional)
- `Max_Record_Count__c` (Number, optional, default 5000)
- `Is_Active__c` (Checkbox, required)

> Note: In this org, older field `Object_API_Name__c` may still exist. Current logic uses the root/child model above.

### 2) `CSV_Export_Field__mdt`
One record = one CSV column in one config.

Fields:
- `Config_Key__c` (Text, required; joins to config)
- `Field_Path__c` (Text, required)
  - Example: `Name`, `Owner.Email`
- `Header_Label__c` (Text, optional)
- `Sort_Order__c` (Number, optional but recommended)
- `Is_Active__c` (Checkbox, required)

---

## Apex components

- Invocable: `CsvExportInvocable`
- Service: `CsvExportService`
- Config provider: `CsvExportMetadataConfigProvider`
- CSV generator: `StandardCsvGenerator`
- Output handler: `ContentVersionExportOutputHandler`

Interfaces:
- `ICsvExportConfigProvider`
- `ICsvGenerator`
- `IExportOutputHandler`

---

## File name tokens (supported)

In `File_Name_Template__c`, supported tokens are:

- `{ConfigKey}`
- `{ObjectApiName}` (child object API name)
- `{Date}` => `yyyy-MM-dd`
- `{DateTime}` => `yyyy-MM-dd_HH-mm-ss`

Example:
- `Export_{ObjectApiName}_{DateTime}`

---

## Screen Flow usage

Add Apex Action: **Generate Related CSV Files**.

### Input

- `Current Record Id` (required)
  - Map to `$Record.Id` from the screen context

### Output (one row per config/file)

- `Status` (`SUCCESS`, `PARTIAL_SUCCESS`, `FAILED`)
- `Message`
- `Warnings`
- `Config Key`
- `Child Object API Name`
- `Root Record Id`
- `ContentDocumentId`
- `ContentVersionId`
- `File Title`
- `Record Count`

---

## Behavior rules

- No `rootRecordId` => `FAILED`
- No active config for root object => one `PARTIAL_SUCCESS` row
- Invalid/inaccessible child object or relationship field => `PARTIAL_SUCCESS` for that config
- Invalid/inaccessible configured CSV fields => skipped + warning
- No valid fields left => `PARTIAL_SUCCESS` (no file)
- No related records found => `PARTIAL_SUCCESS` (no file)
- Record count over max for a config => `FAILED` for that config
- Files are linked to root record only
- One execution can return multiple result rows (one per config)

---

## Admin steps to add a new related export

1. Create `CSV_Export_Config__mdt` record
   - Set `Config_Key__c` (unique)
   - Set `Root_Object_API_Name__c` (e.g., `Account`)
   - Set `Child_Object_API_Name__c` (e.g., `Case`)
   - Set `Child_Relationship_Field_API_Name__c` (e.g., `AccountId`)
   - Set filename template and max rows
   - Set `Is_Active__c = true`

2. Create `CSV_Export_Field__mdt` rows for that config
   - Same `Config_Key__c`
   - Set `Field_Path__c` for each column
   - Optional `Header_Label__c`
   - Set `Sort_Order__c`
   - Set `Is_Active__c = true`

3. Run screen flow action with current record Id.

---

## Included sample metadata

### Config 1: `ACC_DEFAULT_EXPORT`
- Root: `Account`
- Child: `Contact`
- Relationship field: `AccountId`
- Columns:
  - `Name` -> `Account Name`
  - `Owner.Email` -> `Owner Email`

### Config 2: `ACC_OPPTY_EXPORT`
- Root: `Account`
- Child: `Opportunity`
- Relationship field: `AccountId`
- Columns:
  - `Name` -> `Opportunity Name`
  - `StageName` -> `Stage`
  - `Amount` -> `Amount`

---

## Troubleshooting

- `FAILED` + `rootRecordId is required`
  - Ensure flow maps `$Record.Id`.

- `PARTIAL_SUCCESS` + `No active export configs`
  - Add active `CSV_Export_Config__mdt` for root object.

- `FAILED` + relationship field not found
  - Verify `Child_Relationship_Field_API_Name__c` exists on child object.

- `PARTIAL_SUCCESS` + warnings about field path
  - Fix typos or permissions for `Field_Path__c`.

- `PARTIAL_SUCCESS` + no related records
  - Confirm child records exist and are visible to running user.

## Why Interface?

- CsvExportService uses constructor injection for:
    - config source (ICsvExportConfigProvider)
    - CSV formatting (ICsvGenerator)
    - output destination (IExportOutputHandler)
-  CsvExportServiceTest.cls benefit: you stub provider/output and test business logic without depending on custom metadata or ContentVersion DML.
- These are real seams with likely variation:
    - metadata vs hardcoded config
    - ContentVersion vs email/callout/external storage output
    - alternate CSV formatting rules



