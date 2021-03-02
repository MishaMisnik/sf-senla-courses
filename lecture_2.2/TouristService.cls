public class TouristService {
    
    public static void markDuplicates(List<Tourist__c> newTourists) {
        integer listSize = newTourists.size();
        
        for (integer i = 0; i < listSize; i++){
            Boolean duplicateCheck = newTourists[i].IsDuplicate__c;
            
            if(!duplicateCheck){
                
                for(integer j = 0; j < listSize && j != i; j++){
                    String firstLastName = newTourists[i].LastName__c;
                    String secondLastName = newTourists[j].LastName__c;
                    
                    String firstEmail = newTourists[i].Email__c;
                    String secondEmail = newTourists[j].Email__c;
                    
                    if (firstLastName == secondLastName && firstEmail == secondEmail){
                        newTourists[i].IsDuplicate__c = true;
                        update newTourists[i];
                        newTourists[j].IsDuplicate__c = true;
                        update newTourists[j];
                    }
                }  
            }
        }
    }
}