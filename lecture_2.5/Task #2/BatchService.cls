public class BatchService {
	
    public static Map<Tourist__c, Integer> convertMaps (Map<Id, Integer> countDeleteFlights) {
        List<Tourist__c> tourists = TouristManager.getByRelationshipWithFlight(countDeleteFlights.keySet());
        Map<Tourist__c, integer> result = new Map<Tourist__c, Integer>();
        
        for (Tourist__c tourist : tourists) {
            result.put(tourist, countDeleteFlights.get(tourist.id));
	    }
        
        return result;
    }
    
    public static List<Id> deleteResults (List<Flight__c> flightsToDelete, Map<Id, Id> touristIdToFlightId) {
		Database.DeleteResult[] deleteFlights = Database.delete(flightsToDelete, false);
        List<Id> idsToRemove = new List<Id>();
        
        for (Database.DeleteResult remoteFlight : deleteFlights) {
            if (!remoteFlight.isSuccess()) {
                for (Id flightId : touristIdToFlightId.keySet()) {
                    if (flightId == remoteFlight.getId()) {
                        idsToRemove.add(remoteFlight.getId());
                    }
                }
            }
        }
        
        return idsToRemove;
    }
    
    public static void sendEmails (List<String> emails, Map<Tourist__c, Integer> result) {
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
}