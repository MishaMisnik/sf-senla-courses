public class WeatherForecastService {
    
    public static Map<String, Object> getForecasts(Double latitude, Double longitude){
        if (latitude == null || longitude == null) return new Map<String, Object>();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String url = 'https://api.weatherbit.io/v2.0/forecast/daily?lat=' + latitude + '&lon=' + longitude + '&key=8a76d367d14a4143990895fd7281e9f8';
        
        request.setEndpoint(url);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
		Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        
        return result;
    }
    
    public static void weatherUpdate(){
        List<Weather_Daily_Forecast__c> oldDailyWeather = WeatherManager.getWithOldDate();
        Set<Id> spacePointsIds = new Set<Id>();
        for (Weather_Daily_Forecast__c oldWeather : oldDailyWeather) {
            spacePointsIds.add(oldWeather.Space_Point__c);
        }
        
        Map<Id, Space_Point__c> spacePoints = SpacePointManager.getById(spacePointsIds);
        
        List<Weather_Daily_Forecast__c> toUpsert = new List<Weather_Daily_Forecast__c>();
        List<Weather_Daily_Forecast__c> toDelete = new List<Weather_Daily_Forecast__c>();
        
        for (Weather_Daily_Forecast__c oldWeather : oldDailyWeather) {
            Double latitude = Double.valueOf(spacePoints.get(oldWeather.Space_Point__c).Latitude__c);
            Double longitude = Double.valueOf(spacePoints.get(oldWeather.Space_Point__c).Longitude__c);
            Map<String, Object> weatherForSpacePoint = WeatherForecastService.getForecasts(latitude, longitude);
            
            if (weatherForSpacePoint == null) {
                return;
            }
            
            toDelete.add(oldWeather);
 
            List<Object> dataList = (List<object>) weatherForSpacePoint.get('data');
            Map<String, Object> data = (Map<String, Object>)dataList[15];
            
            Date newDate = Date.valueOf(data.get('valid_date').toString());
            Double newAvTemp = Double.valueOf(data.get('temp'));
            
            Weather_Daily_Forecast__c newWeather = new Weather_Daily_Forecast__c (
                Space_Point__c = spacePoints.get(oldWeather.Space_Point__c).Id,
                Date__c = Date.valueOf(data.get('valid_date').toString()),
                Average_Temperature__c = Double.valueOf(data.get('temp'))
            );
            toUpsert.add(newWeather);
        }
        
        upsert toUpsert;
        delete toDelete;
    }
    
    public static void weatherInsert(){
        Map<Id, Space_Point__c> spacePoints = SpacePointManager.getAll();
        List<Weather_Daily_Forecast__c> toInsert = new List<Weather_Daily_Forecast__c>();
        
        for (Space_Point__c spacePoint : spacePoints.values()) {
            Double latitude = Double.valueOf(spacePoint.Latitude__c);
            Double longitude = Double.valueOf(spacePoint.Longitude__c);
            Map<String, Object> weatherForSpacePoint = WeatherForecastService.getForecasts(latitude, longitude);
            
            List<Object> dataList = (List<object>) weatherForSpacePoint.get('data');

            for (Integer i = 0; i < dataList.size(); i++) {
                Map<String, Object> data =(Map<String, Object>)dataList[i];
                
                Weather_Daily_Forecast__c newWeather = new Weather_Daily_Forecast__c (
                        Space_Point__c = spacePoint.Id,
                        Date__c = Date.valueOf(data.get('valid_date').toString()),
                        Average_Temperature__c = Double.valueOf(data.get('temp'))
                );
                
                toInsert.add(newWeather);
            }
        }
        
        insert toInsert;
    }
}