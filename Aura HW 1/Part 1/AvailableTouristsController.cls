public class AvailableTouristsController {
	
    @AuraEnabled
    public static List<Tourist__c> getTourists(Integer limits ,Integer offset, Decimal minAge, String tripId) {
        if (limits == null || offset == null || minAge == null || String.isBlank(tripId)) return new List<Tourist__c>(); 
        
        return [ 
            SELECT Id, Name, LastName__c, Email__c, Gender__c
            FROM Tourist__c
            WHERE Active__c = true AND Age__c >= :minAge AND Id NOT IN (SELECT Tourist__c FROM Flight__c WHERE Trip__r.Start_Date__c = :Date.today() OR Trip__c = :tripId)
            ORDER BY Name
            LIMIT :limits
            OFFSET :offset
        ];
    }
    
    @AuraEnabled
    public static Trip__c getTrip(String tripId) {
		if (String.isBlank(tripId)) return new Trip__c();
        
        return [
            SELECT Id, 
            	   Name, 
                   Minimal_Age__c, 
                   Seats__c, 
                   Start_Date__c
            FROM Trip__c
            WHERE Id = :tripId
        ]; 
    }
    
    @AuraEnabled
    public static Integer getCountSeats(String tripId) {
		if (String.isBlank(tripId)) return 0;
        
        Trip__c trip = getTrip(tripId);
        
        List<Flight__c> flights = [
            SELECT Id
            FROM Flight__c
            WHERE Trip__c = :tripId
        ];
        
        return Integer.valueOf(trip.Seats__c) - flights.size();
    }
    
    @AuraEnabled
    public static Boolean createFlgihts(List<Tourist__c> tourists, Trip__c trip) {
		if (tourists.isEmpty() ||  tourists == null) return true;
        
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