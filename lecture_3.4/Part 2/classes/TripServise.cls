public class TripServise {
    
    public static Boolean createFlights(List<Tourist__c> tourists, Trip__c trip) {
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
}