public class TouritstAssignmentController {
    @AuraEnabled(cacheable = true)
    public static List<Trip__c> getTrips(Tourist__c tourist){
        if (tourist == null) return new List<Trip__c>();
        
        return [
            SELECT Id,
            Name,
            Start_Date__c,
            Minimal_Age__c,
            Departure_Space_Point__c,
            Departure_Space_Point__r.Id,
            Departure_Space_Point__r.Latitude__c,
            Departure_Space_Point__r.Longitude__c
            FROM Trip__c
            WHERE Start_Date__c >= :Date.today() AND Remaining_Seats__c > 0 AND Minimal_Age__c <= :tourist.Age__c
        ];
    }
    
    @AuraEnabled(cacheable = true)
    public static Tourist__c getTourist(String touristId){
        if (String.isBlank(touristId)) return new Tourist__c(); 
        
        return [
            SELECT Id, Name, Age__c
            FROM Tourist__c
            WHERE Id = :touristId
        ];
    }
    
    @AuraEnabled
    public static Boolean createFlgiht(String touristId, String tripId) {
        if (String.isBlank(touristId)  ||  String.isBlank(tripId)) return false;
        
        Boolean isComplete = true;        
        Flight__c flight = new Flight__c(
            Status__c = 'Requested',
            Tourist__c = touristId,
            Trip__c = tripId
        );
        
        try {
            insert flight;
        } catch(DmlException e) {
            isComplete = false;
            System.debug('Error : ' + e.getMessage());
        }
        
        return isComplete;
    }
}