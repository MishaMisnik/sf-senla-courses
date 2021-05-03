@IsTest
public class WeatherManagerUnitTest {
    @IsTest
    public static void testGetWithOldDate() {
        List<Weather_Daily_Forecast__c> weathers = new List<Weather_Daily_Forecast__c>{
            new Weather_Daily_Forecast__c(Space_Point__c = 'a045g000002X90pAAC', Date__c = Date.newInstance(2021, 04, 26)),
            new Weather_Daily_Forecast__c(Space_Point__c = 'a045g000002X90uAAC', Date__c = Date.newInstance(2021, 05, 26))    
        };

        insert weathers;

        List<Weather_Daily_Forecast__c> weatherFromMethod = WeatherManager.getWithOldDate();
        
        System.assertEquals(1, weatherFromMethod.size());
    } 
    
    @IsTest
    public static void testGetBySpacePoint() {
        List<Weather_Daily_Forecast__c> weathers = new List<Weather_Daily_Forecast__c>{
            new Weather_Daily_Forecast__c(Space_Point__c = 'a045g000002X90pAAC', Date__c = Date.newInstance(2021, 04, 26)),
            new Weather_Daily_Forecast__c(Space_Point__c = 'a045g000002X90uAAC', Date__c = Date.newInstance(2021, 05, 26))    
        };
        
        insert weathers;
        
        Map<Date, Weather_Daily_Forecast__c> weatherBySpacePoint = WeatherManager.getBySpacePoint(weathers[0].Space_Point__c);
        
        System.assertEquals(1, weatherBySpacePoint.size());

        weatherBySpacePoint = WeatherManager.getBySpacePoint(null);
        
        System.assertEquals(0, weatherBySpacePoint.size());
    }
}