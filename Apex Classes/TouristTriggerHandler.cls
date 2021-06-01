public class TouristTriggerHandler{
    public static Boolean onAfterInsertIsFirstTime = true;
    public static Boolean onAfterUpdateIsFirstTime = true;
    
    public static void onAfterInsert (List<Tourist__c> newTourists) {
        if (newTourists.isEmpty()) return;
        
        Set<Id> touristsIds = TouristManager.getIds(newTourists);
        TouristService.markDuplicates(touristsIds);
    }
    
    public static void onAfterUpdate (Map<Id, Tourist__c> newTourists, Map<Id, Tourist__c> oldTourists) {
        if (newTourists.isEmpty() || oldTourists.isEmpty()) return;
        
        List<Tourist__c> tourists = new List<Tourist__c> ();
        
        for (Tourist__c tourist : newTourists.values()) {
            Tourist__c newTourist = newTourists.get(tourist.Id);
            Tourist__c oldTourist = oldTourists.get(tourist.Id);
            
            if (newTourists != null || oldTourist != null) {
                if (!newTourist.Active__c && oldTourist.Active__c) {
                    tourists.add(tourist);
                }
            }
        }
        
        List<Flight__c> flightsWithoutActTour = FlightManager.getByStartDateAndTouristId(tourists); 
        List<Flight__c> flightsToUpdate = new List<Flight__c> ();
        
        for (Flight__c flight : flightsWithoutActTour) {
            flight.Status__c = 'Declined';
            flightsToUpdate.add(flight);
        }
        
        update flightsToUpdate;
    }
}