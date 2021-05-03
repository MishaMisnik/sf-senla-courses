public class UnitTestFactory {
	
    public static void addOneTourist(){
        List<Tourist__c> touristsToInsert = new List<Tourist__c>{
            new Tourist__c(Name = 'Misha', LastName__c = 'Misnik', Email__c = 'misnik@salesforce.com', Birthdate__c = Date.newInstance(1997, 05, 05))
        };
            
        insert touristsToInsert;
    }
    
    public static void addThreeTourists(){
        List<Tourist__c> touristsToInsert = new List<Tourist__c>{
            new Tourist__c(Name = 'John', LastName__c = 'Watson', Email__c = 'watson@salesforce.com', Birthdate__c = Date.newInstance(1997, 05, 05)),
            new Tourist__c(Name = 'Misha', LastName__c = 'Misnik', Email__c = 'misnik@salesforce.com', Birthdate__c = Date.newInstance(1997, 05, 05)),  
            new Tourist__c(Name = 'Alisa', LastName__c = 'Danilchik', Email__c = 'alisa@salesforce.com', Birthdate__c = Date.newInstance(2003, 11, 09))   
        };
            
        insert touristsToInsert;
    }
    
    public static void addThreeTouristsWithDuplicate(){
        List<Tourist__c> touristsToInsert = new List<Tourist__c>{
            new Tourist__c(Name = 'John', LastName__c = 'Watson', Email__c = 'watson@salesforce.com', Birthdate__c = Date.newInstance(1997, 02, 04)),  
            new Tourist__c(Name = 'Misha', LastName__c = 'Misnik', Email__c = 'misnik@salesforce.com', Birthdate__c = Date.newInstance(1997, 05, 05)),
            new Tourist__c(Name = 'Dima', LastName__c = 'Misnik', Email__c = 'misnik@salesforce.com', Birthdate__c = Date.newInstance(1997, 08, 01)),    
            new Tourist__c(Name = 'Alisa', LastName__c = 'Danilchik', Email__c = 'alisa@salesforce.com', Birthdate__c = Date.newInstance(2003, 11, 09))  
        };
            
        insert touristsToInsert;
    }
    
    public static void addOneFlight(){
        addOneTourist();
        addOneTrip();
        List<Tourist__c> tourist = getTourists();
        List<Trip__c> trip = getTrips();
        List<Flight__c> flights = new List<Flight__c> ();
        
        for (Integer i = 0; i < tourist.size(); i++){
            Flight__c flight = new Flight__c(
                Tourist__c = tourist[i].Id,
                Trip__c = trip[i].Id
            );
            
            flights.add(flight);
        }
        
        insert flights;
    }
    
    public static void addOneTrip(){
        List<Trip__c> tripsToInsert = new List<Trip__c> {
            new Trip__c(Name = 'To Mars', Minimal_Age__c = 7, Start_Date__c = Date.newInstance(2021, 06, 06))
        };
            
        insert tripsToInsert;
    }
    
    public static Set<Id> getId (List<SObject> obj){
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
                   Duplicate_Check__c
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
                   Trip__c
            FROM Flight__c
        ];
        
        return flights;
    }

    public static Tourist__c createTourist(String name, String lastName, String email, Date birthdate){
        if (name == null || lastName == null || email == null || birthdate == null) return new Tourist__c();

        Tourist__c tourist = new Tourist__c(
                Name = name,
                LastName__c = lastName,
                Email__c = email,
                Birthdate__c = birthdate
        );

        return tourist;
    }

    public static Trip__c createTrip(String name, Integer minAge, Date startDate){
        if (name == null || minAge == null || startDate == null) return new Trip__c();

        Trip__c trip = new Trip__c(
                Name = name,
                Minimal_Age__c = minAge,
                Start_Date__c = startDate
        );

        return trip;
    }

    public static Flight__c createFlight(Tourist__c tourist, Trip__c trip){
        if (tourist == null || trip == null) return new Flight__c();

        Flight__c flight = new Flight__c(
                Tourist__c = tourist.Id,
                Trip__c = trip.Id
        );

        return flight;
    }
}