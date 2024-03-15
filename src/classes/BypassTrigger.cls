/**
 * 
 */

public with sharing class BypassTrigger {
    public static Boolean bypass (String triggerName, String currentUserName) {
        Custom_Switch__mdt customSwitch = Custom_Switch__mdt.getInstance(triggerName);
        System.debug('customSwitch' + customSwitch);
        String customSwitchTriggerName = customSwitch.Trigger_Name__c;
        String customSwitchUserName = customSwitch.Bypass_User__c;
        Boolean customSwitchBypassEnabled = customSwitch.Bypass_Enabled__c;

        if (currentUserName == customSwitchUserName && customSwitchBypassEnabled ) {
            return true;
        } else {
            return false;
        }
    }
}