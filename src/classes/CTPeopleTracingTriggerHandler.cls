public with sharing class CTPeopleTracingTriggerHandler {
    public static void beforeInsert(List<People_Tracing__c> newRecords) {
        List<People_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(newRecords);
        System.debug('Duplicate People Tracing Records: ' + duplicates);

        for (People_Tracing__c trace : duplicates) {
            trace.addError('Duplicate records found: ' + trace.Person_1__c + ' & ' + trace.Person_2__c);

        }
        
    }
   
}