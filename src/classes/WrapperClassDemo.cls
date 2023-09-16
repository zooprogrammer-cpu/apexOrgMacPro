public with sharing class WrapperClassDemo {

    // this is the method that returns a list of the AccountContactWrapperClass Object
    @AuraEnabled (cacheable = true)
    public static List<AccountContactWrapperClass> fetchAccountContactDetails() {
        List<AccountContactWrapperClass> accConWrapperList = new List<AccountContactWrapperClass>();

        for (Account acc : [SELECT Id, Name, Type, BillingStreet, BillingCity, BillingCountry,
                                (SELECT Id FROM Contacts) 
                                FROM Account WHERE Name !=null AND BillingStreet != null ORDER BY Name LIMIT 10 ]) {
            accConWrapperList.add(new AccountContactWrapperClass(acc, acc.Contacts.size()));  
        }
        return accConWrapperList; 
    }

    public class AccountContactWrapperClass{
        @AuraEnabled
        public Account acc; 
        @AuraEnabled
        public Integer totalContacts; 
        @AuraEnabled
        public String billingAddress; 
        @AuraEnabled
        public String type; 
        @AuraEnabled
        public String accountName; 
        @AuraEnabled
        public String accountLink; 
        
        //constructor to add value to the wrapper class
        //just passung acc and totalContacts here since we can get the rest from acc

        public AccountContactWrapperClass(Account acc, Integer totalContacts){
            this.acc = acc; 
            this.totalContacts = totalContacts; 
            this.accountLink = '/'+ acc.Id; 
            this.type = acc.type; 
            this.accountName = acc.Name;
            this.billingAddress = acc.BillingStreet + ',' + acc.BillingCity + ',' + acc.BillingCountry;

        }


    }




}