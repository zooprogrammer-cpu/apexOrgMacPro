public with sharing class CloneRecordsService {
    // This class never changes
    // Dependency injection - I will pass my other classes
    // that this cloneRecordService class depends on to operate
    private CloneInterface cloneLogic;
    // constructor is called when you construct your class
    public CloneRecordsService(CloneInterface cloneClass) {
        //  "this" is the class you are in. Here it is CloneRecordService class
        this.cloneLogic = cloneClass;
    }

    public void cloneRecord(Id recordId) {
        cloneLogic.cloneRecord(recordId);
    }

    public void cloneRelatedRecords(Id recordId) {
        cloneLogic.cloneRelatedRecords(recordId);
    }

}