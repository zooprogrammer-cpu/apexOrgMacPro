trigger ContactTriggerMetadata on Contact (before insert, after delete , before delete, after update, before update) {
    // Option 1 : Object - specific execution control
    SObjectType triggerType = trigger.isDelete ? trigger.old.getSObjectType() : Trigger.new.getSObjectType(); // get the sObjectType
    Bypass__mdt bypass = Bypass__mdt.getInstance(triggerType.getDescribe().getLabel()); // new way to retrieve custom metadata
    System.debug('bypass:' + bypass);
    // Option 2 : global bypass
    Bypass__mdt globalbypass = Bypass__mdt.getInstance('Global'); // get global bypass
    System.debug('globalbypass' + globalbypass);
    if (bypass.Active__c || globalbypass.Active__c) return; // check both global and object bypass. Exit now and skip trigger logic
    // continue with trigger logic
    // .....
    System.debug('Continuing Trigger Logic');

}