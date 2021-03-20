public class FlightManager {
    public static List<Flight__c> getByStartDateAndTouristId(list<Tourist__c> Tourists) {
        if (Tourists.contains(null)) {
            return new List<Flight__c>();
        }
		list<Flight__c> Flights = new List<Flight__c> ();
        
        for (Tourist__c tourist : tourists) {
             Flights.add([
            	SELECT id
				FROM Flight__c
				WHERE Trip__r.Start_Date__c > :date.today() AND Tourist__c = :tourist.Id
        	]);
        }
        
        return Flights;
    }
}