/**
 * 
 */

public with sharing class AccountUtilsInvocableApex {
    @InvocableMethod(Label='Get Account Info' Description='Get contacts and opportunities' IconName='slds:standard:account_info ')
    public static List<ActionResult> getContactsAndOpportunities(List<ActionRequest> inputs) {
        List<ActionResult> results = new List<ActionResult>();
        for (ActionRequest request : inputs) {
            results.add(invoke(request));
        }
        return results;
    }

    private static ActionResult invoke(ActionRequest input) {
        List<Contact> contacts = [
                SELECT Id, Name
                FROM Contact
                WHERE AccountId =: input.accountId
                WITH SECURITY_ENFORCED
                LIMIT 10
        ];
        List<Opportunity> opportunities = [
                SELECT Id, Name, Amount
                FROM Opportunity
                WHERE AccountId =:input.accountId
                WITH SECURITY_ENFORCED
                LIMIT 10
        ];

        ActionResult result = new ActionResult();
        result.contacts = contacts;
        result.opportunities = opportunities;
        return result;
    }

    public class ActionRequest {
        // Since we are using these classes as inputs, need to expose them
        @InvocableVariable(Label='Account Id' Required=true)
        public Id accountId;
    }

    public class ActionResult{
        // Since we are using these classes as outputs, need to expose them
        @InvocableVariable(Label='List of contacts')
        public List<Contact> contacts;
        @InvocableVariable(Label='List of opportunities')
        public List<Opportunity> opportunities;
    }

}