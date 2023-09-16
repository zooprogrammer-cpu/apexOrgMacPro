public with sharing class CTLocationTracingTriggerHandler {
    public static void beforeInsert(List<Location_Tracing__c> locationTraces) {
        List<Location_Tracing__c> duplicates = CTLocationTracingController.checkDuplicates(locationTraces);
        
        for (Location_Tracing__c trace : duplicates) {
            trace.addError('Duplicate records found: ' + 'Location Id: ' + trace.Location__c + ' Person Id: ' + trace.Person__c);
            
        }
    }
   
}