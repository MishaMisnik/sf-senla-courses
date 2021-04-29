public class TouristService {
    static final String NAME_ERROR = 'The name must be not empty';
    static final String INCORRECT_AGE_ERROR = 'The age must be a number';
    static final String INCORRECT_INPUD_DATA_ERROR = 'Not all required fields have been entered';
    static final String INCORRECT_INPUD_DATE_ERROR = 'Date field format does not match';
    
    @Future
    public static void markDuplicates(Set<Id> touristIds) {
        if (touristIds == null  || touristIds.isEmpty()) return;
        
        List<Tourist__c> newTourists = TouristManager.getListById(touristIds);
        List<Tourist__c> similarTourists = TouristManager.getByLastNameAndEmail(newTourists);
        List<Tourist__c> updateTourists = new List<Tourist__c> ();
            
        for (Tourist__c tourist : newTourists) {
            Boolean isDuplicate = false;
            
            for (Tourist__c similartourist : similarTourists) {
                // Duplicate_Check__c - formula field - LastName__c + Email__c
                while (!isDuplicate && similarTourist.Duplicate_Check__c.contains(tourist.Duplicate_Check__c) && similarTourist.Id != tourist.Id) {
                    isDuplicate = true;
                } 
            }  
       
            if (isDuplicate) {
                tourist.IsDuplicate__c = true;
                updateTourists.add(tourist);
            }
        }
        
        update updateTourists;
    }
    
    public static Boolean isDuplicate(String duplicateCheck) {
        if (duplicateCheck == null) return false;
        List<Tourist__c> tourist = TouristManager.getByDuplicateCheck(duplicateCheck);
        
        if (tourist.isEmpty()) {
            return false;
        }
        
        return true;
    }
    
    public static void getTouristValidation (String name, String age) {
        RestRequestValidationException validationException = new RestRequestValidationException();
        
        try {
            Integer intAge = Integer.valueOf(age);
        } catch (Exception ex) {
            validationException.RestRequestValidationException(INCORRECT_AGE_ERROR, Constants.ERROR_404);
            throw validationException;
        }
        
        if (name == null) {
            validationException.RestRequestValidationException(NAME_ERROR, Constants.ERROR_404);
            throw validationException;
        } else if (!(age != null || !age.isNumeric())) {
            validationException.RestRequestValidationException(INCORRECT_AGE_ERROR, Constants.ERROR_404);
            throw validationException;
        }
    }
    
    public static void createTouristValidation (String name, String lastName, String email, String birthdate) {
        RestRequestValidationException validationException = new RestRequestValidationException();
        String duplicateCheck = lastname + email;
        
        try {
            Date dateBirthdate = Date.parse(birthdate);
        } catch (Exception ex) {
            validationException.RestRequestValidationException(INCORRECT_INPUD_DATE_ERROR, Constants.CONFLICT_400);
            throw validationException;
        }
        
        if (name == null || lastName == null || email == null || birthdate == null) {
            validationException.RestRequestValidationException(INCORRECT_INPUD_DATA_ERROR, Constants.CONFLICT_400);
            throw validationException;
        } else if (TouristService.isDuplicate(duplicateCheck)) {
            validationException.RestRequestValidationException(Constants.FOUND_DUPLICATE, Constants.CONFLICT_409);
            throw validationException;
        }
    }
}