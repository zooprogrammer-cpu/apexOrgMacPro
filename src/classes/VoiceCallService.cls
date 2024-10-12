/**
 * 
 */

public with sharing class VoiceCallService {
    private Query_VoiceCall voiceCallQuery;
    private DML_VoiceCall voiceCallDML;

    public VoiceCallService() {
        this(new Query_VoiceCall(), new DML_VoiceCall());
    }

    @TestVisible
    public VoiceCallService(Query_VoiceCall voiceCallQuery, DML_VoiceCall voiceCallDML) {
        this.voiceCallQuery = voiceCallQuery;
        this.voiceCallDML = voiceCallDML;
    }

    public  void  doVoiceCallUpdate(Set<Id> voiceCallIds) {
        List<VoiceCall> voiceCallList = voiceCallQuery.selectVoiceCalls(voiceCallIds);
        voicecallDML.updateVoiceCalls(voiceCallList);
    }
    
}