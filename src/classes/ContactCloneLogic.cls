public with sharing class ContactCloneLogic implements CloneInterface {
    public void cloneRecord(Id recordId) {
        System.debug('This is the contact clone logic running');
    }

    public void cloneRelatedRecords(Id recordId){
        System.debug('This is the contact clone related records logic running');
    }

}