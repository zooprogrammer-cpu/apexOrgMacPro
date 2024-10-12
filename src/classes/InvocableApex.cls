public with sharing class InvocableApex {
    @InvocableMethod(Label='Calculate Title Priorities' Description='Get Contacts and Calculate Title Priority')
    public static List<ActionResult> calculatePriorities(List<ActionRequest> inputs) {
        List<ActionResult> results = new List<ActionResult>();

        for (ActionRequest input : inputs) {
            //Extract the contact and account from the input
            Contact contact = input.contactObj;
            Account account = input.accountObj;

            //Process the contact and account
            ActionResult result = invoke(contact.Id, account.Id);
            results.add(result);

        }

        return results;

    }

    private static ActionResult invoke( Id contactId, Id accountId) {
        // Query the contact
        List<Contact> contacts = [SELECT Id, Name FROM Contact WHERE Id = :contactId];

        // Query the account
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id = :accountId];


        ActionResult result = new ActionResult();
        result.contacts = contacts;
        result.accounts = accounts;

        return result;

    }

    public class ActionRequest {
        @InvocableVariable(Label='List of Contacts')
        public Contact contactObj;

        @InvocableVariable(Label='List of Accounts')
        public Account accountObj;
    }


    public class ActionResult {
        @InvocableVariable(Label='List of Contacts')
        public List<Contact>contacts;

        @InvocableVariable(Label='List of Accounts')
        public List<Account> accounts;
    }

}