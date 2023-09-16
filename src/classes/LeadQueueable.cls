public class LeadQueueable implements Queueable {
  public void execute(QueueableContext context) {
    List<Lead> existingRecords = [SELECT Id FROM Lead];
    //write async code
    for (Lead record : existingRecords) {
      record.LeadSource = 'Web';
    }
    update existingRecords;
  }
}