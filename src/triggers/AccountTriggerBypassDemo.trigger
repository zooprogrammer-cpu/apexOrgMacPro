trigger AccountTriggerBypassDemo on Account (before update) {
    // Using Custom Switch
    Process_Switches__c processSwitch = Process_Switches__c.getInstance(UserInfo.getProfileId()); // get the value for the current user's profile
    if (!processSwitch.Account_Process_Bypass__c) { // We don't want to bypass the trigger switch
        System.debug('The trigger is going to run');
    }

    //Using Custom Metadata
//    String userName = UserInfo.getUserName();
    Boolean bypass = BypassTrigger.bypass ('Account_Trigger_Bypass_Switch', UserInfo.getUserName());
    System.debug('Bypass?' + bypass);

    if (!bypass) {
        System.debug('Trigger is going to run (Custom Switch');
    }

}