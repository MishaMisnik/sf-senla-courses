@IsTest
public class TripManagerUnitTest {
    @TestSetup
    static void setup() {
        List<Trip__c> trips = new List<Trip__c> {
            new Trip__c(Name = 'To Mars', Minimal_Age__c = 7, Start_Date__c = Date.newInstance(2021, 06, 06)),
            new Trip__c(Name = 'To Earth', Minimal_Age__c = 10, Start_Date__c = Date.newInstance(2021, 09, 09))  
        };
        insert trips;
    } 
    
    @IsTest
    public static void testGetById() {
        List<Trip__c> trips = UnitTestFactory.getTrips();
        Map<Id, Trip__c> tripsById = TripManager.getByIds(UnitTestFactory.getIds(trips));
        
        System.assertEquals(2, tripsById.size());
        System.assertEquals(trips[0].Id, tripsById.get(trips[0].Id).Id);
        
        tripsById = TripManager.getByIds(new Set<Id>());
        
        System.assertEquals(0, tripsById.size());
    }
}