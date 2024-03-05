
public with sharing class LWCMapController {
    // This will never change. Pass the object API Name.
    @AuraEnabled
    public static List<Object> getDataForUI(String objectApiName, String uiType) {
        System.debug('objectApiName' + objectApiName);
        System.debug('uiType' + uiType);
        List<SObject> objList = UIWrapperService.getRecords(objectApiName,uiType);
        return UIWrapperService.wrapperRecordsForUI(objList, 'MapMarker');
    }
}