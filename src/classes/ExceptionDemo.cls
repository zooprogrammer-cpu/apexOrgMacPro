public with sharing class ExceptionDemo {
    public class AWException extends Exception{}
    public static void updateOpp () {

        List<Opportunity> opps = [
                SELECT Id, Amount, Profile__c
                FROM Opportunity LIMIT 1
        ];

        try {
            //get opp record
            if (opps[0].Amount < 1000) {
                opps[0].Profile__c = 'Low';
                update opps[0];
            } else {
                throw new AWException('No won Opportunities');

            }

        } catch (Exception e) {
            AuraHandledException ahe = new AuraHandledException(e.getMessage());
            ahe.setMessage(e.getMessage());
            throw ahe;

        }

    }
}