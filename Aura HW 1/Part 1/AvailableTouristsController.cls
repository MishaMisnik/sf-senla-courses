public class AvailableTouristsController {
	
    @AuraEnabled
    public static List<Tourist__c> getTourists(Integer limits ,Integer offset, Trip__c trip) {
        if (limits == null || offset == null || trip == null) return new List<Tourist__c>();
        
        return [ 
            SELECT Id, Name, LastName__c, Email__c, Gender__c
            FROM Tourist__c
            WHERE Active__c = true AND Age__c >= :trip.Minimal_Age__c AND Id NOT IN (SELECT Tourist__c FROM Flight__c WHERE Trip__r.Start_Date__c = :Date.today() OR Trip__c = :trip.Id)
            ORDER BY Name
            LIMIT :limits
            OFFSET :offset
        ];
    }

    @AuraEnabled
    public static Boolean createFlgihts(List<Tourist__c> tourists, Trip__c trip) {
		if (tourists.isEmpty() ||  tourists == null) return false;
        
        Boolean isComplete = true;
        List<Flight__c> flights = new List<Flight__c>();
        
        for (Tourist__c tourist : tourists) {
            Flight__c newFlight = new Flight__c(
            	Status__c = 'Offer Pending',
                Tourist__c = tourist.Id,
                Trip__c = trip.Id
            );
            flights.add(newFlight);
        }
        
        try{
            insert flights;
        } catch(DmlException e) {
            isComplete = false;
            System.debug('Error : ' + e.getMessage());
        }
        
        return isComplete;
    }
}
