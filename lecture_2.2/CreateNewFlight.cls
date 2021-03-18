public class CreateNewFlight {
    @InvocableMethod
    public static void createNewFlight(List<Trip__c> trip) {
        if (trip!=null && !trip.isEmpty()) {
            List<Tourist__c> selectedTourists = [
            	SELECT id, Age__c
            	FROM Tourist__c
            	WHERE Age__c > :trip[0].minimal_age__c AND Upcoming_Flight_Count__c = 0
        	];
        	list<Flight__c> flights = new list<Flight__c> {}; 

			for (Tourist__c tourist : selectedTourists) {
	        	Flight__c flight =  new Flight__c(
					Tourist__c = tourist.Id,
		        	Trip__c = trip[0].Id,
					Status__c = 'Loading'
				);
            	flights.add(flight);    
        	}

        	insert flights;
        }
    }
}