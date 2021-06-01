@RestResource(urlMapping = '/Tourist/*') 
global class TouristRestService {
    static final String REQUEST_PARAM_NAME = 'fuzzyname';
    static final String REQUEST_PARAM_AGE = 'age';
    
    @HttpGet
    global static List<Tourist__c> getTourists() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        String name = request.params.get(REQUEST_PARAM_NAME);
        String age = request.params.get(REQUEST_PARAM_AGE);
        List<Tourist__c> tourits = new List<Tourist__c> ();
        
        try {
            TouristService.getTouristValidation(name, age);
            tourits = TouristManager.getByNameAndAge(name, Decimal.valueOf(age));
            response.statusCode = Constants.OK_200;
        } catch (RestRequestValidationException ex) {
            response.responseBody = Blob.valueOf(ex.getMessage());
            response.statusCode = ex.getStatusCode();
        } catch (Exception ex) {
            response.responseBody = Blob.valueOf(Constants.INTERNAL_ERROR);
            response.statusCode = Constants.INTERNAL_ERROR_500; 
        }
        
        return tourits;
    }
    
    @HttpPost
    global static Tourist__c createTourist(String name, String lastName, String email, String birthdate) {
        RestResponse response = RestContext.response;
        Tourist__c tourist;
        
        try {
            TouristService.createTouristValidation(name, lastName, email, birthdate);
            tourist = new Tourist__c (
                Name = name,
                Email__c = email,
                LastName__c = lastname,
                Birthdate__c = Date.parse(birthdate)
            );
            
            insert tourist;
            response.statusCode = Constants.OK_200;
        } catch (RestRequestValidationException ex) {
            response.responseBody = Blob.valueOf(ex.getMessage());
            response.statusCode = ex.getStatusCode();
        } catch (Exception ex) {
            response.responseBody = Blob.valueOf(Constants.INTERNAL_ERROR);
            response.statusCode = Constants.INTERNAL_ERROR_500; 
        }
        
        return tourist;
    }
}