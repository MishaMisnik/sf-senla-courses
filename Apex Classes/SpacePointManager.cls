public class SpacePointManager {
    
    public static Map<Id, Space_Point__c> getAll () {
        
        return new Map<Id, Space_Point__c> ([
            SELECT Id,
                   Latitude__c,
                   Longitude__c
            FROM Space_Point__c
        ]);
    }
    
    public static Map<Id, Space_Point__c> getById (Set<Id> ids) {
        if (ids.isEmpty() || ids == null) return new Map<Id, Space_Point__c>();
        
        return new Map<Id, Space_Point__c> ([
            SELECT Id,
                   Latitude__c,
                   Longitude__c
            FROM Space_Point__c
            WHERE Id In :ids
        ]);
    }
    
}