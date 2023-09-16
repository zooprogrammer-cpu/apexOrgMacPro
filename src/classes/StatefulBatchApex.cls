global class StatefulBatchApex implements Database.Batchable<sObject>, Database.Stateful {
    Integer accountsUpdated = 0; 

    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Inside the start method.');
        String query = 'SELECT Id, AccountNumber FROM Account WHERE AccountNumber = \'ZZZZZZ\'';
        return Database.getQueryLocator(query);
    }
    global void execute (Database.BatchableContext BC, List<Account> accList){
        System.debug('Inside the execute method.');
        for (Account acc : accList) {
                acc.AccountNumber = 'XXXXX';
                accountsUpdated = accountsUpdated + 1;    
        }
        update accList; 
    }
    global void finish (Database.BatchableContext BC){
        System.debug('Inside the finished method.') ; 
        System.debug('Number of accounts updated: ' + accountsUpdated);
  
    }
}