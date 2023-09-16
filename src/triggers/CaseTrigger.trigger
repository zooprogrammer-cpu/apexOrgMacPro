trigger CaseTrigger on Case(before insert, after insert, before update, after update) {
    switch on Trigger.operationType {
        // when BEFORE_INSERT{

        // }
        when AFTER_INSERT{
            CaseTriggerHandler.afterInsert(Trigger.new); 

        }
        
        // when BEFORE_UPDATE{

        // }
    }
}