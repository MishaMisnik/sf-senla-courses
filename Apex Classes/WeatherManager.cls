public class WeatherManager {
	
    public static List<Weather_Daily_Forecast__c> getWithOldDate () {
        
        return [
            SELECT Id,
                   Space_Point__c,
                   Date__c
            FROM Weather_Daily_Forecast__c
            WHERE Date__c < :Date.today()
        ];
    }
    
    public static Map<Date, Weather_Daily_Forecast__c> getBySpacePoint (Id spacePointId) {
        if (spacePointId == null) return new Map<Date, Weather_Daily_Forecast__c>();
        
        Map<Date, Weather_Daily_Forecast__c> weather = new Map<Date, Weather_Daily_Forecast__c>();
        List<Weather_Daily_Forecast__c> weatherList = [
            SELECT Id,
                   Space_Point__c,
                   Date__c,
            	   Average_Temperature__c
            FROM Weather_Daily_Forecast__c
            WHERE Space_Point__c = :spacePointId
        ];
        
        for (Weather_Daily_Forecast__c dailyWeather : weatherList) {
            weather.put(dailyWeather.Date__c, dailyWeather);
        }
        
        return weather;
    }
}