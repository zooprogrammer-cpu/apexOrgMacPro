trigger PersonTrigger on Person__c (before insert, before update, before delete, 
after insert, after update, after delete, after undelete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            CTPersonTriggerHandler.beforeInsert(Trigger.new);
            System.debug('Before Insert');
        }
        else if (Trigger.isUpdate){
            System.debug('Before Update');
            CTPersonTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        else if (Trigger.isDelete){
            System.debug('Before Delete');
        }
        
    } else if (Trigger.isAfter){
        if (Trigger.isInsert) {
            System.debug('After Insert');
        }
        else if (Trigger.isUpdate) {
            System.debug('After Update');
            CTPersonTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        else if (Trigger.isDelete) {
            System.debug('After Delete');
        }
        else if (Trigger.isUndelete) {
            System.debug('After Undelete');
        }
    }

}