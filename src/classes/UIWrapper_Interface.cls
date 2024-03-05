public interface UIWrapper_Interface
{
    List<SObject> getRecords();
    List<Object> wrapRecordsForUI(List<SObject> sObjectRecords);
}