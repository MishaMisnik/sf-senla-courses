@IsTest
public class TouristTriggerUnitTest {   
    @TestSetup
    static void setup() {
        List<Tourist__c> tourists = new List<Tourist__c> {
            new Tourist__c(
                Name = 'Misha', 
                LastName__c = 'Misnik', 
                Email__c = 'misnik@salesforce.com', 
                Birthdate__c = Date.newInstance(1997, 05, 05)
            ) 
        };
        insert tourists;
        
        List<Trip__c> trips = new List<Trip__c> {
            new Trip__c(
                Name = 'To Mars', 
                Minimal_Age__c = 7, 
                Start_Date__c = Date.newInstance(2021, 06, 06)
            )
        };
        insert trips;
        
        List<Flight__c> flights = new List<Flight__c> {
            new Flight__c(
                Tourist__c = tourists[0].Id, 
                Trip__c = trips[0].Id
            )
        };
        insert flights;
    } 
    
    @IsTest
    static void testAfterInsert() {
        Tourist__c tourist = new Tourist__c (
            Name = 'Dima',
            LastName__c = 'Misnik', 
            Email__c = 'misnik@salesforce.com', 
            Birthdate__c = Date.newInstance(1997, 08, 01)
        );
        
        Test.startTest();
            Database.SaveResult result = Database.insert(tourist, false);
        
            System.assert(result.isSuccess());
        Test.stopTest();
        
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        
        System.assert(tourists[1].IsDuplicate__c);
    }
    
    @IsTest
    static void testAfterUpdate() {
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        tourists[0].Active__c = false;
        
        Test.startTest();
            Database.SaveResult result = Database.update(tourists[0], false);
            
       	    System.assert(result.isSuccess());
        Test.stopTest();
        
        List<Flight__c> flights = UnitTestFactory.getFlights();
        
        System.assertEquals('Declined', flights[0].Status__c);
    }
}
