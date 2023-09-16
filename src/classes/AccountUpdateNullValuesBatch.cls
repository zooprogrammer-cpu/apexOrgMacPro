global class AccountUpdateNullValuesBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Inside the start method.');
        String query = 'SELECT Id, BillingCity, BillingState, BillingCountry, AccountNumber FROM Account WHERE AccountNumber = null OR BillingCity = null OR BillingState = null OR BillingCountry = null';
        return Database.getQueryLocator(query);
    }
    global void execute (Database.BatchableContext BC, List<Account> accList){
        System.debug('Inside the execute method.');
        for (Account acc : accList) {
            if(String.isBlank(acc.AccountNumber)){
                acc.AccountNumber = 'ZZZZZZ';    
            }
            if(String.isBlank(acc.BillingCity)){
                acc.BillingCity = 'Madison';    
            }
            if(String.isBlank(acc.BillingState)){
                acc.BillingState = 'WI';    
            }
            if(String.isBlank(acc.BillingCountry)){
                acc.BillingCountry = 'US';    
            }
        }
        update accList; 
    }
    global void finish (Database.BatchableContext BC){
        System.debug('Inside the finished method.') ;   
    }

}