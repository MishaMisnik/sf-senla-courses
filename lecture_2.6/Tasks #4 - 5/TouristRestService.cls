@RestResource(urlMapping = '/Tourist/*') 
global class TouristRestService {
	
    @HttpGet
    global static List<List<Tourist__c>> getTourists() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String name = req.params.get('fuzzyname');
        String age = req.params.get('age');
        Integer intAge;

        if (name == null) {
            res.responseBody = Blob.valueOf('The name must be not empty');
            res.statusCode = 404;
            return null;
        }
        
        if (age != null) {
            if (!age.isNumeric()) {
                res.responseBody = Blob.valueOf('The age must be a number');
                res.statusCode = 404;
                return null;
            }
            intAge = Integer.valueof(age);
        }
		
        res.statusCode = 200;
        return TouristRestManager.getByNameAndAge(name, intAge);
    }
    
    
    @HttpPost
    global static Tourist__c createTourist(String name, String lastName, String email, String birthdate) {
        Date dateBirthdate = Date.valueOf(birthdate);
        String duplicateCheck = lastname + email;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        if (name == null || lastName == null || email == null || birthdate == null) {
            res.responseBody = Blob.valueOf('Not all required fields have been entered');
            res.statusCode = 404;
            return null; 
        }
        
        Tourist__c tourist = new Tourist__c (
            Name = name,
            Email__c = email,
            LastName__c = lastname,
            Birthdate__c = dateBirthdate
        );
        
        if (TouristService.isDuplicate(duplicateCheck)) {
            res.responseBody = Blob.valueOf('Found duplicate');
            res.statusCode = 409;
            return null;    
        }
        
        insert tourist;
        res.statusCode = 200;
        return tourist;
    }
}