public class CreateNewFlight {
	@InvocableMethod
	public static void createNewFlight(List<Trip__c> trips) {
		if (trips!=null && !trips.isEmpty()) {
			List<Flight__c> flights = new List<Flight__c> ();
            
			for (Trip__c trip : trips) {
                List<Tourist__c> selectedTourists = TouristManager.getWithoutFlightsAndAppropriateAge(trip.Minimal_Age__c.intValue());
                
                for (Tourist__c tourist : selectedTourists) {
					Flight__c flight =  new Flight__c(
						Tourist__c = tourist.Id,
						Trip__c = trip.Id,
						Status__c = 'Offer Pending'
					);
					flights.add(flight);    
				}
			}

			insert flights;
		}    
	}
}