public class FlightCleanerBatch implements Database.Batchable<SObject>, Database.Stateful, Database.RaisesPlatformEvents {
    private String status = '\'Declined\'';
    //Days_After_Create__c - formula field: TODAY() - DATEVALUE( CreatedDate )
    private String query = 'SELECT Id, Tourist__c FROM Flight__c WHERE Status__c = ' + status + ' AND Days_After_Create__c > 30';
    private Map<Id, Integer> countDeleteFlightsForTouristId = new Map<Id, Integer>();
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Flight__c> flights) {
        countDeleteFlightsForTouristId = FlightCleanerBatchService.deleteFlights(flights);
    }
    
    public void finish(Database.BatchableContext bc) {
        Map<Tourist__c, Integer> result = FlightCleanerBatchService.convertMaps(countDeleteFlightsForTouristId);
        List<String> emails = MetadataManager.getAllMetadataEmails();
        
        FlightCleanerBatchService.sendEmails(emails, result);
    }
}