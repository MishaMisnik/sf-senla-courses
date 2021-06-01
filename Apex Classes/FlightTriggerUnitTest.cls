@IsTest
private class FlightTriggerUnitTest {
    @TestSetup
    static void setup() {
        List<Tourist__c> tourists = new List<Tourist__c> { 
            new Tourist__c(Name = 'Misha', LastName__c = 'Misnik', Email__c = 'misnik@salesforce.com', Birthdate__c = Date.newInstance(1997, 05, 05))   
        };
        insert tourists;
        
        List<Trip__c> trips = new List<Trip__c>{
                new Trip__c (Name = 'To Mars', Minimal_Age__c = 7, Start_Date__c = Date.newInstance(2022, 06, 06)),
                new Trip__c (Name = 'To Jupiter', Minimal_Age__c = 5, Start_Date__c = Date.newInstance(2020, 06, 06)),
                new Trip__c (Name = 'To Vener', Minimal_Age__c = 50, Start_Date__c = Date.newInstance(2022, 06, 06))
        }; 
        Insert trips;
    } 
    
    @IsTest
    static void testOnBeforeInsert() {
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        List<Trip__c> trips = UnitTestFactory.getTrips();
		List<Flight__c> flights = new List<Flight__c>{
            new Flight__c (Tourist__c = tourists[0].Id, Trip__c = trips[0].Id),
            new Flight__c (Tourist__c = tourists[0].Id, Trip__c = trips[1].Id),
            new Flight__c (Tourist__c = tourists[0].Id, Trip__c = trips[2].Id)
        };
        
        Test.startTest();  
            Database.SaveResult[] result = Database.insert(flights, false);
		
            System.assert(result[0].isSuccess());

            System.assert(!result[1].isSuccess());
            System.assertEquals(FlightTriggerHandler.ERROR_DEPARTURE_FLIGHT, result[1].getErrors()[0].message); 

            System.assert(!result[2].isSuccess());
            System.assertEquals(FlightTriggerHandler.ERROR_INSUFFICIENT_MINIMAL_AGE, result[2].getErrors()[0].message);
        Test.stopTest();
    }
}