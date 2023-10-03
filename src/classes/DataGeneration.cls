public with sharing class DataGeneration {

    public static void createContact (String firstName, String lastName, String accountName){
        DataGenerationAccount.createAccount(accountName);
        List<Account> findAccount = [SELECT Id FROM Account WHERE Account.Name =:accountName];

//        String accName = 'Ash, LLC';
//        List<Account> accounts = [SELECT Id FROM Account WHERE Name =: accName];
        System.debug(findAccount[0]);
        Contact con = new Contact (
                AccountId = findAccount[0].Id,
                FirstName = firstName,
                LastName = lastName
        );
       insert con;
    }

}