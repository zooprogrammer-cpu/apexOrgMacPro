/**
 * 
 */

public with sharing class DML_VoiceCall {
    public List<VoiceCall> updateVoiceCalls(List<VoiceCall> voiceCallList) {
        for (VoiceCall vc : voiceCallList) {
            vc.VendorCallKey = '12345';
        }
        Database.update(voiceCallList);
        return voiceCallList;
    }

}