/**
 * Created by ashbas on 3/11/25.
 */

public with sharing class PartitionCacheExample {

    @AuraEnabled
    public static void storeDataController(String recordId) {
        Contact cont = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE Id=:recordId LIMIT 1];

        // If using default partition, basically creating a map. ContactFound key can be named anything
//        Cache.Session.put('ContactFound', cont);

        // If not using the default partition,
        Cache.Session.put('local.TacoCat.ContactFound', cont );

        // Another way - This is used to put different things -
//        Cache.SessionPartition sessionPartition = Cache.Session.getPartition('local.TacoCat');
//        sessionPartition.put('ContactFound', cont);


    }

    @AuraEnabled
    public static Contact retrieveDataCachedController() {
//        if (Cache.Session.contains('ContactFound')) {
//            return (Contact) Cache.Session.get('ContactFound');
            return (Contact) Cache.Session.get('local.TacoCat.ContactFound');
            // Using contactPlatformCacheData Class
//            return (Contact) Cache.Session.get(ContactPlatformCacheData.class, '0034x00001ziKpmAAE');
//        }
//        return null;
    }

    @AuraEnabled
    public static Contact retrieveDataSOQLController(String recordId) {
       return [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE Id=:recordId LIMIT 1];


    }
}