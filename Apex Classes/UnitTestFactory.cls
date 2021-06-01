@IsTest
public class UnitTestFactory {
    
    public static Set<Id> getIds (List<SObject> obj) {
        if (obj.isEmpty() || obj == null) return new Set<Id>();
        
        Set<Id> ids = new Set<Id>();
        
        for (SObject ob : obj) {
            ids.add(ob.Id);
        }
        
        return ids;
    }
    
    public static List<Tourist__c> getTourists() {
        
        return [
            SELECT Id,
                   Name,
                   LastName__c,
                   Age__c,
                   Email__c,
                   Duplicate_Check__c,
                   IsDuplicate__c
            FROM Tourist__c
        ];
    }
    
    public static List<Trip__c> getTrips() {
        
        return [
            SELECT Id,
                   Name,
                   Minimal_Age__c,
                   Start_Date__c
            FROM Trip__c
        ];
    }
    
    public static List<Flight__c> getFlights() {
        
        return [
            SELECT Id,
                   Tourist__c,
                   Trip__c,
                   Status__c
            FROM Flight__c
        ];
    }
    
    public static List<Space_Point__c> getSpacePoints() {

        return [
            SELECT Id,
                   Name,
                   City__c,
                   Latitude__c,
                   Longitude__c
            FROM Space_Point__c
        ];
    }
    
    public static List<Weather_Daily_Forecast__c> getWeather() {

        return [
            SELECT Id,
                   Space_Point__c,
                   Date__c
            FROM Weather_Daily_Forecast__c
        ];
    }

    public static Tourist__c createTourist(String name, String lastName, String email, Date birthdate) {
        if (String.isBlank(name) || String.isBlank(lastName) || String.isBlank(email) || birthdate == null) return new Tourist__c();

        return new Tourist__c(
                Name = name,
                LastName__c = lastName,
                Email__c = email,
                Birthdate__c = birthdate
        );
    }
    
    public static Trip__c createTrip(String name, Integer minAge, Date startDate) {
        if (String.isBlank(name) || minAge == null || startDate == null) return new Trip__c();
        
        return new Trip__c(
                Name = name,
                Minimal_Age__c = minAge,
                Start_Date__c = startDate
        );
    }
    
    public static Flight__c createFlight(Tourist__c tourist, Trip__c trip) {
        if (tourist == null || trip == null) return new Flight__c();
        
        return new Flight__c(
                Tourist__c = tourist.Id,
                Trip__c = trip.Id
        );
    }
}