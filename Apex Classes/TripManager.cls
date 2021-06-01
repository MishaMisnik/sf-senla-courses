public class TripManager {
    
    public static Map<Id, Trip__c> getByIds(Set<Id> tripIds) {
        if (tripIds.isEmpty() || tripIds == null) return new Map<Id, Trip__c>();
        
        return new Map<Id, Trip__c>([
            SELECT Id,
                   Minimal_Age__c,
                   Start_Date__c
            FROM Trip__c
            WHERE Id IN :tripIds
        ]);
    }
    
    public static Trip__c getById(String tripId) {
        if (String.isBlank(tripId)) return new Trip__c();
        
        return [
            SELECT Id,
                   Minimal_Age__c,
                   Start_Date__c,
                   (SELECT Status__c, 
                           Tourist__c, 
                           Tourist__r.Upcoming_Flight_Count__c, 
                           Tourist__r.Name, 
                           Tourist__r.LastName__c, 
                           Tourist__r.Age__c 
                    FROM Flights__r)
            FROM Trip__c
            WHERE Id = :tripId
        ];
    }
}