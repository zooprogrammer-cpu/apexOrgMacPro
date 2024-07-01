/**
 * 
 */

public with sharing class ThinkingInApex {
    private static Boolean isUserSpecialChecked = false;
    private static Boolean userIsSpecial = false;

    private static Boolean userCacheLoaded = false;
    private static String userTimeZone = null;

    public static Boolean isUserSpecial() {
        if (isUserSpecialChecked) return userIsSpecial;

        User u = [SELECT Id, UserIsSpecial__c FROM User WHERE Id =:UserInfo.getUserId()];
        userIsSpecial = u.UserIsSpecial__c;
        isUserSpecialChecked = true;
        return userIsSpecial;
    }

    public static String userTimeZone() {
        if (userCacheLoaded) return userTimeZone;
        cacheUserInfo();
        return userTimeZone;
    }

    private static void cacheUserInfo() {
        if (userCacheLoaded) return;
        User u = [SELECT UserIsSpecial__c, TimeZoneSidKey FROM User WHERE Id =:UserInfo.getUserId()];
        userIsSpecial = u.UserIsSpecial__c;
        userTimeZone = u.TimeZoneSidKey;
        userCacheLoaded = true;
    }

}