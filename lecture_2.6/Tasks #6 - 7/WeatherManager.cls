public class WeatherManager {
	
    public static List<Weather_Daily_Forecast__c> getWithOldDate () {
        
        return [
            SELECT Space_Point__c,
                   Date__c
            FROM Weather_Daily_Forecast__c
            WHERE Date__c < :Date.today()
        ];
    }
    
    public static List<Weather_Daily_Forecast__c> getBySpacePoint (Set<Id> spacePointsIds) {
        if (spacePointsIds.contains(null)) return new List<Weather_Daily_Forecast__c>();
        
        return [
            SELECT Id,
                   Space_Point__c,
                   Date__c,
            	   Average_Temperature__c
            FROM Weather_Daily_Forecast__c
            WHERE Space_Point__c IN :spacePointsIds
        ];
    }
}