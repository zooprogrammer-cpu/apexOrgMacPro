/**
 * 
 */

public with sharing class Case_Service {
    private Query_Cases caseQuery; // Dependency Injection: The Case_Service class depends on Query_Cases class and DML_Cases Class
    private DML_Cases caseDML;

    public Case_Service() {
        this(new Query_Cases(), new DML_Cases());
    }

    @TestVisible
    private Case_Service(Query_Cases caseQuery, DML_Cases caseDML) {  //pass the parameters in a constructor
        this.caseQuery = caseQuery;
        this.caseDML = caseDML;
    }

    public void doCaseUpdate(Set<Id> caseIds) {
        List<Case> caseList = caseQuery.selectCases(caseIds);
        caseDML.updateCases(caseList);
    }
//  Instead of having a query like this below in the class, use the above method so that mocking can be done.
//    public void findACase(Id caseId) {
//        List<Case> cases = [SELECT Id FROM Case WHERE Id=: caseId];
//    }

}