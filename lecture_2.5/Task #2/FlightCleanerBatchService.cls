public class FlightCleanerBatchService {
    
    public static Map<Tourist__c, Integer> convertMaps (Map<Id, Integer> countDeleteFlights) {
        List<Tourist__c> tourists = TouristManager.getByRelationshipWithFlight(countDeleteFlights.keySet());
        Map<Tourist__c, integer> result = new Map<Tourist__c, Integer>();
        
        for (Tourist__c tourist : tourists) {
            result.put(tourist, countDeleteFlights.get(tourist.id));
        }
        
        return result;
    }
    
    public static Map<Id, Integer> deleteFlights (List<Flight__c> flights) {
        Map<Id, Flight__c> flightsById = new Map<Id, Flight__c> (flights);
        Map<Id, Integer> countDeleteFlightsForTouristId = new Map<Id, Integer> ();        
        Database.DeleteResult[] deleteFlights = Database.delete(flights, false);
        Integer count = 0;
        
        for (Database.DeleteResult remoteFlight : deleteFlights) {
            if (remoteFlight.isSuccess()) {
                count = 1;
                
                if (countDeleteFlightsForTouristId.containsKey(flightsById.get(remoteFlight.getId()).Tourist__c)){
                    count += countDeleteFlightsForTouristId.get(flightsById.get(remoteFlight.getId()).Tourist__c);
                    countDeleteFlightsForTouristId.put(flightsById.get(remoteFlight.getId()).Tourist__c, count);
                } else {
                    countDeleteFlightsForTouristId.put(flightsById.get(remoteFlight.getId()).Tourist__c, count);
                }
            }
        }
        
        return countDeleteFlightsForTouristId;
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