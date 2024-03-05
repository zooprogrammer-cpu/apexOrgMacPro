public Interface DisplayWrapper_Interface {
    // Anything that implements this interface has to implement these methods.
    List<SObject> getRecords();
    List<Object> wrapRecordsForUI(List<SObject> sObjectRecords);
}
