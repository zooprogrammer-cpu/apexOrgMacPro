public with sharing class AccountTriggerHandler {
  public static void processBeforeInsert(List<Account> newRecords) {
    System.debug('Handler - Before Insert');
    System.debug('BEGIN NEW RECORD LIST');
    showRecordList(newRecords);
  }

  public static void processBeforeUpdate(
    Map<Id, Account> newMap,
    Map<Id, Account> oldMap
  ) {
    System.debug('Handler - Before Update');
    System.debug('BEGIN NEW RECORD LIST (from Map)');
    showRecordList(newMap.values());
    System.debug('BEGIN OLD RECORD MAP');
    showRecordMap(oldMap);

    //check for change
    for (Id nextId : Trigger.newMap.keySet()) {
      didNameChange(oldMap.get(nextId), newMap.get(nextId));
    }
  }

  //print all new records list that are just going to be inserted
  private static void showRecordList(List<Account> acctList) {
    for (Account nextAcct : acctList) {
      System.debug(nextAcct);
    }
  }
  // pull keys from old records
  static void showRecordMap(Map<Id, Account> acctMap) {
    for (Id nextId : acctMap.keySet()) {
      System.debug('Key: ' + nextId);
      System.debug('value: ' + acctMap.get(nextId));
    }
  }

  // method to compare two records to each other.
  // Common use case for oldMap and newMap to compare if something about a record changed.
  // pass the recordId and check if the name changed between the old and the new

  static Boolean didNameChange(Account oldAcct, Account newAcct) {
    Boolean changed = false;

    if (oldAcct != null && newAcct != null) {
      changed = !oldAcct.Name.equalsIgnoreCase(newAcct.Name);
      System.debug('Record Changed: ' + changed);
    }
    return changed;
  }
}