public class TouristManager {

    public static List<Tourist__c> getByName(String name) {
        if (String.isBlank(name)) {
            return new List<Tourist__c>();
        }
        
        return [
            SELECT Name,
                   Age__c
            FROM Tourist__c
            WHERE Name LIKE :('%' + name + '%')
        ];
    }
    
    public static Map<Id, Tourist__c> getById(Set<Id> touristIds) {
        if (touristIds.contains(null)) {
            return new Map<Id, Tourist__c>();
        }
        
        List<Tourist__c> tourists = [
            SELECT Id, 
            	   Age__c,
                   Duplicate_Check__c
            FROM Tourist__c
            WHERE Id In :touristIds
        ];
        Map<Id, Tourist__c> touristMap = new Map<Id, Tourist__c>(tourists);
        
        return touristMap;
    }
    
    public static List<Tourist__c> getByLastNameAndEmail(List<Tourist__c> tourists) {
        if (tourists.contains(null)) {
			return new List<Tourist__c>();
        }
        
        Set<Id> touristIds = new Set<Id>();
        Set<String> touristsChekcDuplicate = new Set<String>();
        
        
        for (Tourist__c tourist : tourists) {
            touristIds.add(tourist.Id);
        }
        
        for (Tourist__c tourist : tourists) {
            touristsChekcDuplicate.add(tourist.Duplicate_Check__c);
        }

        return [
            SELECT LastName__c,
            	   Email__c,
            	   IsDuplicate__c,
                   Duplicate_Check__c
            FROM Tourist__c
            WHERE Duplicate_Check__c IN :touristsChekcDuplicate AND Id NOT IN :touristIds
        ];
    }
    
    public static List<Tourist__c> getByAge(Set<Integer> ages) {
        if (ages.contains(null)) {
			return new List<Tourist__c>();
        }
        
        return [
            SELECT Name, 
                   Age__c
            FROM Tourist__c
            WHERE Age__c IN :ages
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
    
    public static List<Tourist__c> getWithoutFlightsAndAppropriateAge(List<Trip__c> trips) {
        if (trips.contains(null)) {
            return new List<Tourist__c>();
        }
        Integer tripMinimalAge = trips[0].Minimal_Age__c.intValue();
        
        for (Trip__c trip : trips) {
            if (tripMinimalAge < trip.Minimal_Age__c) {
                tripMinimalAge = trip.Minimal_Age__c.intValue();
            }
        }

        return [
                SELECT Upcoming_Flight_Count__c, 
                       Age__c
			    FROM Tourist__c
			    WHERE (Age__c > :tripMinimalAge AND Upcoming_Flight_Count__c = 0)
            ];
    }
    
    public static List<Tourist__c> getCountFlights() {

        return [
            SELECT Name, 
            	   age__c
            FROM Tourist__c
            WHERE Upcoming_Flight_Count__c = 0
        ];
    }
    
    public static List<Tourist__c> getTouristByFlight(List<Flight__c> flights) {
        if (flights.contains(null)) {
            return new List<Tourist__c>();
        }
		Set<Id> touristsId = new Set<Id> ();
        
        for (Flight__c flight : flights) {
            touristsId.add(flight.Tourist__c);
        }
        
        return [
            	SELECT Age__c
                FROM Tourist__c
                WHERE id IN :touristsId
        	];
    }
}