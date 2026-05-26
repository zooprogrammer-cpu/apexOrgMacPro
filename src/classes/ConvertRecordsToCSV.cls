/**
 * Created by ashbas on 2/3/26.
 * @description A utility class designed to convert a list of SObjects into a CSV-formatted string and store it as a ContentDocument in Salesforce. This class supports generating CSVs with customizable fields, including support for related object fields.
 */

global with sharing class ConvertRecordsToCSV {
    class GenerateCSVException extends Exception {}

    global enum CSVParseType {
        HEADERS_ONLY,
        ROWS_ONLY,
        ALL
    }

    global class Outputs {
        @AuraEnabled
        global String contentDocumentId; // Id for ContentDocument generated

        @AuraEnabled
        global String contentVersionId; // Id for ContentVersion generated

        @AuraEnabled
        global List<ContentDocumentLink> contentDocumentLinks; // If  linked record Ids are present this will return the related ContentDocumentLinks for each
    }

    /**
     * @description Generates a CSV string from a list of SObjects and stores it as a ContentDocument.
     * The CSV includes selected fields, with optional labels, and links the document to specified records.
     *
     * @param memberList A list of SObject records to convert into CSV format.
     * @return Outputs object containing:
     *         - contentDocumentId: ID of the generated ContentDocument.
     *         - contentVersionId: ID of the ContentVersion associated with the document.
     *         - contentDocumentLinks: List of ContentDocumentLink records created if linkedRecordIds are provided.
     * @throws AuraHandledException If CSV generation fails.
     */
    @AuraEnabled
    global static ConvertRecordsToCSV.Outputs generateCSV(List<SObject> memberList) {
        // Note: This controls what fields get extracted in the CSV File. Also need to add any new fields in the members list in MemberListController.cls
        List<String> fieldsCollection= new List<String>{'Id', 'Member__r.Id', 'Employee_Id__c','FACILITYID__c','Member__r.LastName','Member__r.FirstName','Member__r.MiddleName', 'Member__r.DOB__c','Member_Status_New__c','Member__r.PersonMobilePhone','Member__r.PersonEmail', 'Member__r.PersonMailingStreet', 'Member__r.PersonMailingCity', 'Member__r.PersonMailingState', 'Member__r.PersonMailingPostalCode', 'Hire_Date__c','Job_Classification__c', 'FT_PT__c', 'Work_Shift__c','Base_Wage__c', 'Last_Total_Hours_Worked__c','Leave_LOA_Date__c','Termination_Date__c'};

        if (memberList == null || memberList.size() == 0) {
            return new ConvertRecordsToCSV.Outputs();
        }

        String fullCSV = generateRecordsToCSV(
                memberList,
                fieldsCollection, // Use all populated fields
                CSVParseType.ALL,
                true // Use field labels
        );

        ConvertRecordsToCSV.Outputs returnVal = generateDocument(
                null, // No linked records
                'Member Facility Export ' + DateTime.now().format('yyyy-MM-dd HH-mm-ss'),
                'V', // Viewer permissions
                'AllUsers', // Visibility
                fullCSV
        );

        System.debug('returnVal: ' + returnVal);

        return returnVal;
    }

    /**
     * @description  Internal method to generate CSV content from a list of SObjects.
     * Handles both standard and related field extraction, including proper escaping.
     * Supports optional field labels and structured handling of compound fields.
     *
     * @param objectList The list of SObject records to serialize.
     * @param fieldList  A list of field API names to include. Can include dot notation for related objects.
     * @param parseType  Controls what part of the CSV to generate (headers only, rows only, or both).
     * @param useFieldLabels Whether to use field labels in header instead of API names.
     * @return A formatted CSV string with proper comma separation and escaping.
     */
    @TestVisible
    private static String generateRecordsToCSV(List<SObject> objectList, List<String> fieldList, CSVParseType parseType, Boolean useFieldLabels) {
        Set<String> columnHeaders = new Set<String>{};
        Map<String, String> fieldLabelMap = new Map<String, String>();
        List<String> rowElements = new List<String>{};

        String columnHeadersCSV = '';
        String rowElementsCSV = '';

        // Get the SObject type from the first record
        Schema.SObjectType sObjectType = objectList[0].getSObjectType();
        Map<String,Schema.SObjectField> allFields = sObjectType.getDescribe().fields.getMap();
        // If primary fields were provided, set them to the column values
        if (fieldList != null) {
            columnHeaders = new Set<String>(fieldList);
            // Create mapping of API names to Labels
            for(String fieldName : fieldList) {
                if(fieldName.contains('.')) {
                    // Handle related fields
                    List<String> fieldParts = fieldName.split('\\.');
                    Schema.SObjectType currentType = sObjectType;
                    String labelPath = '';

                    for(Integer i = 0; i < fieldParts.size(); i++) {
                        String part = fieldParts[i];
                        if(i < fieldParts.size() - 1) {
                            // Handle relationship field (ends with __r)
                            String relationshipFieldName = part.endsWith('__r') ? part.replace('__r', '__c') : part;
                            Schema.SObjectField relationshipField = currentType.getDescribe().fields.getMap().get(relationshipFieldName);
                            if(relationshipField != null && relationshipField.getDescribe().getReferenceTo().size() > 0) {
                                currentType = relationshipField.getDescribe().getReferenceTo()[0];
                                labelPath += relationshipField.getDescribe().getLabel() + ' . ';
                            }
                        } else {
                            Schema.SObjectField field = currentType.getDescribe().fields.getMap().get(part);
                            if(field != null) {
                                labelPath += field.getDescribe().getLabel();
                            }
                        }
                    }
                    fieldLabelMap.put(fieldName, labelPath);
                } else if(allFields.containsKey(fieldName)) {
                    fieldLabelMap.put(fieldName, allFields.get(fieldName).getDescribe().getLabel());
                }
            }
        } else {
            // If no primary fields are provided, add all populated fields
            for (SObject so: objectList) {
                Set<String> populatedFieldNames = new Set<String>{};
                Set<String> allFieldsKeySet = allFields.keySet();
                for (String field: so.getPopulatedFieldsAsMap().keySet()) {
                    if (allFieldsKeySet.contains(field.toLowerCase())) {
                        populatedFieldNames.add(field);
                        if(!fieldLabelMap.containsKey(field)) {
                            fieldLabelMap.put(field, allFields.get(field).getDescribe().getLabel());
                        }
                    }
                }
                columnHeaders.addAll(populatedFieldNames);
            }
        }

        if (parseType == CSVParseType.HEADERS_ONLY || parseType == CSVParseType.ALL) {
            List<String> headerList = new List<String>();
            for(String header : columnHeaders) {
                // Use the label if available, otherwise use the API name
                String headerText = useFieldLabels ? fieldLabelMap.get(header) : header;
                headerList.add(headerText);
            }
            columnHeadersCSV = String.join(headerList, ',') + '\n';
        }

        if (parseType == CSVParseType.ROWS_ONLY || parseType == CSVParseType.ALL) {
            for (SObject so: objectList) {
                String rowElement = '';
                for (String header: columnHeaders) {
                    if (header.contains('.')) { // Handle Related Fields
                        // pull related fields and add data
                        List<String> fieldComponents = header.split('\\.');
                        SObject traverse = so;
                        for (Integer i = 0; i < fieldComponents.size(); i++) {
                            String comp = fieldComponents[i];
                            if (i < fieldComponents.size() - 1) {
                                traverse = traverse.getSObject(comp);
                            } else if (traverse != null) {
                                // get field value for the last field component
                                Object fieldValue = traverse.get(comp);
                                if (fieldValue != null) {
                                    Schema.DisplayType fieldType = traverse.getSObjectType().getDescribe().fields.getMap().get(comp).getDescribe().getType();
                                    rowElement += getDisplayTextForFieldType(fieldValue, fieldType);
                                } else {
                                    rowElement += '';
                                }
                            } else {
                                rowElement += '';
                            }
                        }
                    } else if (so.get(header) != null) {
                        Object value = so.get(header);
                        Schema.SObjectField field = allFields.get(header);
                        if (field != null) {
                            Schema.DisplayType fieldType = field.getDescribe().getType();
                            rowElement += getDisplayTextForFieldType(value, fieldType);
                        } else {
                            rowElement += String.valueOf(value).replaceAll('\r\n|\n|\r|\t',' ').escapeCsv();
                        }
                    } else {
                        rowElement += '';
                    }
                    rowElement += ',';
                }
                rowElement = rowElement.removeEnd(',');
                rowElements.add(rowElement);
            }
            rowElementsCSV = String.join(rowElements, '\n') + '\n';
        }
        return columnHeadersCSV + rowElementsCSV;
    }

    /**
 * @description Creates a ContentDocument and ContentVersion from a given CSV content string.
 * Optionally links the document to specified records via ContentDocumentLink.
 *
 * @param linkedRecordIds Optional list of record IDs to link the document to.
 *                        If provided, ContentDocumentLink records will be created.
 * @param documentTitle The title of the generated document (e.g., export filename).
 * @param documentShareType The share type for the document link (e.g., 'V' for Viewer).
 * @param documentVisibility The visibility setting for the document (e.g., 'AllUsers').
 * @param content The CSV string to store as the document's content.
 * @return Outputs object with:
 *         - contentDocumentId: ID of the created ContentDocument.
 *         - contentVersionId: ID of the ContentVersion.
 *         - contentDocumentLinks: List of created ContentDocumentLink records if linkedRecordIds provided.
 * @throws GenerateCSVException If document creation fails.
 */
    global static ConvertRecordsToCSV.Outputs generateDocument(List<String> linkedRecordIds, String documentTitle, String documentShareType, String documentVisibility, String content) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = Blob.valueOf(content);
        cv.Title = documentTitle;
        cv.PathOnClient = documentTitle + '.csv';
        cv.IsMajorVersion = false;
        insert cv;

        // Is new document
        List<ContentDocument> doc = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId =: cv.Id LIMIT 1];
        if (doc.size() == 0) {
            throw new GenerateCSVException('Document failed to generate for CSV content.');
        }

        List<ContentDocumentLink> linkRecords = new List<ContentDocumentLink>{};
        if (linkedRecordIds != null) {
            for (String recordId: linkedRecordIds) {
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = doc[0].Id;
                cdl.LinkedEntityId = recordId;
                cdl.ShareType = documentShareType != null ? documentShareType : 'V';
                cdl.Visibility = documentVisibility != null ? documentVisibility : 'AllUsers';
                linkRecords.add(cdl);
            }
            insert linkRecords;
        }

        ConvertRecordsToCSV.Outputs returnVal = new ConvertRecordsToCSV.Outputs();
        returnVal.contentDocumentId=doc[0].Id;
        returnVal.contentVersionId=cv.Id;
        returnVal.contentDocumentLinks=linkRecords;
        return returnVal;
    }

    /**
     * Converts a field value to its string representation with appropriate CSV escaping.
     * Handles different data types like Date, DateTime, Address, Location, and general objects.
     *
     * @param fieldValue The value of the field to convert.
     * @param fieldType The schema type of the field (e.g., DATE, TEXT, ADDRESS).
     * @return The escaped string representation of the field value suitable for CSV.
     */
    public static String getDisplayTextForFieldType(Object fieldValue, Schema.DisplayType fieldType) {
        if (fieldType == Schema.DisplayType.ADDRESS || fieldType == Schema.DisplayType.LOCATION) {
            // handle compound fields
            return JSON.serialize(fieldValue).escapeCsv();
        } else if (fieldType == Schema.DisplayType.DATE) {
            Date dateValue = (Date)fieldValue;
            return String.valueOf(dateValue).escapeCsv();
        } else if (fieldType == Schema.DisplayType.DATETIME) {
            return String.valueOf(fieldValue).escapeCsv();
        } else {
            return String.valueOf(fieldValue).replaceAll('\r\n|\n|\r|\t',' ').escapeCsv();
        }
    }

    /**
 * @description  Deletes a ContentDocument and its associated ContentVersion based on the provided content document ID.
 * This method performs a hard delete (with cascade) of the ContentDocument and ContentVersion.
 *
 * @param contentDocumentId The ID of the ContentDocument to delete.
 * @throws AuraHandledException If an error occurs during deletion.
 */
    @AuraEnabled
    global static void deleteCSV(String contentDocumentId) {
        Database.DeleteResult deleteResult = Database.delete(contentDocumentId, true);
    }
}