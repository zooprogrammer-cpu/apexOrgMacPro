trigger AccountTrigger on Account(before insert, before update) {
  switch on Trigger.operationType {
    when BEFORE_INSERT {
      System.debug('Switch - Before Insert');
      AccountTriggerHandler.processBeforeInsert(Trigger.new);
    }
    when BEFORE_UPDATE {
      System.debug('Switch - Before Update');
      AccountTriggerHandler.processBeforeUpdate(Trigger.newMap, Trigger.oldMap);
    }
  }
}