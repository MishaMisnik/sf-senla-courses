public without sharing class TripInfoController {
    public Trip__c trip {get; set;}
    public List<Tourist__c> tourists {get; set;}
    
    public TripInfoController(ApexPages.StandardController stdController) {
        try {
            this.trip = (Trip__c)stdController.getRecord();
            this.tourists = TouristManager.getWithMinimalFlightsCount(trip.Id);
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error'));
        }
    }
}