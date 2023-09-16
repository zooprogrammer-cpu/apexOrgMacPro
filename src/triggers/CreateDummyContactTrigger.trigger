trigger CreateDummyContactTrigger on Account (after insert, before insert, before delete) {
    if (Trigger.isAfter && Trigger.isInsert) {
        List<Contact> contactList = new List<Contact>();
        for (Account acc : Trigger.new) {
            Contact con = new Contact();
            con.AccountId = acc.Id; 
            con.FirstName = 'Dummy'; 
            con.LastName = acc.Name; 
            contactList.add(con);
        }
        insert contactList;     
    }

    else if (Trigger.isBefore){
        if (Trigger.isDelete) {
            Set<Id> acctIdSet = new Set<Id>();  
            //Bulkify trigger - when multiple accounts are being deleted at same time, 
            //Trigger.old gives all accounts that are being deleted 
            //Add all those account Ids to accIdSet
            for (Account acc : Trigger.old) {
                acctIdSet.add(acc.Id);     
            } 
            // get all account and contacts using parent to child inner query where Account Id is avaailable in the set
            // put the result of this into a variable of variable
            Map<Id, Account> accts = new Map<Id, Account>([SELECT Id, Name, (SELECT Id FROM Contacts ) 
                                                        FROM Account WHERE Id IN: acctIdSet]);
            for (Account acc : Trigger.old) {
                if(accts.get(acc.id).Contacts.size() > 0){
                    acc.addError('Account cannot be deleted since it has contacts associated with it. ');
                } 
            }                                                                                         
        }

        else if (Trigger.isInsert){
            for (Account acc : Trigger.new) {
                if (String.isBlank(acc.BillingCity)) {
                    acc.BillingCity = 'Madison';    
                }
                if (String.isBlank(acc.BillingState)) {
                    acc.BillingState = 'WI';    
                }
                if (String.isBlank(acc.BillingCountry)) {
                    acc.BillingCountry = 'US';    
                }
                if (String.isBlank(acc.AccountNumber)) {
                    acc.AccountNumber = 'YYYYYY';    
                }
            }
        }
    }
}