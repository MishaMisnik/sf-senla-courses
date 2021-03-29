public class TripManager {
    
    public static Map<Id, Trip__c> getById(Set<Id> tripIds) {
        if (tripIds.contains(null)) {
            return new Map<Id, Trip__c>();
        }
        
        List<Trip__c> trips = [
            SELECT Id, 
                   Minimal_Age__c, 
                   Start_Date__c
            FROM Trip__c
            WHERE Id In :tripIds
        ];
        Map<Id, Trip__c> tripMap = new Map<Id, Trip__c>(trips);
        
        return tripMap;
    }
}