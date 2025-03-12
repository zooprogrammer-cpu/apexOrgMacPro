/**
 * Created by ashbas on 3/11/25.
 */

public with sharing class ContactPlatformCacheData implements Cache.CacheBuilder{
    public Object doLoad(String contactId) {
        Contact cont = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE Id=:contactId LIMIT 1];
        return cont;
    }

}