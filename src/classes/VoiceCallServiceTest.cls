/**
 *
 */

@IsTest
public with sharing class VoiceCallServiceTest {
    @IsTest
    private static void doVoiceCallUpdates_Test() {
        // Step 1: Setup Mock data
        MockSObjectBuilder mockVoiceCall= new MockSObjectBuilder(VoiceCall.getSObjectType());
        //setId creates an Id for the record.
        VoiceCall voiceCallRecord = (VoiceCall)mockVoiceCall.setId().setField('VendorCallKey', '12345').build();
        List<VoiceCall> returnedVoiceCallRecords = new List<VoiceCall>{voiceCallRecord};
        Set<Id> voiceCallIds = new Set<Id>{voiceCallRecord.Id};

        // Step 2: Define Constants
        final String VOICECALL_QUERY_METHOD = 'selectVoiceCalls';
        final String VOICECALL_DML_METHOD = 'updateVoiceCalls';

        // Step 3: Mock Dependencies
        UniversalMocker voicecallDML_Mock = UniversalMocker.mock(DML_VoiceCall.class);
        voicecallDML_Mock.when(VOICECALL_DML_METHOD).withParamTypes(new List<Type>{List<VoiceCall>.class}).thenReturn(returnedVoiceCallRecords);
        DML_VoiceCall voiceCallDML = (DML_VoiceCall)voicecallDML_Mock.createStub();

        UniversalMocker voicecallQuery_Mock = UniversalMocker.mock(Query_VoiceCall.class);
        voicecallQuery_Mock.when(VOICECALL_QUERY_METHOD).withParamTypes(new List<Type>{Set<Id>.class}).thenReturn(returnedVoiceCallRecords);
        Query_VoiceCall voiceCallQueries = (Query_VoiceCall)voicecallQuery_Mock.createStub();

        // Step 4: Test Execution
        Test.startTest();
        VoiceCallService vService = new VoiceCallService(voiceCallQueries, voiceCallDML);
        vService.doVoiceCallUpdate(voiceCallIds);
        voicecallDML_Mock.assertThat().method(VOICECALL_DML_METHOD)
                .withParamTypes(new List<Type>{List<VoiceCall>.class})
                .wasCalled(1, UniversalMocker.Times.EXACTLY);
        voicecallQuery_Mock.assertThat().method(VOICECALL_QUERY_METHOD)
                .withParamTypes(new List<Type>{Set<Id>.class})
                .wasCalled(1, UniversalMocker.Times.EXACTLY);
        Test.stopTest();

    }
}