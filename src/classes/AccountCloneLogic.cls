public with sharing class AccountCloneLogic implements CloneInterface{
    // Need to have the methods from the CloneInterface
    public void cloneRecord(Id recordId){
        System.debug('This is the account clone logic running');

    }

    public void cloneRelatedRecords(Id recordId){
        System.debug('This is the account related records clone logic running');
    }
}