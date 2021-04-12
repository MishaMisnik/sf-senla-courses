public class TouristService {
    
    @Future
    public static void markDuplicates(Set<Id> touristIds) {
        if (touristIds == null  || touristIds.isEmpty()) return;
        
		List<Tourist__c> newTourists = TouristManager.getListById(touristIds);
        List<Tourist__c> similarTourists = TouristManager.getByLastNameAndEmail(newTourists);
        List<Tourist__c> updateTourists = new List<Tourist__c> ();
            
        for (Tourist__c tourist : newTourists) {
            Boolean isDuplicate = false;
            
            for (Tourist__c similartourist : similarTourists) {
                // Duplicate_Check__c - formula field - LastName__c + Email__c
                while (!isDuplicate && similarTourist.Duplicate_Check__c.contains(tourist.Duplicate_Check__c) && similarTourist.Id != tourist.Id) {
                    isDuplicate = true;
                } 
            }  
       
      	    if (isDuplicate) {
			    tourist.IsDuplicate__c = true;
         	    updateTourists.add(tourist);
            }
        }
        
        update updateTourists;
    }
}