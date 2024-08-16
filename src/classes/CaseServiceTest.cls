/**
 * 
 */

@IsTest
public with sharing class CaseServiceTest {
    @IsTest
    private static void doCaseUpdates_Test() {
        // Step 1: Setup Mock data
        MockSObjectBuilder mockCase = new MockSObjectBuilder(Case.getSObjectType());
        //setId creates an Id for the record.
        Case caseRecord = (Case)mockCase.setId().setField('Subject', 'Hello World!!').build();
        List<Case> returnedCases = new List<Case>{caseRecord};
        Set<Id> caseIds = new Set<Id>{caseRecord.Id};

        // Step 2: Define Constants
        final String CASE_QUERY_METHOD = 'selectCases';
        final String CASE_DML_METHOD = 'updateCases';

        // Step 3: Mock Dependencies
        UniversalMocker caseDML_Mock = UniversalMocker.mock(DML_Cases.class);
        caseDML_Mock.when(CASE_DML_METHOD).withParamTypes(new List<Type>{List<Case>.class}).thenReturn(returnedCases);
        DML_Cases caseDML = (DML_Cases)caseDML_Mock.createStub();

        UniversalMocker caseQuery_Mock = UniversalMocker.mock(Query_Cases.class);
        caseQuery_Mock.when(CASE_QUERY_METHOD).withParamTypes(new List<Type>{Set<Id>.class}).thenReturn(returnedCases);
        Query_Cases caseQueries = (Query_Cases)caseQuery_Mock.createStub();

        // Step 4: Test Execution
        Test.startTest();
        Case_Service caseService = new Case_Service(caseQueries, caseDML);
        caseService.doCaseUpdate(caseIds);
        caseDML_Mock.assertThat().method(CASE_DML_METHOD)
                .withParamTypes(new List<Type>{List<Case>.class})
                .wasCalled(1, UniversalMocker.Times.EXACTLY);
        caseQuery_Mock.assertThat().method(CASE_QUERY_METHOD)
                .withParamTypes(new List<Type>{Set<Id>.class})
                .wasCalled(1, UniversalMocker.Times.EXACTLY);
        Test.stopTest();

    }
}