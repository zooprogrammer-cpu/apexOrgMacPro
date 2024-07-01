public with sharing class OpenClosed_BadExample {
    @AuraEnabled
    public static List<MapMarker> getLeadsForMap() {
        List<Lead> leadsInSystem = [SELECT Id, FirstName, LastName, Country, City, PostalCode, Street FROM Lead
                                    WHERE Street!= NULL AND PostalCode !=NULL AND City!= NULL AND Country !=NULL LIMIT 2

        ];

        List<MapMarker> mapMarkers = new List<MapMarker>();

        for (Lead lead : leadsInSystem) {
            MapMarker marker = new MapMarker();
            MapLocation location = new MapLocation();
            location.Country = lead.Country;
            location.City = lead.City;
            location.PostalCode = lead.PostalCode;
            location.Street = lead.Street;
            marker.location = location;
            marker.description = 'Hi';
            marker.title = 'Hola';
            mapMarkers.add(marker);


        }
        System.debug(mapMarkers);
        return mapMarkers;

    }

//     innerclass
    public class MapMarker {
        @AuraEnabled
        public MapLocation location;
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String description;
    }

    //     innerclass
    public class MapLocation {
        @AuraEnabled
        public MapLocation location;
        @AuraEnabled
        public String Country;
        @AuraEnabled
        public String City;
        @AuraEnabled
        public String PostalCode;
        @AuraEnabled
        public String Street;
    }



}