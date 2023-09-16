@isTest
public with sharing class PositivePermission_tests {
  @TestSetup
  static void makeData() {
    Account a = TestFactory.getAccount('See everything', true);
    Private_Object__c po = new Private_Object__c(
      account__c = a.id,
      notes__c = 'bar'
    );
    insert po;
  }
  @isTest
  static void PermissionSetTest_Positive() {
    User u = new User(
      ProfileId = [SELECT Id FROM Profile WHERE Name = 'Custom User'].Id,
      LastName = 'last',
      Email = 'fancypants@fancy.com',
      Username = 'fancyp' + DateTime.now().getTime() + '@fancypants.com',
      Alias = 'fancyp',
      TimeZoneSidKey = 'America/Los_Angeles',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US'
    );

    System.runAs(u) {
      Private_Object__c[] pos;
      Test.startTest();
      pos = [SELECT Id, Account__c, notes__c FROM Private_Object__c];
      Test.stopTest();
      system.assert(
        pos.size() == 1,
        'a user with the permission set is not able to see the record'
      );
    }

  }
}