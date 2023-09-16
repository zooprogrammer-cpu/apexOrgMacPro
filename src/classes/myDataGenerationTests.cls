@isTest
public with sharing class myDataGenerationTests {
    @TestSetup
    static void loadMockDataFromStaticResource(){
        List<SObject> accList = Test.loadData(Account.SObjectType, 'mockData');   
    }
    @isTest
    static void testNumberOfAccounts() {
        List<Account> listToCheck = [SELECT Id FROM Account]; 
        System.assertEquals(15, listToCheck.size(), 'There are less thatn 15 accounts');   
    }
}