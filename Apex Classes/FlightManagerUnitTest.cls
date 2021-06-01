@IsTest
public class FlightManagerUnitTest {
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
    public static void testGetByStartDateAndTouristId() {
        List<Flight__c> flights = UnitTestFactory.getFlights();
        List<Flight__c> flightByStartDateAndTouristId = FlightManager.getByStartDateAndTouristId(UnitTestFactory.getTourists());
        
        System.assertEquals(1, flightByStartDateAndTouristId.size());
        System.assertEquals(flights[0].Id, flightByStartDateAndTouristId[0].Id);

        flightByStartDateAndTouristId = FlightManager.getByStartDateAndTouristId(new List<Tourist__c>());
        
        System.assertEquals(0, flightByStartDateAndTouristId.size());
    }
}