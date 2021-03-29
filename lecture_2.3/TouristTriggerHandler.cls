public class TouristTriggerHandler{
	public static Boolean onBeforeInsertIsFirstTime = true;
    public static Boolean onAfterUpdateIsFirstTime = true;
        
    public static void onBeforeInsert (List<Tourist__c> newTourists) {
        if (newTourists == null || newTourists.isEmpty()) return;
        TouristService.markDuplicates(newTourists);
    }

    public static void onAfterUpdate (List<Tourist__c> newTourists, List<Tourist__c> oldTourists) {
        if (newTourists == null || newTourists.isEmpty()) return;
        if (oldTourists == null || oldTourists.isEmpty()) return;
        
        List<Tourist__c> tourists = new List<Tourist__c> ();

        for (Integer i = 0; i < newTourists.size(); i++) {
            if (!newTourists[i].Active__c && oldTourists[i].Active__c) {
                tourists.add(newTourists[i]);
            }
        }
        List<Flight__c> flightsWithoutActTour = FlightManager.getByStartDateAndTouristId(Tourists); 
        List<Flight__c> flightsToUpdate = new List<Flight__c> ();
        
        for (Flight__c flight : flightsWithoutActTour) {
            flight.Status__c = 'Declined';
            flightsToUpdate.add(flight);
        }

        update flightsToUpdate;
    }
}