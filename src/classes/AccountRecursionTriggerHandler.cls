public with sharing class AccountRecursionTriggerHandler {

  public static void updateRelatedRatings(List<Account> newList, Map<Id, Account> oldMap, Map<Id, Account> newMap) {
    // Use Map instead of List to avoid getting duplicate parent records during update
    // Two records could have same parent and we will get an error if we try to update same record as two entities in the same list
    Map<Id, Account> updateMap = new Map<Id, Account>();
    List<Account> ratingsChanged = new List<Account>();

    //update parent records
    Account oldRecord; 
    for (Account newAcct : newList) {
      System.debug('ACCOUNT RECORD: ' + newAcct.Name);
      if (Trigger.isInsert // if trigger is insert, we are going to automatically work with that record
           ||(Trigger.isUpdate //but if the trigger is an update, we are going to see if the raitng has changed
              && (newAcct.Rating != oldMap.get(newAcct.Id)?.Rating) // only if the rating has changed are we going to add the record to list of records to update 
              )
        ) {
            ratingsChanged.add(newAcct);
            if (newAcct.ParentId != null) {
                System.debug('update parent Id ' + newAcct.ParentId + ' rating to ' + newAcct.Rating + ' from child ' + newAcct.Name);
                updateMap.put( newAcct.ParentId, new Account(Id = newAcct.ParentId, Rating = newAcct.Rating));      
            }
        }
    }

    // update child records
    Account parent;
    // for child records , only records that we are interested  is where the ratings changed. 
    for (Account nextChild : [SELECT Id, ParentId FROM Account WHERE ParentId IN :ratingsChanged]) {
      parent = newMap.get(nextChild.ParentId);
      if (parent != null) {
        System.debug('update child ID ' + nextChild.Id + ' rating to ' + parent.Rating + ' from parent ' + parent.Name);
        updateMap.put( nextChild.Id, new Account(Id = nextChild.Id, Rating = parent.Rating));
      } else {
        System.debug('Did not find parent with ID' + nextChild.ParentId);
      }
      update updateMap.values();
    }
  }
}