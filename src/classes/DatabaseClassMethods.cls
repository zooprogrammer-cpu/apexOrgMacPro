public with sharing class DatabaseClassMethods {
   public static void databaseDemo() {
        Savepoint sp = Database.setSavepoint();

        Integer numAccts = [SELECT count() FROM Account];
        System.debug('Total accounts before insert/update: ' + numAccts);

        List<Account> newOnes = new List<Account>();
        newOnes.add(new Account(Name = 'New 1'));
        newOnes.add(new Account(Name = 'New 2'));

        List<Account> existing = [SELECT Id FROM Account WHERE Rating = null];

        for (Account nextAcct : existing) {
            nextAcct.Rating = 'Cold';    
        }

        insert newOnes;
        // after insert, each element in newOnes now has a record Id in it
        update existing; 

        numAccts = [SELECT COUNT() FROM Account];
        System.debug('Total accounts after insert/update: '+ numAccts);

        delete newOnes; 

        numAccts = [SELECT COUNT() FROM Account]; 
        System.debug('Total accounts after delete: ' + numAccts);

        undelete newOnes; 

        numAccts = [SELECT COUNT() FROM Account];
        System.debug('Total accounts after undelete: ' + numAccts);

        // in the merge, the first record become the master record
        merge newOnes[0] newOnes[1];    

        numAccts = [SELECT COUNT() FROM Account];
        System.debug('Total accounts after merge: ' + numAccts);

        Database.rollback(sp);
        System.debug('Total accounts after rollback: ' + numAccts);


   }
}