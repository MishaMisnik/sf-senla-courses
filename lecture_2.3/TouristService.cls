public class TouristService {
    
    public static void markDuplicates(List<Tourist__c> newTourists) {
        if (newTourists == null  || newTourists.isEmpty()) return;
        
        List<Tourist__c> updateTourists = new List<Tourist__c> {};
        List<Tourist__c> similarTourists = TouristManager.getByLastNameAndEmail(newTourists);
        //Duplicate_Check__c - formula field: LastName__c + Email__c
        for (Tourist__c tourist : newTourists) {
            Boolean check = true;
            Boolean isDuplicate = false;
            
            for (Tourist__c similarTourist : similarTourists) {
                if (similarTourist.Duplicate_Check__c.contains(tourist.Duplicate_Check__c) && check) {
                    isDuplicate = true;
                    check = false;
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
