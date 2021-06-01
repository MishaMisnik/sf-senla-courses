public class FlightTriggerHandler {
    public static Boolean onBeforeInsertIsFirstTime = true;
    public static final String ERROR_INSUFFICIENT_MINIMAL_AGE = 'Age too young for this flight';
    public static final String ERROR_DEPARTURE_FLIGHT = 'This flight has already departed';
    
    public static void onBeforeInsert (List<Flight__c> newFlights) {
        if (newFlights.isEmpty() || newFlights == null) return;
        
        Set<Id> touristIds = new Set<Id>();
        Set<Id> tripIds = new Set<Id>();
        
        for (Flight__c flight : newFlights) {
            touristIds.add(flight.Tourist__c);
            tripIds.add(flight.Trip__c); 
        }
        
        Map<Id, Tourist__c> touristMap = TouristManager.getById(touristIds);
        Map<Id, Trip__c> tripMap = TripManager.getByIds(tripIds);
        
        for (Flight__c flight : newFlights ) {
            Tourist__c tourist = touristMap.get(flight.Tourist__c);
            Trip__c trip = tripMap.get(flight.Trip__c);
            
            if (trip.Start_Date__c < Date.today()) {
                flight.Trip__c.addError(ERROR_DEPARTURE_FLIGHT);
            }
            
            if (tourist.Age__c < trip.Minimal_Age__c) {
                flight.Trip__c.addError(ERROR_INSUFFICIENT_MINIMAL_AGE);
            }
        }
    }
}