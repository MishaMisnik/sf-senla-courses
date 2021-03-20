public class TripManager {
	public static List<Trip__c> getByFlight(list<Flight__c> Flights) {
        if (Flights.contains(null)) {
            return new List<Trip__c>();
        }
		list<Trip__c> Trips = new List<Trip__c> ();
        
        for (Flight__c Flight : Flights) {
             Trips.add([
            	SELECT Id, Minimal_Age__c, Start_Date__c
                FROM Trip__c
                WHERE id = :flight.Trip__c
        	]);
        }
        
        return Trips;
    }
}