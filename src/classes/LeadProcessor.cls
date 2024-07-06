/**
 * 
 */

public with sharing class LeadProcessor {

    public static void updateLeadSource(List<Lead> listOfLeads) {
        for (Lead ld : listOfLeads) {
            ld.LeadSource ='Dreamforce';
        }

        update listOfLeads;
    }

}