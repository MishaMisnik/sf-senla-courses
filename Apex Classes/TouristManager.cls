public class TouristManager {

    public static List<Tourist__c> getByName(String name) {
        if (String.isBlank(name)) return new List<Tourist__c>();
        
        return [
            SELECT Name,
                   Age__c
            FROM Tourist__c
            WHERE Name LIKE :('%' + name + '%')
        ];
    }
    
    public static Map<Id, Tourist__c> getById(Set<Id> touristIds) {
        if (touristIds.isEmpty() || touristIds == null) return new Map<Id, Tourist__c>();
        
        return new Map<Id, Tourist__c>([
            SELECT Id, 
            	   Age__c,
                   Duplicate_Check__c
            FROM Tourist__c
            WHERE Id IN :touristIds
        ]);
    }
    
    public static List<Tourist__c> getListById(Set<Id> touristIds) {
        if (touristIds.isEmpty() ||  touristIds == null) return new List<Tourist__c>();
        
        return [
            SELECT Id,
              	   Age__c,
                   Duplicate_Check__c,
                   IsDuplicate__c,
                   Active__c
            FROM Tourist__c
            WHERE Id IN :touristIds
        ];
    }
    
    public static List<Tourist__c> getByLastNameAndEmail(List<Tourist__c> tourists) {
        if (tourists.isEmpty() || tourists == null) return new List<Tourist__c>();
        
        Set<Id> touristIds = new Set<Id>();
        Set<String> touristsCheckDuplicate = new Set<String>();
        
        for (Tourist__c tourist : tourists) {
            touristIds.add(tourist.Id);
            touristsCheckDuplicate.add(tourist.Duplicate_Check__c);
        }

        return [
            SELECT Id,
                   Duplicate_Check__c,
                   IsDuplicate__c
            FROM Tourist__c
            WHERE Duplicate_Check__c IN :touristsCheckDuplicate AND Id NOT IN :touristIds
        ];
    }
    
    public static List<Tourist__c> getByAge(Set<Integer> ages) {
        if (ages.isEmpty() || ages == null) return new List<Tourist__c>();
        
        return [
            SELECT Name, 
                   Age__c
            FROM Tourist__c
            WHERE Age__c IN :ages
        ];
    }
    
    public static List<Tourist__c> getByDateStart(Date startDate) {
        if (startDate == null) return new List<Tourist__c>();
        
        Date firstDate = startDate;
        Date secondDate = startDate.addYears(1);
        
        return [
            SELECT Name, 
            	   Age__c
            FROM Tourist__c
            WHERE Id IN (SELECT Tourist__c FROM Flight__c WHERE Trip__r.Start_Date__c >= :firstDate AND Trip__r.Start_Date__c <= :secondDate)
        ];
    }
   
    public static List<Tourist__c> getWithFlights() {

        return [
            SELECT Name, 
            	   Age__c,
            	   (SELECT Trip__r.Start_Date__c, Trip__r.Name FROM Flights__r)
            FROM Tourist__c
            WHERE Upcoming_Flight_Count__c != 0
        ];
    }
    
    public static List<Tourist__c> getWithoutFlightsAndAppropriateAge(List<Trip__c> trips) {
        if (trips.isEmpty() || trips == null) return new List<Tourist__c>();
        
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
    
    public static List<Tourist__c> getWithoutFlights() {
    
        return [
            SELECT Name, 
                   Age__c,
                   Upcoming_Flight_Count__c
            FROM Tourist__c
            WHERE Upcoming_Flight_Count__c = 0
        ];
    }
    
    public static List<Tourist__c> getTouristByFlight(List<Flight__c> flights) {
        if (flights.isEmpty() || flights == null) return new List<Tourist__c>();
        
        Set<Id> touristsId = new Set<Id>();
        
        for (Flight__c flight : flights) {
            touristsId.add(flight.Tourist__c);
        }
        
        return [
            SELECT Age__c
            FROM Tourist__c
            WHERE Id IN :touristsId
        ];
    }
    
    public static List<Tourist__c> getByRelationshipWithFlight(Set<Id> touristsIds) {
        if (touristsIds.isEmpty() || touristsIds == null) return new List<Tourist__c>();
        
        return [
            SELECT Id,
                   Name
            FROM Tourist__c
            WHERE Id IN :touristsIds AND Upcoming_Flight_Count__c != 0
        ];
    }
    
    public static List<Tourist__c> getByDuplicateCheck(String duplicateCheck) {
        if (String.isBlank(duplicateCheck)) return new List<Tourist__c>();
        
        return [
            SELECT Id,
                   Duplicate_Check__c
            FROM Tourist__c
            WHERE Duplicate_Check__c = :duplicateCheck
            LIMIT 1
        ];
    }
    
    public static List<Tourist__c> getByNameAndAge(String name, Decimal age) {
        if (String.isBlank(name)) return new List<Tourist__c> ();
        
        List<List<Tourist__c>> tourists = new List<List<Tourist__c>>();
        
        if (age == null) {
            tourists = [
                FIND :name
                IN NAME FIELDS
                RETURNING Tourist__c(Name, Age__c)
            ];
        } else {
            tourists = [
                FIND :name 
                IN NAME FIELDS
                RETURNING Tourist__c(Name, Age__c WHERE Age__c = :age)
            ];
        }
        
        return tourists[0];
    }
    
    public static Set<Id> getIds (List<SObject> obj) {
        if (obj.isEmpty() || obj == null) return new Set<Id>();
        
        Set<Id> ids = new Set<Id>();
        
        for (SObject ob : obj) {
            ids.add(ob.Id);
        }
        
        return ids;
    }
    
    public static List<Tourist__c> getWithMinimalFlightsCount(String tripId) {
        if (String.isBlank(tripId)) return new List<Tourist__c>();
        
        return [
            SELECT Name, 
                   LastName__c, 
                   Upcoming_Flight_Count__c, 
                   Age__c
            FROM Tourist__c
            WHERE Id IN (SELECT Tourist__c FROM Flight__c WHERE Trip__c != :tripId)
            ORDER BY Upcoming_Flight_Count__c ASC 
            LIMIT 10
        ];
    }
}