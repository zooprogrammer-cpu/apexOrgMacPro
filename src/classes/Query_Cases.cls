/**
 * 
 */

public with sharing class Query_Cases {
    public List<Case> selectCases(Set<Id> caseIds) {
        return   [SELECT Id, Subject FROM Case WHERE Id IN: caseIds];
    }
}