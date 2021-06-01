@IsTest
public class WeatherForecastUpdaterUnitTest {
    @IsTest
    static void testUpdateForecasts() {
        List<Space_Point__c> spacePoints = new List<Space_Point__c>{
            new Space_Point__c(Name = '#1', Country__c = 'Belarus', City__c = 'Grodno', Latitude__c = 53.68, Longitude__c = 23.84)
        };
        insert spacePoints;
        
        Test.startTest();
            WeatherForecastUpdater.updateForecasts();
        Test.stopTest();
        
        List<Weather_Daily_Forecast__c> weather = [
            SELECT Id
            FROM Weather_Daily_Forecast__c
        ];
        
        System.assertEquals(16, weather.size());
    }
}