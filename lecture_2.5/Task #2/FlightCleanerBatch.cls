public class FlightCleanerBatch implements Database.Batchable<SObject>, Database.Stateful, Database.RaisesPlatformEvents {
	private static String status = 'Declined';
    //Days_After_Create__c - formula field: TODAY() - DATEVALUE( CreatedDate )
    private static String query = 'SELECT Id FROM Flight__c WHERE Status__c = :status AND Days_After_Create__c > 30';
    private static Map<Id, Integer> countDeleteFlights = new Map<Id, Integer>();
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Flight__c> flights) {
        List<Flight__c> flightsToDelete = new List<Flight__c>();
        
        for (Flight__c flight : flights) {
            Integer count = 0;
            
            if (countDeleteFlights.containsKey(flight.Tourist__c)){
                count = countDeleteFlights.get(flight.Tourist__c) + 1;
                countDeleteFlights.put(flight.Tourist__c, count);
            } else {
                count++;
                countDeleteFlights.put(flight.Tourist__c, count);
            }
            flightsToDelete.add(flight);
        }
        system.debug(flightsToDelete);
        delete flightsToDelete;
    }
    
    public void finish(Database.BatchableContext bc) {
		Map<Tourist__c, integer> result = convertMaps(countDeleteFlights);
        List<String> emails = getMetadataEmails();

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.toAddresses = emails;
        message.subject = 'HW';
        message.plainTextBody = 'Список туристов: ';
        for (Tourist__c tourist : result.keySet()) {
            message.plainTextBody += ' У пользователя ' + tourist.Name + ' удалено : ' + result.get(tourist) + ' рейса; ';
        }
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
    
    private static Map<Tourist__c, Integer> convertMaps (Map<Id, Integer> countDeleteFlights) {
        List<Tourist__c> tourists = TouristManager.getByRelationshipWithFlight(countDeleteFlights.keySet());
        Map<Tourist__c, integer> result = new Map<Tourist__c, Integer>();
        
        for (Tourist__c tourist : tourists) {
            result.put(tourist, countDeleteFlights.get(tourist.id));
	    }
        
        return result; 
    }
    
    public static List<String> getMetadataEmails () {
        List<Data__mdt> metaData = [
        	SELECT Email__c
            FROM Data__mdt
        ];
        List<String> emails = new List<String>();
        
        for (Data__mdt data : metaData){
  			emails.add(data.Email__c);
		}

        return emails;
    }
}