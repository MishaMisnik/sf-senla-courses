public class UnitTestFactory {
    
    public static Set<Id> getId (List<SObject> obj) {
        if (obj.isEmpty()) return new Set<Id>();

        Set<Id> ids = new Set<Id>();
        
        for (SObject ob : obj) {
            ids.add(ob.Id);
        }
        
        return ids;
    }
    
    public static List<Tourist__c> getTourists() {
        List<Tourist__c> tourists = [
            SELECT Id,
                   Name,
                   LastName__c,
                   Age__c,
                   Email__c,
                   Duplicate_Check__c,
                   IsDuplicate__c
            FROM Tourist__c
        ];
        
        return tourists;
    }
    
    public static List<Trip__c> getTrips() {
        List<Trip__c> trips = [
            SELECT Id,
                   Name,
                   Minimal_Age__c,
                   Start_Date__c
            FROM Trip__c
        ];
        
        return trips;
    }
    
    public static List<Flight__c> getFlights() {
        List<Flight__c> flights = [
            SELECT Id,
                   Tourist__c,
                   Trip__c,
                   Status__c
            FROM Flight__c
        ];
        
        return flights;
    }
    
    public static List<Space_Point__c> getSpacePoints() {
        List<Space_Point__c> spacePoints = [
            SELECT Id,
                   Name,
                   City__c,
                   Latitude__c,
                   Longitude__c
            FROM Space_Point__c
        ];
        
        return spacePoints;
    }
    
    public static List<Weather_Daily_Forecast__c> getWeather() {
        List<Weather_Daily_Forecast__c> weather = [
            SELECT Id,
                   Space_Point__c,
                   Date__c
            FROM Weather_Daily_Forecast__c
        ];
        
        return weather;
    }
    
    public static Tourist__c createTourist(String name, String lastName, String email, Date birthdate) {
        if (name == null || lastName == null || email == null || birthdate == null) return new Tourist__c();
        
        Tourist__c tourist = new Tourist__c(
                Name = name,
                LastName__c = lastName,
                Email__c = email,
                Birthdate__c = birthdate
        );
        
        return tourist;
    }
    
    public static Trip__c createTrip(String name, Integer minAge, Date startDate) {
        if (name == null || minAge == null || startDate == null) return new Trip__c();
        
        Trip__c trip = new Trip__c(
                Name = name,
                Minimal_Age__c = minAge,
                Start_Date__c = startDate
        );
        
        return trip;
    }
    
    public static Flight__c createFlight(Tourist__c tourist, Trip__c trip) {
        if (tourist == null || trip == null) return new Flight__c();
        
        Flight__c flight = new Flight__c(
                Tourist__c = tourist.Id,
                Trip__c = trip.Id
        );
        
        return flight;
    }
}