@IsTest
public class TouristTriggerUnitTest {
    @IsTest
    static void testAfterInsert() {
        Tourist__c firstTourist = new Tourist__c(
                Name = 'Misha',
                LastName__c = 'Misnik',
                Email__c = 'misnik@salesforce.com',
                Birthdate__c = Date.newInstance(1997, 05, 05)
        );
        Tourist__c secondTourist = new Tourist__c(
                Name = 'Dima',
                LastName__c = 'Misnik',
                Email__c = 'misnik@salesforce.com',
                Birthdate__c = Date.newInstance(1997, 05, 05)
        );
        
        Test.startTest();
        Database.SaveResult result = Database.insert(firstTourist, false);

        System.assert(result.isSuccess());

        result = Database.insert(secondTourist, false);
        
        System.assert(result.isSuccess());
        Test.stopTest();
    }
    
    @IsTest
    static void testAfterUpdate() {
        UnitTestFactory.addOneFlight();
        Tourist__c tourist = [SELECT Active__c FROM Tourist__c];
        tourist.Active__c = false;

        Test.startTest();
        Database.SaveResult result = Database.update(tourist, false);

        System.assert(result.isSuccess());

        Test.stopTest();
    }
}