public with sharing class CTLocationController {
  // Get 100 locations with recent status changes
  public static List<Location__c> getRecentStatusChanges() {
    return [
      SELECT Id, PinCode__c, Address__c, Name
      FROM Location__c
      ORDER BY Status_Update_Date__c DESC NULLS LAST
      LIMIT 100
    ];
  }
  // search location by search term
  public static List<Location__c> searchLocations(String searchTerm) {
    searchTerm = searchTerm + '%';
    return [
      SELECT Id, PinCode__c, Address__c, Name
      FROM Location__c
      WHERE
        Name LIKE :searchTerm
        OR PinCode__c LIKE :searchTerm
        OR Address__c LIKE :searchTerm
      ORDER BY Status_Update_Date__c DESC NULLS LAST
    ];
  }
  // Search location by Id
  public static Location__c getLocationById(String locationId) {
    List<Location__c> location = [
      SELECT Id, PinCode__c, Address__c, Name
      FROM Location__c
      WHERE Id = :locationId
    ];

    if (location != null && location.size() > 0) {
      return location[0];
    }
    return null;
  }

  // update the Red Score in the Location Records
  //Grouping Location_Tracing__c record by Location and we are getting only those
  // records where person health status is Red and visti date is in last 10 days
  public static void updateRedScore(Set<Id> locationIds) {
    List<Location__c> locationToUpdate = new List<Location__c>();
    AggregateResult[] redPeoplePerLocation = [SELECT Location__c, COUNT(Id) total FROM Location_Tracing__c 
                      WHERE Person__r.Health_Status__c = 'Red'
                      AND Visit_Date__c = LAST_N_DAYS: 10
                      AND Location__c IN: locationIds GROUP BY Location__c];

      for (AggregateResult ar : redPeoplePerLocation) {
        String locationId = String.valueOf(ar.get('Location__c'));
        Integer redScore = Integer.valueOf(ar.get('total'));
        String status = getStatus(redScore);
        locationToUpdate.add(new Location__c(Id = locationId, Red_Score__c = redScore, Status__c = status));
      }
      if (locationToUpdate != null && locationToUpdate.size() > 0){
        update locationToUpdate;  
      }                          
  }
  // Based on the redScore, update the Location's Red Score
  private static String getStatus(Integer redScore) {
    if (redScore == 0){
      return 'Green'; 
    } else if (redScore <= 5){
      return 'Yellow';
    } else if (redSCore <=10){
      return 'Orange';
    } else {
      return 'Red';
    }
    
  }

  public static Map<String, Integer> getStatusCount() {
    Map<String, Integer> healthCountMap = new Map<String, Integer>();

    for (AggregateResult ar : [
      SELECT Status__c, COUNT(Id) total
      FROM Location__c
      GROUP BY Status__c
    ]) {
      String status = String.valueOf(ar.get('Status__c'));
      Integer count = Integer.valueOf(ar.get('total'));
      healthCountMap.put(status, count);
    }
    return healthCountMap;
  }
}