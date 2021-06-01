@IsTest
public class RestUnitTest {
    @TestSetup
    static void setup() {
        List<Tourist__c> tourists = new List<Tourist__c>{
            new Tourist__c(Name = 'Misha', LastName__c = 'Misnik', Email__c = 'misnik@salesforce.com', Birthdate__c = Date.newInstance(1998, 02, 01)),
        	new Tourist__c(Name = 'Ivan', LastName__c = 'Kyzmich', Email__c = 'Dima@salesforce.com', Birthdate__c = Date.newInstance(1996, 02, 01))
        };
        insert tourists;
    }
    
    @IsTest
    static  void testGetCallout() {
        List<Tourist__c> tourists = UnitTestFactory.getTourists();
        List<Id> touristsId = new List<Id>();
        
        for (Tourist__c t : tourists) {
            touristsId.add(t.Id);
        }
        
        Test.setFixedSearchResults(touristsId);
        
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Tourist'; 
        request.addParameter('fuzzyname', 'Misha');
        request.addParameter('age', '23');
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        RestResponse response = new RestResponse();
        RestContext.response = response;
      
        Test.startTest();
            List<Tourist__c> tour = TouristRestService.getTourists();
        Test.stopTest();
        
        System.assertEquals(1, tour.size());
        
        System.assertEquals('Misha', tour[0].Name);
        System.assertEquals(23, tour[0].Age__c);
    }   
    
    @IsTest
    static void testCreateTourist() {
        String json = '{"name" : "Dima", "lastName" : "Kozlov", "email" : "dima@salesforce.com", "birthdate" : "01/01/2000"}';
        
        RestRequest request = new RestRequest();
        request.requestURI ='/services/apexrest/Tourist';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(json);
        RestContext.request = request;
        
        RestResponse response = new RestResponse();
        RestContext.response = response;
        
        Test.startTest();        
            TouristRestService.createTourist('Dima', 'Kozlov', 'dima@salesforce.com', '01/01/2000');
        Test.stopTest();
        
        List<Tourist__c> tourists = [
            SELECT Id, 
                   Name,
                   lastName__c
            FROM Tourist__c
            WHERE Name = 'Dima'
        ];
        
        System.assertEquals(1, tourists.size());
    
        System.assertEquals('Kozlov', tourists[0].lastName__c);
    }

}
