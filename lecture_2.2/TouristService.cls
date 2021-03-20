public class TouristService {
    
    public static void markDuplicates(List<Tourist__c> newTourists) {
        if (newTourists!=null && !newTourists.isEmpty()) {
			List<Tourist__c> updateTourists = new List<Tourist__c> {};
        
        	for (Tourist__c tourist : newTourists) {
            	List<Tourist__c> similarTourists = TouristManager.getByNameAndEmailWithoutDuplicates(tourist.LastName__c, tourist.Email__c);
        
        		if (similarTourists != null && !similarTourists.isEmpty()) {
					tourist.IsDuplicate__c = true;
         	   		updateTourists.add(tourist);
        		}
        	}
        
        	update updateTourists;
		}
    }
}
