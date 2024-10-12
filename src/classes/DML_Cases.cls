/**
 * 
 */

public with sharing class DML_Cases {
    public List<Case> updateCases(List<Case> caseList) {
        for (Case c : caseList) {
            c.Subject = 'The food is ready';
        }
        Database.update(caseList);
        return caseList;
    }
    // Original :
//    public List<Case> updateCases(List<Case> caseList) {
//        Database.update(caseList);
//        return caseList;
//    }

}