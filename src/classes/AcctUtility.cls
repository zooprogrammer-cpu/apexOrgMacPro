public with sharing class AcctUtility {
    public static void mainProcessing() {
        try{
            insertAccount(); 
        }
        catch(AcctException ae){
            System.debug('Message: ' + ae.getMessage());
            System.debug('Cause: ' + ae.getCause());
            System.debug('Line Number: ' + ae.getLineNumber());

        }
        
    }

    public static void insertAccount() {
        try {
            Account acc = new Account();  
            insert acc;       
        } catch (DmlException de) {
            throw new AcctException('Account cannot be created since the required fields are missing' + de);
        }
        
    }
}