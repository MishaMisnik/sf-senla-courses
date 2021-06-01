public class FlightManager {
    
    public static List<Flight__c> getByStartDateAndTouristId(List<Tourist__c> tourists) {
        if (tourists.isEmpty() || tourists == null) return new List<Flight__c>();
        
        Set<Id> touristsId = new Set<Id> ();
        
        for (Tourist__c tourist : tourists) {
             touristsId.add(tourist.Id);
        }
        
        return [
            SELECT id
            FROM Flight__c
            WHERE (Tourist__c IN :touristsId AND Trip__r.Start_Date__c > :date.today())
        ];
    }
}