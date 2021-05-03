@IsTest
public class TripManagerUnitTest {
    @IsTest
    public static void testGetById() {
        UnitTestFactory.addOneTrip();
        Map<Id, Trip__c> tripsById = TripManager.getById(UnitTestFactory.getId(UnitTestFactory.getTrips()));
        
        System.assertEquals(1, tripsById.size());

        tripsById = TripManager.getById(new Set<Id>());
        
        System.assertEquals(0, tripsById.size());
    }
}