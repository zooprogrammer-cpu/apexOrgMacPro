/**
 * 
 */

public with sharing class AccountAction {
    @InvocableMethod
    public static List<Decimal> updateAccRevenue (List<Id> oppIds ) {
        //fetching opportunity information
        List<Opportunity> oppList = [SELECT AccountId, Amount FROM Opportunity WHERE Id=: oppIds[0]];
        //fetching account information related to opportunity
        List<Account> accList = [SELECT Id, AnnualRevenue FROM Account WHERE Id =:oppList[0].AccountId];

        List<Decimal> annualRevenueList = new List<Decimal>();
        accList[0].AnnualRevenue = accList[0].AnnualRevenue + oppList[0].Amount;
        update accList;

        annualRevenueList.add(accList[0].AnnualRevenue);
        return annualRevenueList;

    }

}