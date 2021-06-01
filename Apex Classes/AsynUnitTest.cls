@IsTest
public class AsynUnitTest {
    @testSetup
    static void setup() {
        Tourist__c tourist = new Tourist__c(
            Name = 'Misha', 
            LastName__c = 'Misnik', 
            Email__c = 'misnik@salesforce.com', 
            Birthdate__c = Date.newInstance(1997, 05, 05)
        );
        insert tourist;

        Trip__c trip = new Trip__c(
            Name = 'To Mars', 
            Minimal_Age__c = 7, 
            Start_Date__c = Date.newInstance(2021, 06, 06)
        );
        insert trip;
        
        Flight__c flight = new Flight__c(
            Status__c = 'Declined', 
            Tourist__c = tourist.Id, 
            Trip__c = trip.Id
        );
        insert flight;
    } 
    
    @IsTest
    public static void testMarkDuplicates() {        
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
    public static void testFlightCleanerBatch() {
        List<Flight__c> flights = UnitTestFactory.getFlights();
        Datetime dt = Datetime.now().addDays(-31);
        
        Test.setCreatedDate(flights[0].Id, dt);
        
        Test.startTest();
        	FlightCleanerBatch flightBatch = new FlightCleanerBatch();
			Database.executebatch(flightBatch);
        Test.stopTest();
        
        flights = UnitTestFactory.getFlights();
        
        System.assertEquals(0, flights.size());
    }
    
    @IsTest
    public static void testFlightWorkSchedule() {
		List<Flight__c> flights = UnitTestFactory.getFlights();
        
        Datetime dt = Datetime.now().addDays(-31);
        Test.setCreatedDate(flights[0].Id, dt);
        
        Test.startTest();
        	String cron = '0 0 0 15 3 ? 2022';
        	FlightWorkSchedule fws = new FlightWorkSchedule();
            String jobId = System.schedule('Flight Cleaner Schedule',cron ,fws);
        Test.stopTest();
        
        List<AsyncApexJob> jobsScheduled = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'ScheduledApex'];
        
    	System.assertEquals(1, jobsScheduled.size(), 'expecting one scheduled job');
    	System.assertEquals('FlightWorkSchedule', jobsScheduled[0].ApexClass.Name, 'expecting specific scheduled job');

    	List<AsyncApexJob> jobsApexBatch = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'BatchApex'];
        
    	System.assertEquals(1, jobsApexBatch.size(), 'expecting one apex batch job');
    	System.assertEquals('FlightCleanerBatch', jobsApexBatch[0].ApexClass.Name, 'expecting specific batch job');
    }
}