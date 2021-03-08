public class TouristService {
    
    public static void markDuplicates(List<Tourist__c> newTourists) {
        
        List<Tourist__c> similarTourists = [
            SELECT LastName__c, Email__c, IsDuplicate__c
            FROM Tourist__c
            WHERE LastName__c = :newTourists[0].LastName__c AND Email__c = :newTourists[0].Email__c AND IsDuplicate__c = false
        ];
        
        for (Tourist__c similartourist  :  similarTourists) {
            similartourist.IsDuplicate__c = true;
        }
        
        update similarTourists;
    }
}