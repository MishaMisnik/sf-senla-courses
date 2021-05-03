@IsTest
private class TouristManagerUnitTest {    
    @IsTest
    public static void testGetByName() {
        UnitTestFactory.addThreeTourists();
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        List<Tourist__c> touristsByName = TouristManager.getByName(tourists[0].Name);
        
        System.assertEquals(1, touristsByName.size());
        System.assertEquals(tourists[0].Name, touristsByName[0].Name);

        touristsByName = TouristManager.getByName(null);
        
        System.assertEquals(0, touristsByName.size());
    } 
    
    @IsTest
    public static void testGetById() {
        UnitTestFactory.addThreeTourists();
        Set<Id> ids = UnitTestFactory.getId(UnitTestFactory.getTourists());
        Map<Id, Tourist__c> touristsById = TouristManager.getById(ids);
        
        System.assertEquals(3, touristsById.size());

        touristsById = TouristManager.getById(new Set<Id>());
        
        System.assertEquals(0, touristsById.size());
    }
    
    @IsTest
    public static void testGetListById() {
        UnitTestFactory.addThreeTourists();
        Set<Id> ids = UnitTestFactory.getId(UnitTestFactory.getTourists());
        List<Tourist__c> touristsListById = TouristManager.getListById(ids);
        
        System.assertEquals(3, touristsListById.size());

        touristsListById = TouristManager.getListById(new Set<Id>());
        
        System.assertEquals(0, touristsListById.size());
    }
    
    @IsTest
    public static void testGetByLastNameAndEmail() {
        UnitTestFactory.addThreeTouristsWithDuplicate();
        List<Tourist__c> tourist = [
            SELECT Id,
                   Name,
                   Duplicate_Check__c
            FROM Tourist__c
            WHERE Name = 'Misha'
        ];
        List<Tourist__c> touristsByLastNameAndEmail = TouristManager.getByLastNameAndEmail(tourist);
        
        System.assertEquals(1, touristsByLastNameAndEmail.size());
        System.assertEquals(tourist[0].Duplicate_Check__c, touristsByLastNameAndEmail[0].Duplicate_Check__c);

        touristsByLastNameAndEmail = TouristManager.getByLastNameAndEmail(new List<Tourist__c>());
        
        System.assertEquals(0, touristsByLastNameAndEmail.size());
    }
    
    @IsTest
    public static void testGetByAge() {
        UnitTestFactory.addThreeTourists();
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        Set<Integer> ages = new Set<Integer>();
        
        for (Tourist__c tourist : tourists) {
            ages.add(tourist.Age__c.intValue());
        }
        
        List<Tourist__c> touristsByAge = TouristManager.getByAge(ages);
            
        System.assertEquals(3, touristsByAge.size());

        touristsByAge = TouristManager.getByAge(new Set<Integer>());
        
        System.assertEquals(0, touristsByAge.size());
    }
    
    @IsTest
    public static void testGetByDateStart() {
        UnitTestFactory.addOneFlight();
        List<Tourist__c> tourist = UnitTestFactory.getTourists();
        Date startDate = Date.today();
        List<Tourist__c> touristsByDateStart = TouristManager.getByDateStart(startDate);
        
        System.assertEquals(1, touristsByDateStart.size());
        System.assertEquals(tourist[0].Id, touristsByDateStart[0].Id);

        touristsByDateStart = TouristManager.getByDateStart(null);
        
        System.assertEquals(0, touristsByDateStart.size());
    }
    
    @IsTest
    public static void testGetWithFlights() {
        UnitTestFactory.addOneFlight();
        List<Tourist__c> tourist = UnitTestFactory.getTourists();
        List<Tourist__c> touristsWithFlights = TouristManager.getWithFlights();
        
        System.assertEquals(1, touristsWithFlights.size());
        System.assertEquals(tourist[0].Id, touristsWithFlights[0].Id);
    }
    
    @IsTest
    public static void testGetWithoutFlightsAndAppropriateAge() {
        UnitTestFactory.addOneTourist();
        UnitTestFactory.addOneTrip();
        List<Tourist__c> tourist = UnitTestFactory.getTourists();
        List<Tourist__c> touristsWithoutFlightsAndAppropriateAge = TouristManager.getWithoutFlightsAndAppropriateAge(UnitTestFactory.getTrips());
        
        System.assertEquals(1, touristsWithoutFlightsAndAppropriateAge.size());
        System.assertEquals(tourist[0].Id, touristsWithoutFlightsAndAppropriateAge[0].Id);

        touristsWithoutFlightsAndAppropriateAge = TouristManager.getWithoutFlightsAndAppropriateAge(new List<Trip__c>());
        
        System.assertEquals(0, touristsWithoutFlightsAndAppropriateAge.size());
    }
    
    @IsTest
    public static void testGetWithoutFlights() {
        UnitTestFactory.addThreeTourists();
        List<Tourist__c> touristsWithoutFlights = TouristManager.getWithoutFlights();
        
        System.assertEquals(3, touristsWithoutFlights.size());
        System.assert(touristsWithoutFlights[0].Upcoming_Flight_Count__c == 0);
    }
    
    @IsTest
    public static void testGetTouristByFlight() {
        UnitTestFactory.addOneFlight();  
        List<Tourist__c> tourist = UnitTestFactory.getTourists();
        List<Tourist__c> touristsTouristByFlight = TouristManager.getTouristByFlight(UnitTestFactory.getFlights());
        
        System.assertEquals(1, touristsTouristByFlight.size());
        System.assertEquals(tourist[0].Id, touristsTouristByFlight[0].Id);

        touristsTouristByFlight = TouristManager.getTouristByFlight(new List<Flight__c>());
        
        System.assertEquals(0, touristsTouristByFlight.size());
    }
    
    @IsTest
    public static void testGetByDuplicateCheck() {
        UnitTestFactory.addOneTourist();
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        String duplicateCheck = tourists[0].LastName__c + tourists[0].Email__c;
        
        List<Tourist__c> touristsByDuplicateCheck = TouristManager.getByDuplicateCheck(duplicateCheck);
        
        System.assertEquals(1, touristsByDuplicateCheck.size());
        System.assertEquals(duplicateCheck, touristsByDuplicateCheck[0].Duplicate_Check__c);

        touristsByDuplicateCheck = TouristManager.getByDuplicateCheck(null);
        
        System.assertEquals(0, touristsByDuplicateCheck.size());
    }
    
    @IsTest
    public static void testGetByRelationshipWithFlight() {
        UnitTestFactory.addOneFlight();
        List<Tourist__c> tourist = UnitTestFactory.getTourists();
        Set<Id> ids = UnitTestFactory.getId(tourist);
        List<Tourist__c> touristsByRelationshipWithFlight = TouristManager.getByRelationshipWithFlight(ids);
        
        System.assertEquals(1, touristsByRelationshipWithFlight.size());
        System.assertEquals(tourist[0].Id, touristsByRelationshipWithFlight[0].Id);

        touristsByRelationshipWithFlight = TouristManager.getByRelationshipWithFlight(new Set<Id>());
        
        System.assertEquals(0, touristsByRelationshipWithFlight.size());
    }
    
    @IsTest
    public static void testGetByNameAndAge() {
        UnitTestFactory.addThreeTourists();
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        String name = tourists[0].Name;
        Decimal age = tourists[0].Age__c;

        List<Tourist__c> touristsByNameAndAge = TouristManager.getByNameAndAge(name, age);
        
        System.assertEquals(1, touristsByNameAndAge.size());

        touristsByNameAndAge = TouristManager.getByNameAndAge(name, null);
        
        System.assertEquals(1, touristsByNameAndAge.size());

        touristsByNameAndAge = TouristManager.getByNameAndAge(null, null);
        
        System.assertEquals(0, touristsByNameAndAge.size());
    }
}