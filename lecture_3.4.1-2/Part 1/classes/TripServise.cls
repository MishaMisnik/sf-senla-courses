public class TripServise {
    
    public static Boolean createFlightsOfferPending(List<Tourist__c> tourists, Trip__c trip) {
        if (tourists.isEmpty() ||  tourists == null) return false;
        
        Boolean isComplete = true;
        List<Flight__c> flights = new List<Flight__c>();
        
        for (Tourist__c tourist : tourists) {
            Flight__c newFlight = new Flight__c(
                Status__c = 'Offer Pending',
                Tourist__c = tourist.Id,
                Trip__c = trip.Id
            );
            flights.add(newFlight);
        }
        
        try{
            insert flights;
        } catch(DmlException e) {
            isComplete = false;
            System.debug('Error : ' + e.getMessage());
        }
        
        return isComplete;
    }  
    
    public static Boolean createFlightRequested(String touristId, String tripId) {
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