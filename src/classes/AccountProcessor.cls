public with sharing class AccountProcessor {
  // @future
  public static void countContacts(List<Contact> contacts) {
    Set<Id> acctIds = new Set<Id>();

    for (Contact con : contacts) {
        if (con.AccountId != null) {
            acctIds.add(con.AccountId);
        }
    }

    List<Account> acctsToRollup = new List<Account>();

    for (AggregateResult ar : [SELECT AccountId AcctId, Count(Id) ContactCount FROM Contact WHERE AccountId IN: acctIds GROUP BY AccountId]) {
        Account acc = new Account();
        acc.Id = (Id) ar.get('AcctId');
        acc.Number_Of_Contacts__c = (Integer) ar.get('ContactCount');
        acctsToRollup.add(acc); 
        
    }

    update acctsToRollup; 
  }
}