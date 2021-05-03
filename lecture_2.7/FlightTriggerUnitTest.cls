@IsTest
private class FlightTriggerUnitTest {
    @IsTest
    static void testOnBeforeInsert() {
        Test.startTest();

        Tourist__c tourist = UnitTestFactory.createTourist('Misha', 'Misnik', 'misnik@salesforce.com', Date.newInstance(1996, 05, 05));
        insert tourist;
        List<Trip__c> trips = new List<Trip__c>{
                new Trip__c (Name = 'To Mars',Minimal_Age__c = 7, Start_Date__c = Date.newInstance(2021, 06, 06)),
                new Trip__c (Name = 'To Jupiter',Minimal_Age__c = 5, Start_Date__c = Date.newInstance(2019, 06, 06)),
                new Trip__c (Name = 'To Vener',Minimal_Age__c = 50, Start_Date__c = Date.newInstance(2021, 06, 06))
        };
        insert trips;

        tourist = [
                SELECT Id
                FROM Tourist__c
                LIMIT 1
        ];
        Trip__c trip = [
                SELECT Id
                FROM Trip__c
                WHERE Name = 'To Mars'
                LIMIT 1
        ];

        Flight__c flight = UnitTestFactory.createFlight(tourist, trip);
        Database.SaveResult result = Database.insert(flight, false);

        System.assert(result.isSuccess());

        trip = [
                SELECT Id
                FROM Trip__c
                WHERE Name = 'To Jupiter'
                LIMIT 1
        ];
        flight = UnitTestFactory.createFlight(tourist, trip);
        result = Database.insert(flight, false);

        System.assert(!result.isSuccess(), 'Cannot be inserted because of this trip, start date is not suitable ');

        trip = [
                SELECT Id
                FROM Trip__c
                WHERE Name = 'To Vener'
                LIMIT 1
        ];
        flight = UnitTestFactory.createFlight(tourist, trip);
        result = Database.insert(flight, false);

        System.assert(!result.isSuccess(), 'Cannot be inserted from this trip, minimal age is not suitable ');

        Test.stopTest();
    }
}