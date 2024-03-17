public with sharing class CloneRecordsController {
    // This controller will not have to care what kind of object it has to clone
    @AuraEnabled
    public static void cloneRecords(Id recordId, String className) {
        // Type class lets you make a class type
        Type cloneInterfaceType = Type.forName(className);
        CloneInterface cloneInterfaceInstance = (CloneInterface)cloneInterfaceType.newInstance();
        CloneRecordsService cloneRecords = new CloneRecordsService(cloneInterfaceInstance);
        cloneRecords.cloneRecord(recordId);
    }

    @AuraEnabled
    public static void cloneRelatedRecords(Id recordId, String className) {
        // Type class lets you make a class type
        Type cloneInterfaceType = Type.forName(className);
        CloneInterface cloneInterfaceInstance = (CloneInterface)cloneInterfaceType.newInstance();
        CloneRecordsService cloneRecords = new CloneRecordsService(cloneInterfaceInstance);
        cloneRecords.cloneRelatedRecords(recordId);
    }

}