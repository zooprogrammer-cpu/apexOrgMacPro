trigger AccountRecursionTrigger on Account (after insert, after update) {
    switch on Trigger.operationType {
        when AFTER_INSERT {
            System.debug('Running After Insert');
            AccountRecursionTriggerHandler.updateRelatedRatings(Trigger.new, Trigger.oldMap, Trigger.newMap);    
        }
        when AFTER_UPDATE {
            System.debug('Running After Update');
            AccountRecursionTriggerHandler.updateRelatedRatings(Trigger.new, Trigger.oldMap, Trigger.newMap);    
        }
    }
}