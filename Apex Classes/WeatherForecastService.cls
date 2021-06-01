public with sharing class WeatherForecastService {
    static final String WEATHER_BIT_DATA = 'data';
    static final String WEATHER_BIT_VALID_DATE = 'valid_date';
    static final String WEATHER_BIT_TEMP = 'temp';
    static final Integer NUMBER_DAYS_TO_UPSERT  = 16;
    
    public static Map<Date, Decimal> getForecasts(HttpResponse response){
        if (response == null) return new Map<Date, Decimal>();
        
        Map<Date, Decimal> result = new Map<Date, Decimal>();
        
        if (response.getStatusCode() == Constants.OK_200) {
            Map<String, Object> weatherForSpacePoint = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        
            List<Object> dataList = (List<Object>) weatherForSpacePoint.get(WEATHER_BIT_DATA);
            List<Map<String, Object>> valuesByParameters = new List<Map<String, Object>>();
        
            for (Object objects : dataList) {
                valuesByParameters.add((Map<String, Object>)objects);
            }
            
            for (Map<String, Object> value : valuesByParameters) {
                result.put(Date.valueOf(value.get(WEATHER_BIT_VALID_DATE).toString()) , 
                (Decimal) (value.get(WEATHER_BIT_TEMP)));
            }
        } else {
            System.debug(response.getStatusCode() + ' : ' + response.getBody());
        }
        
        return result;
    }
    
    @future(callout=true)
    public static void weatherUpdate(){
        List<Weather_Daily_Forecast__c> toUpsert = new List<Weather_Daily_Forecast__c>();
        Map<Id, Space_Point__c> allSpacePoints = SpacePointManager.getAll();
        List<Weather_Daily_Forecast__c> weatherWithOldDate = WeatherManager.getWithOldDate();
        
        for (Id spacePoint : allSpacePoints.keySet()) {
            Decimal latitude = allSpacePoints.get(spacePoint).Latitude__c;
            Decimal longitude = allSpacePoints.get(spacePoint).Longitude__c;
			
            Http http = new Http();
            HttpRequest request = createrRequest(latitude, longitude);
            HttpResponse response = http.send(request);
            
            Map<Date, Decimal> weatherForSpacePoint = getForecasts(response);
            Map<Date, Weather_Daily_Forecast__c> weather = WeatherManager.getBySpacePoint(spacePoint);
    
            for (Integer i = 0; i < NUMBER_DAYS_TO_UPSERT; i++) {
                Date desiredDate = date.today().addDays(i);
                
                if (weather.containsKey(desiredDate)) {
                    Weather_Daily_Forecast__c dailyWeather = new Weather_Daily_Forecast__c(
                        Id = weather.get(desiredDate).Id,
                        Space_Point__c = spacePoint,
                        Date__c = desiredDate,
                        Average_Temperature__c = weatherForSpacePoint.get(desiredDate)
                    );
                    toUpsert.add(dailyWeather);
                } else {
                    Weather_Daily_Forecast__c dailyWeather = new Weather_Daily_Forecast__c(
                        Space_Point__c = spacePoint,
                        Date__c = desiredDate,
                        Average_Temperature__c = weatherForSpacePoint.get(desiredDate)
                    );
                    toUpsert.add(dailyWeather);
                }
            }
        }
        
        delete weatherWithOldDate;
        
        try {
            upsert toUpsert;
        } catch (DmlException ex) {
            System.debug(LoggingLevel.ERROR, ex.getMessage());
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e.getMessage());
        }
    }
    
    public static HttpRequest createrRequest(Decimal latitude, Decimal longitude) {
        if (latitude == null || longitude == null) return new HttpRequest();
        
        String endPoint = Constants.WEATHERBIT_URL + 
            + '?lat=' + latitude 
            + '&lon=' + longitude 
            + '&key=' + Constants.WEATHERBIT_KEY;
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod(Constants.HTTP_METHOD_GET);
        
        return request;
    }
}