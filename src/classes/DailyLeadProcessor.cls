/**
 * 
 */

public with sharing class DailyLeadProcessor implements Schedulable {
    public void execute(SchedulableContext context) {
        List<Lead> leads = [SELECT Id FROM Lead WHERE LeadSource = NULL LIMIT 200];
        for (Lead ld : leads) {
            ld.LeadSource = 'Dreamforce';
        }
        update leads;
    }
}