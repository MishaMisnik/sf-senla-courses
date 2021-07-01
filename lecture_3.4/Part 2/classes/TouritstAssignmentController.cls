public class TouritstAssignmentController {
    
    @AuraEnabled(cacheable = true)
    public static List<Trip__c> getTrips(Tourist__c tourist){
        if (tourist == null) return new List<Trip__c>();
        
        return TripManager.getByTouristParams(tourist);
    }
    
    @AuraEnabled
    public static Boolean createFlgiht(String touristId, String tripId) {
        if (String.isBlank(touristId)  ||  String.isBlank(tripId)) return false;
        
        return TripServise.createFlightRequested(touristId, tripId);
    }
}