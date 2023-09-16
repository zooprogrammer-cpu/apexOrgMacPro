@isTest
private class AccountWrapper_Tests {
  @testSetup
  static void loadTestData(){
    List<Account> accounts = (List<Account>) Test.loadData(Account.SObjectType, 'accountData');
    List<Opportunity> opps = new List<Opportunity>();
    for(Account a : accounts){
      opps.addAll(TestFactory.generateOppsForAccount(a.id, 1000.00, 5));
    }
    insert opps;
  }
  @isTest
  static void testPositiveRoundedAveragePrice() {
    List<AccountWrapper> accounts = new List<AccountWrapper>();
    for(Account a : [SELECT ID, Name FROM ACCOUNT]){
      accounts.add(new AccountWrapper(a));
    }
    // sanity check asserting that we have opportunities before executing our tested method.
    List<Opportunity> sanityCheckListOfOpps = [SELECT ID FROM Opportunity];
    System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue');
    Test.startTest();
      for(AccountWrapper a : accounts){
        System.assertEquals(a.getRoundedAvgPriceOfOpps(), 1000.00, 'Expected to get 1000.00');
      }
    Test.stopTest();
  }
  @isTest
    static void testHighPriority() {
        List<AccountWrapper> accounts = new List<AccountWrapper>();
    for(Account a : [SELECT ID, Name FROM ACCOUNT]){
      accounts.add(new AccountWrapper(a));
    }
    // sanity check asserting that we have opportunities before executing our tested method.
    // Also get Amount in the query and update the amount to 100000
    List<Opportunity> sanityCheckListOfOpps = [SELECT ID, Amount FROM Opportunity];
    System.assert(sanityCheckListOfOpps.size() > 0, 'You need an opportunity to continue');
    for (Opportunity opp : sanityCheckListOfOpps) {
        opp.Amount = 1000000000;     
    }
    // update the list of opportunities with the new amount values
    update sanityCheckListOfOpps; 
    Test.startTest();
      for(AccountWrapper a : accounts){
        System.assertEquals(a.isHighPriority(), true, 'Expected isHighPriority to return true');
      }
    Test.stopTest();
    
  }
}