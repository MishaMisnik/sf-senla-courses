public class TouristService {
    
    public static void markDuplicates(List<Tourist__c> newTourists) {
        List<Tourist__c> updateTourists = new List<Tourist__c> {};
        
        for (Tourist__c tourist : newTourists) {
            List<Tourist__c> similarTourists = [
            	SELECT LastName__c, Email__c, IsDuplicate__c
            	FROM Tourist__c
            	WHERE LastName__c = :tourist.LastName__c AND Email__c = :tourist.Email__c AND IsDuplicate__c = false
        	];
        
        	if (similarTourists != null && !similarTourists.isEmpty()) {
          	   tourist.IsDuplicate__c = true;
         	   updateTourists.add(tourist);
        	}
        }
        
        update updateTourists;
    }
}
