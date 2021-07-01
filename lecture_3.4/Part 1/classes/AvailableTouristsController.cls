public inherited sharing class AvailableTouristsController {
	
    @AuraEnabled(cacheable = true)
    public static List<Tourist__c> getTourists(Integer limits ,Integer offset, Trip__c trip) {
        if (limits == null || offset == null || trip == null) return new List<Tourist__c>();
        
        return TouristManager.getByTripParams(limits, offset, trip);
    }

    @AuraEnabled
    public static Boolean createFlights(List<Tourist__c> tourists, Trip__c trip) {
		if (tourists.isEmpty() ||  tourists == null) return false;
        
        return TripServise.createFlightsOfferPending(tourists, trip);
    }
}