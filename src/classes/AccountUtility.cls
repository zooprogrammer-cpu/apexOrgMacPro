public with sharing class AccountUtility {
    public void createSingleAccount(String n, String bc) {
        Account acc = new Account(Name = n , BillingCity = bc);
        insert acc;
        System.debug('Account inserted: ' + acc.id);
    }

    public void createMultipleAccounts(Integer numOfAccs, String name) {
        List<Account> accs = new List<Account>();    

       for (Integer i = 0; i < numOfAccs; i++) {
        Account acc = new Account(Name = name + + ' ' + i);
        accs.add(acc);  
       }
       insert accs; 
       System.debug('Multiple accounts inserted: ' + accs);
    }


    public void updateAccount(String n) {
        Account acc = [SELECT Id, Name, BillingCity, BillingCountry FROM Account WHERE Name = :n LIMIT 1];
        acc.BillingCity = 'Austin';
        acc.BillingState ='TX';
        acc.BillingCountry ='US';
        update acc;   
        System.debug('Account updated scuccessfully: ' + acc);
    }

    public void deleteAccounts(String n) {
        String accName = '%'+n+'%';
        List<Account> acctsToDelete = [SELECT Id, Name FROM Account WHERE Name LIKE :accName];   
        delete acctsToDelete; 
    }
}