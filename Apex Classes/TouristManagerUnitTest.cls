@IsTest
private class TouristManagerUnitTest {  
    @TestSetup
    static void setup() {
        List<Tourist__c> tourists = new List<Tourist__c> {
            new Tourist__c(Name = 'John', LastName__c = 'Watson', Email__c = 'watson@salesforce.com', Birthdate__c = Date.newInstance(1997, 02, 04)),  
            new Tourist__c(Name = 'Misha', LastName__c = 'Misnik', Email__c = 'misnik@salesforce.com', Birthdate__c = Date.newInstance(1997, 05, 05)),
            new Tourist__c(Name = 'Dima', LastName__c = 'Misnik', Email__c = 'misnik@salesforce.com', Birthdate__c = Date.newInstance(1997, 08, 01)),    
            new Tourist__c(Name = 'Alisa', LastName__c = 'Danilchik', Email__c = 'alisa@salesforce.com', Birthdate__c = Date.newInstance(2003, 11, 09))   
        };
        insert tourists;
        
        List<Trip__c> trips = new List<Trip__c> {
            new Trip__c(Name = 'To Mars', Minimal_Age__c = 7, Start_Date__c = Date.newInstance(2021, 06, 06))
        };
        insert trips;
        
        List<Flight__c> flights = new List<Flight__c> {
            new Flight__c(Tourist__c = tourists[1].Id, Trip__c = trips[0].Id)
        };
        insert flights;
    } 
    
    @IsTest
    static void testGetByName() {
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        List<Tourist__c> touristsByName = TouristManager.getByName(tourists[1].Name);
        
        System.assertEquals(1, touristsByName.size());
        System.assertEquals(tourists[1].Name, touristsByName[0].Name);
        
        touristsByName = TouristManager.getByName(null);
        
        System.assertEquals(0, touristsByName.size());
    } 
    
    @IsTest
    static void testGetById() {
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        Map<Id, Tourist__c> touristsById = TouristManager.getById(UnitTestFactory.getId(tourists));
        
        System.assertEquals(4, touristsById.size());
        System.assertEquals(tourists[0].Id, touristsById.get(tourists[0].Id).Id);
        
        touristsById = TouristManager.getById(new Set<Id>());
        
        System.assertEquals(0, touristsById.size());
    }
    
    @IsTest
    public static void testGetListById() {
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        List<Tourist__c> touristsListById = TouristManager.getListById(UnitTestFactory.getId(tourists));
        
        System.assertEquals(4, touristsListById.size());
        System.assertEquals(tourists[0].Id, touristsListById[0].Id);     
        
        touristsListById = TouristManager.getListById(new Set<Id>());
        
        System.assertEquals(0, touristsListById.size());
    }
    
    @IsTest
    public static void testGetByLastNameAndEmail() {
        List<Tourist__c> tourists = [
            SELECT Id,
                   Duplicate_Check__c
            FROM Tourist__c
            WHERE Name = 'Misha'
        ];
        List<Tourist__c> touristsByLastNameAndEmail = TouristManager.getByLastNameAndEmail(tourists);
        
        System.assertEquals(1, touristsByLastNameAndEmail.size());
        System.assertEquals(tourists[0].Duplicate_Check__c, touristsByLastNameAndEmail[0].Duplicate_Check__c);
        
        touristsByLastNameAndEmail = TouristManager.getByLastNameAndEmail(new List<Tourist__c>());
        
        System.assertEquals(0, touristsByLastNameAndEmail.size());
    }
    
    @IsTest
    public static void testGetByAge() {
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        Set<Integer> ages = new Set<Integer>();
        
        for (Tourist__c tourist : tourists) {
            ages.add(tourist.Age__c.intValue());
        }
        List<Tourist__c> touristsByAge = TouristManager.getByAge(ages);
            
        System.assertEquals(4, touristsByAge.size());
        System.assertEquals(tourists[0].Id, touristsByAge[0].Id);
        
        touristsByAge = TouristManager.getByAge(new Set<Integer>());
        
        System.assertEquals(0, touristsByAge.size());
    }
    
    @IsTest
    public static void testGetByDateStart() {
        List<Tourist__c> tourist = UnitTestFactory.getTourists();
        Date startDate = Date.today();
        List<Tourist__c> touristsByDateStart = TouristManager.getByDateStart(startDate);
        
        System.assertEquals(1, touristsByDateStart.size());
        System.assertEquals(tourist[1].Id, touristsByDateStart[0].Id);
        
        touristsByDateStart = TouristManager.getByDateStart(null);
        
        System.assertEquals(0, touristsByDateStart.size());
    }
    
    @IsTest
    public static void testGetWithFlights() {
        List<Tourist__c> tourist = UnitTestFactory.getTourists();
        List<Tourist__c> touristsWithFlights = TouristManager.getWithFlights();
        
        System.assertEquals(1, touristsWithFlights.size());
        System.assertEquals(tourist[1].Id, touristsWithFlights[0].Id);
    }
    
    @IsTest
    public static void testGetWithoutFlightsAndAppropriateAge() {
        List<Tourist__c> tourist = UnitTestFactory.getTourists();
        List<Tourist__c> touristsWithoutFlightsAndAppropriateAge = TouristManager.getWithoutFlightsAndAppropriateAge(UnitTestFactory.getTrips());
        
        System.assertEquals(3, touristsWithoutFlightsAndAppropriateAge.size());
        System.assertEquals(tourist[0].Id, touristsWithoutFlightsAndAppropriateAge[0].Id);
        
        touristsWithoutFlightsAndAppropriateAge = TouristManager.getWithoutFlightsAndAppropriateAge(new List<Trip__c>());
        
        System.assertEquals(0, touristsWithoutFlightsAndAppropriateAge.size());
    }
    
    @IsTest
    public static void testGetWithoutFlights() {
        List<Tourist__c> touristsWithoutFlights = TouristManager.getWithoutFlights();
        
        System.assertEquals(3, touristsWithoutFlights.size());
        System.assert(touristsWithoutFlights[0].Upcoming_Flight_Count__c == 0);
    }
    
    @IsTest
    public static void testGetTouristByFlight() {
        List<Flight__c> flight = UnitTestFactory.getFlights();
        List<Tourist__c> tourist = UnitTestFactory.getTourists();
        List<Tourist__c> touristsTouristByFlight = TouristManager.getTouristByFlight(flight);
        
        System.assertEquals(1, touristsTouristByFlight.size());
        System.assertEquals(tourist[1].Id, touristsTouristByFlight[0].Id);
        
        touristsTouristByFlight = TouristManager.getTouristByFlight(new List<Flight__c>());
        
        System.assertEquals(0, touristsTouristByFlight.size());
    }
    
    @IsTest
    public static void testGetByDuplicateCheck() {
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        String duplicateCheck = tourists[1].LastName__c + tourists[1].Email__c;
        
        List<Tourist__c> touristsByDuplicateCheck = TouristManager.getByDuplicateCheck(duplicateCheck);
        
        System.assertEquals(1, touristsByDuplicateCheck.size());
        System.assertEquals(duplicateCheck, touristsByDuplicateCheck[0].Duplicate_Check__c);
        
        touristsByDuplicateCheck = TouristManager.getByDuplicateCheck(null);
        
        System.assertEquals(0, touristsByDuplicateCheck.size());
    }
    
    @IsTest
    public static void testGetByRelationshipWithFlight() {
        List<Tourist__c> tourist = UnitTestFactory.getTourists();
        List<Tourist__c> touristsByRelationshipWithFlight = TouristManager.getByRelationshipWithFlight(UnitTestFactory.getId(tourist));
        
        System.assertEquals(1, touristsByRelationshipWithFlight.size());
        System.assertEquals(tourist[1].Id, touristsByRelationshipWithFlight[0].Id);
        
        touristsByRelationshipWithFlight = TouristManager.getByRelationshipWithFlight(new Set<Id>());
        
        System.assertEquals(0, touristsByRelationshipWithFlight.size());
    }
    
    @IsTest
    public static void testGetByNameAndAge() {
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        String name = tourists[1].Name;
        Decimal age = tourists[1].Age__c;
        List<Id> touristsId = new List<Id>();
        
        for (Tourist__c tourist : tourists) {
            touristsId.add(tourist.Id);
        }
        Test.setFixedSearchResults(touristsId);
        
        List<Tourist__c> touristsByNameAndAge = TouristManager.getByNameAndAge(name, age);
        
        System.assertEquals(2, touristsByNameAndAge.size());
        
        touristsByNameAndAge = TouristManager.getByNameAndAge(name, null);
        
        System.assertEquals(4, touristsByNameAndAge.size());
        
        touristsByNameAndAge = TouristManager.getByNameAndAge(null, null);
        
        System.assertEquals(0, touristsByNameAndAge.size());
    }
}