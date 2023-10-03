public with sharing class DataGenerationAccount {
    public static void createAccount (String accountName) {
        String accName = accountName;
        Account acc = new Account (
                Name = accName
        );

        insert acc;
    }

}