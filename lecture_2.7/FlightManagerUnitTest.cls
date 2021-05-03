@IsTest
public class FlightManagerUnitTest {
    @IsTest
    public static void testGetByStartDateAndTouristId() {
        UnitTestFactory.addOneFlight();
        List<Flight__c> flights = UnitTestFactory.getFlights();
        List<Flight__c> flightByStartDateAndTouristId = FlightManager.getByStartDateAndTouristId(UnitTestFactory.getTourists());
        
        System.assertEquals(1, flightByStartDateAndTouristId.size());
        System.assertEquals(flights[0].Id, flightByStartDateAndTouristId[0].Id);

        flightByStartDateAndTouristId = FlightManager.getByStartDateAndTouristId(new List<Tourist__c>());
        
        System.assertEquals(0, flightByStartDateAndTouristId.size());
    }
}