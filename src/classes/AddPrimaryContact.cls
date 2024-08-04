public without sharing class AddPrimaryContact implements Queueable {

    @TestVisible
    private static Boolean doChainJob = true;

    private Contact contact; 
    private String state; 
    public AddPrimaryContact(Contact inputContact, String inputState) {
        this.contact = inputContact; 
        this.state = inputState; 
    }

    public void execute(QueueableContext context){
        //Retreive 200 Account records
        List<Account> accounts = [SELECT Id FROM Account WHERE BillingState = :state LIMIT 200];

        //Create empty list of Contact records
        List<Contact> contacts = new List<Contact>();

        //Iterate through the account records
        for (Account acc : accounts) {
            //Clone (copy) the contact record, make the clone of a child of the specific account record
            // and add to the list of contacts
            Contact contactClone = contact.clone();
            contactClone.AccountId = acc.Id; 
            contacts.add(contactClone);
        }

        insert contacts;
        if (doChainJob) {
            System.enqueueJob(new AddPrimaryContactSecondQueueable(contacts));
        }
    }
}