public class SpacePointManager {
    
    public static Map<Id, Space_Point__c> getAll () {
        Map<Id, Space_Point__c> spacePointsMap = new Map<Id, Space_Point__c> ();
        List<Space_Point__c> spacePoints = [
            SELECT Id,
                   Latitude__c,
                   Longitude__c
            FROM Space_Point__c
        ];
        
        for (Space_Point__c spacePoint : spacePoints) {
            spacePointsMap.put(spacePoint.Id, spacePoint);
        }
        
        return spacePointsMap;
    }
    
    public static Map<Id, Space_Point__c> getById (Set<Id> ids) {
        if (ids.contains(null)) return new Map<Id, Space_Point__c>();
        
        Map<Id, Space_Point__c> spacePointsMap = new Map<Id, Space_Point__c> ();
        List<Space_Point__c> spacePoints = [
            SELECT Id,
                   Latitude__c,
                   Longitude__c
            FROM Space_Point__c
            WHERE Id In :ids
        ];
        
        for (Space_Point__c spacePoint : spacePoints) {
            spacePointsMap.put(spacePoint.Id, spacePoint);
        }
        
        return spacePointsMap;
    }
    
}