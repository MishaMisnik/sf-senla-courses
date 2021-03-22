public class TouristManager {

    public static List<Tourist__c> getByName(String name) {
        if (String.isBlank(name)) {
            return new List<Tourist__c>();
        }
        
        return [
            SELECT Name, 
                   Age__c
            FROM Tourist__c
            WHERE name LIKE :('%' + name + '%')
        ];
    }
    
    public static List<Tourist__c> getByNameAndEmailWithoutDuplicates(String name, String Email) {
        if (String.isBlank(name) || String.isBlank(Email)) {
            return new List<Tourist__c>();
        }
        
        return [
            SELECT LastName__c,
            	   Email__c,
            	   IsDuplicate__c
            FROM Tourist__c
            WHERE LastName__c = :name AND Email__c = :Email AND IsDuplicate__c = false
        ];
    }
    
    public static List<Tourist__c> getByAge(Set<Integer> ages) {
        if (Ages.contains(null)) {
			return new List<Tourist__c>();
        }
        
        return [
            SELECT Name, 
                   Age__c
            FROM Tourist__c
            WHERE Age__c IN :Ages
        ];
    }
    
    public static List<Tourist__c> getByDateStart(Date startDate) {
        if (startDate == null) {
            return new List<Tourist__c>();
        }
        Date firstDate = startDate;
        Date secondDate = startDate.addYears(1);
        
        return [
            SELECT Name, 
            	   Age__c
            FROM Tourist__c
            WHERE id IN (SELECT Tourist__c FROM Flight__c WHERE Trip__r.Start_Date__c >= :firstDate AND Trip__r.Start_Date__c <= :secondDate)
        ];
    }
   
    public static List<Tourist__c> getWithFlights() {

        return [
            SELECT Name, 
            	   age__c, 
            	   (SELECT Trip__r.Start_Date__c, Trip__r.Name FROM Flights__r)
            FROM Tourist__c
        ];
    }
    
    public static List<Tourist__c> getWithoutFlightsAndAppropriateAge(List<Trip__c> Trips) {
        if (Trips.contains(null)) {
            return new List<Tourist__c>();
        }
        List<Tourist__c> Tourists = new List<Tourist__c> ();
        
        for (Trip__c trip : Trips) {
            Tourists.addAll([
                SELECT Upcoming_Flight_Count__c, 
                       Age__c
                FROM Tourist__c
                WHERE (Age__c > :trip.Minimal_Age__c AND Upcoming_Flight_Count__c = 0)
            ]);
        }
        
        return Tourists;
    }
    
    public static List<Tourist__c> getCountFlights() {

        return [
            SELECT Name, 
                   age__c
            FROM Tourist__c
            WHERE Upcoming_Flight_Count__c = 0
        ];
    }
    
    public static List<Tourist__c> getByFlight(list<Flight__c> Flights) {
        if (Flights.contains(null)) {
            return new List<Tourist__c>();
        }
		List<Tourist__c> Tourists = new List<Tourist__c> ();
        
        for (Flight__c Flight : Flights) {
             Tourists.add([
            	SELECT id, 
                       Age__c
                FROM Tourist__c
                WHERE id = :flight.Tourist__c
        	]);
        }
        
        return Tourists;
    }
}