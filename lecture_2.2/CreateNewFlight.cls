public class CreateNewFlight {
    @InvocableMethod
    
    public static void createNewFlight(list<Trip__c> trip){
        List<Tourist__c> tourists = [
            SELECT id, Age__c
            FROM Tourist__c
            WHERE Age__c > :trip[0].minimal_age__c AND Upcoming_Flight_Count__c = 0
        ];
      
        for (Tourist__c tourist : tourists) {
            Flight__c flight =  new Flight__c(
                Tourist__c = tourist.Id,
                Trip__c = trip[0].Id,
                Status__c = 'Loading'
            );
            insert flight;
            
        }
    }
}