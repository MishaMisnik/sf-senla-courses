public class FlightCleanerBatch implements Database.Batchable<SObject>, Database.Stateful, Database.RaisesPlatformEvents {
     String status = 'Declined';
    //Days_After_Create__c - formula field: TODAY() - DATEVALUE( CreatedDate )
    private String query = 'SELECT Id FROM Flight__c WHERE Status__c = :status AND Days_After_Create__c > 30';
    private Map<Id, Integer> countDeleteFlightsForTouristId = new Map<Id, Integer>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Flight__c> flights) {
        List<Flight__c> flightsToDelete = new List<Flight__c>();
        Map<Id, Id> touristIdToFlightId = new Map<Id, Id>();
        
        for (Flight__c flight : flights) {
            Integer count = 0;

            if (countDeleteFlightsForTouristId.containsKey(flight.Tourist__c)){
                count = countDeleteFlightsForTouristId.get(flight.Tourist__c) + 1;
                countDeleteFlightsForTouristId.put(flight.Tourist__c, count);
            } else {
                count++;
                countDeleteFlightsForTouristId.put(flight.Tourist__c, count);
            }

            touristIdToFlightId.put(flight.Id, flight.Tourist__c);
            flightsToDelete.add(flight);
        }

        List<Id> idsToRemove =  BatchService.deleteResults(flightsToDelete, touristIdToFlightId);
                
        for (Id idToRemove : idsToRemove) {
            countDeleteFlightsForTouristId.remove(idToRemove);
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        Map<Tourist__c, Integer> result = BatchService.convertMaps(countDeleteFlightsForTouristId);
        List<String> emails = MetadataManager.getAllMetadataEmails();

        BatchService.sendEmails(emails, result);
    }
}