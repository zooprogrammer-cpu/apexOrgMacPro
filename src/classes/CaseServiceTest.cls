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
        Case caseRecord = (Case)mockCase.setId().setField('Subject', 'Hello World!!').setField('Priority', 'Medium').build();  // call build takes the JSON generated in the MockSObjectBuilder
        List<Case> returnedCases = new List<Case>{caseRecord};
        Set<Id> caseIds = new Set<Id>{caseRecord.Id}; // these caseIds get passed to doCaseUpdate method below

        // Step 2: Define Constants - these are the methods we are calling
        final String CASE_QUERY_METHOD = 'selectCases';
        final String CASE_DML_METHOD = 'updateCases';

        // Step 3: Mock Dependencies
        UniversalMocker caseDML_Mock = UniversalMocker.mock(DML_Cases.class); //creates fake instance of DML_Cases class
        caseDML_Mock.when(CASE_DML_METHOD).withParamTypes(new List<Type>{List<Case>.class}).thenReturn(returnedCases); // when a list of cases is sent to CASE_DML_METHOD, fake returned response
        DML_Cases caseDML = (DML_Cases)caseDML_Mock.createStub(); // create a fake version of DML_Cases that we declared on line 21.

        UniversalMocker caseQuery_Mock = UniversalMocker.mock(Query_Cases.class);
        caseQuery_Mock.when(CASE_QUERY_METHOD).withParamTypes(new List<Type>{Set<Id>.class}).thenReturn(returnedCases); //fake returned response
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