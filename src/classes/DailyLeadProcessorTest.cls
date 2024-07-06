/**
 * 
 */

@IsTest
private class DailyLeadProcessorTest {
    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2042';
    @IsTest
    static void testScheduledJob() {
        // Create leads without LeadSource -
        List<Lead> leads = new List<Lead>();
        for (Integer i=0 ; i < 200 ; i++) {
            Lead ld = new Lead(
                    FirstName = 'F Name' + i,
                    LastName = 'L Name' + i,
                    Company = 'Com LLC'
            );
            leads.add(ld);
        }
        insert leads;

        // Get the Ids of the Leads that we just inserted
        Map<Id, Lead> leadsMap = new Map<Id, Lead>([SELECT Id, LeadSource FROM Lead WHERE Id IN :leads]);
        List<Id> leadIds = new List<Id>(leadsMap.keySet());

        // Start the test
        Test.startTest();
        String jobId = System.schedule('ScheduleApexTest',
                CRON_EXP,
                new DailyLeadProcessor());

        // Verify the scheduled job has not run yet
        Integer counter = 0;
        for (Id leadId : leadIds) {
            Lead ld = leadsMap.get(leadId);
            if (ld.LeadSource != null) {
                counter ++;
            }
        }
        System.assertEquals(0, counter, 'Lead Source exists');

        // Stopping the test will run the job synchronously
        Test.stopTest();
        // Now that the scheduled job has executed,
        // check that our leads were updated
        counter = 0;
        List<Lead> leadsQueryResult = [SELECT Id, LeadSource FROM Lead WHERE Id IN :leadIds];
        for (Lead ld : leadsQueryResult) {
            if (ld.LeadSource == 'Dreamforce') {
                counter ++;
            }
        }

        System.assertEquals(200, counter, 'Lead source was not updated');


    }
}