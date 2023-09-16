public with sharing class CTLocationTriggerHandler {
  public static void beforeInsert(List<Location__c> newLocations) {
    for (Location__c loc : newLocations) {
      loc.Status__c = 'Green';
    }
  }

  public static void beforeUpdate(List<Location__c> newLocations, Map<Id, Location__c> oldLocationsMap ) {
    for (Location__c loc : newLocations) {
        if (loc.Status__c !=oldLocationsMap.get(loc.Id).Status__c){
            loc.Status_Update_Date__c = Date.today();
        }
    }
  }

  public static void afterUpdate(List<Location__c> newLocations, Map<Id, Location__c> oldLocationsMap) {
    // If Previous Status was not Red and the Current Status is now Red for location, add to statusChange set
    Set<Id> statusChange = new Set<Id>(); 
    for (Location__c loc : newLocations) {
        if (oldLocationsMap.get(loc.Id).Status__c != 'Red' && loc.Status__c == 'Red'){
          statusChange.add(loc.Id);
        }
    }
    System.debug('Locations that turned Red' + statusChange);
    
    // get the person records who have the same locations. 
    // Use the previously built query method in CTLocationTracingController.
    List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByLocationIds(statusChange);
    // From locationTraces, we need to get the personIds
    Set<Id> personIds = new Set<Id>();    
    for (Location_Tracing__c lt : locationTraces) {
      personIds.add(lt.Person__c);
    }
    System.debug('Person Ids with that location: ' + personIds);
    // Create the list of people to update and update the status for each of these people to Yellow
    List<Person__c> peopleToUpdate = new List<Person__c>();
    for (Id pId : personIds) {
      peopleToUpdate.add(new Person__c(Id = pId, Health_Status__c = 'Yellow'));
    } 
    if (peopleToUpdate.size() > 0){
      update peopleToUpdate;
    }
    System.debug('People to Update:' + peopleToUpdate);
  }
}