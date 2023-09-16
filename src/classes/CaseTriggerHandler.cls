public with sharing class CaseTriggerHandler {
    public static void afterInsert(List<Case> caseList){
        for (Case cs : caseList) {
            SalesforceConnect.sendCasesToSalesforceOrgB(cs.Id);
        } 
    }
}