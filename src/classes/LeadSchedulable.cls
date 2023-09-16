public class LeadSchedulable implements Schedulable {
    public void execute(SchedulableContext sc) {
        List<Lead> existingRecords = [SELECT Id FROM Lead];
        //write async code
        for (Lead record : existingRecords) {
          record.LeadSource = 'Phone Inquiry';
        }
        update existingRecords;
      
    }
}