public interface CloneInterface {
    void cloneRecord(Id recordId);
    void cloneRelatedRecords(Id recordId); // change to a set of Ids to bulkify

}