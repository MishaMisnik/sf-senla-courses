@IsTest
public class WeatherManagerUnitTest {
    @TestSetup
    static void setup() {
        List<Weather_Daily_Forecast__c> weathers = new List<Weather_Daily_Forecast__c>{
            new Weather_Daily_Forecast__c(Space_Point__c = 'a045g000002X90pAAC', Date__c = Date.newInstance(2021, 04, 26)),
            new Weather_Daily_Forecast__c(Space_Point__c = 'a045g000002X90uAAC', Date__c = Date.newInstance(2021, 05, 26))    
        };
        insert weathers;
    } 
    
    @IsTest
    public static void testGetWithOldDate() {
        List<Weather_Daily_Forecast__c> weather = UnitTestFactory.getWeather();
        List<Weather_Daily_Forecast__c> weatherWithOldDate = WeatherManager.getWithOldDate();
        
        System.assertEquals(1, weatherWithOldDate.size());
        System.assertEquals(weather[0].Id, weatherWithOldDate[0].Id);
    }
    
    @IsTest
    public static void testGetBySpacePoint() {
        List<Weather_Daily_Forecast__c> weather = UnitTestFactory.getWeather();
        Map<Date, Weather_Daily_Forecast__c> weatherBySpacePoint = WeatherManager.getBySpacePoint(weather[0].Space_Point__c);
        
        System.assertEquals(1, weatherBySpacePoint.size());
        System.assertEquals(weather[0].Id, weatherBySpacePoint.get(weather[0].Date__c).Id);
        
        weatherBySpacePoint = WeatherManager.getBySpacePoint(null);
        
        System.assertEquals(0, weatherBySpacePoint.size());
    }
}