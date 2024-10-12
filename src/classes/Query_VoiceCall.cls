/**
 * 
 */

public with sharing class Query_VoiceCall {
    public List<VoiceCall> selectVoiceCalls(Set<Id> voiceCallIds) {
        return [SELECT Id, VendorCallKey FROM VoiceCall WHERE Id IN:voiceCallIds];
    }

}