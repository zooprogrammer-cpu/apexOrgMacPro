public with sharing class LightningSampleController {
   @AuraEnabled
   public static void createError(){
    try {
        //force an error
        Integer notHappening = 1/0;     
    } catch (Exception e) {
        AuraHandledException ahe = new AuraHandledException(e.getMessage()); 
        ahe.setMessage(e.getMessage());
        throw ahe;
    }
   }
}