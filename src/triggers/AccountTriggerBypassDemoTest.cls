/**
 * 
 */

@isTest
public class AccountTriggerBypassDemoTest {
    @isTest
    static void testAccountTriggerBypass() {

        Process_Switches__c ps = new Process_Switches__c();
        ps.Name = UserInfo.getProfileId();
        ps.Account_Process_Bypass__c = true;
        insert ps;

        Account acct = new Account();
        acct.Name = 'Test Account';
        acct.BillingStreet = 'Arlington';
        acct.BillingCity = 'VA';
        acct.AnnualRevenue = 100;
        insert acct;

        acct.AnnualRevenue = 200;
        update acct;
        // Assert.areEqual(200, [SELECT AnnualRevenue FROM Account WHERE Id =: acct.Id].AnnualRevenue);
    }
}