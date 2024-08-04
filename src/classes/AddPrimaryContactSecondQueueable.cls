/**
 * 
 */

public with sharing class AddPrimaryContactSecondQueueable implements Queueable {
    private List<Contact>insertedContacts;
    public AddPrimaryContactSecondQueueable (List<Contact> insertedContacts) {
        this.insertedContacts = insertedContacts;

    }
    public void execute(QueueableContext context) {

    }
}