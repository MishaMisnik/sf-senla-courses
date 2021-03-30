public class ExceptionsPlayground {
    public static final String ERROR_INCOMING_DATA = 'Incoming data is empty';
    
    public class CustomException extends Exception{}
    
    public static void generateCustomException(List<Tourist__c> newTourists) {	
    
        try {
            if (newTourists == null  || newTourists.isEmpty()) {
                throw new CustomException(ERROR_INCOMING_DATA);    
            }else{
                insert newTourists;
            }
        } catch(CustomException e) {
            System.debug(e.getMessage());
        }
    } 
    
    public static void generateRegularException(List<Tourist__c> newTourists) {
                
        try {
            insert newTourists;
        } catch(CustomException e) {
            System.debug(e.getMessage());
        }
    } 
    
    public static void handleExceptions(List<Tourist__c> newTourists) {

        try {
            generateCustomException(newTourists);
            generateRegularException(newTourists);
        } catch(Exception ex) {
            System.debug(ex.getMessage());
        } finally {
            System.debug('Final');
        }
    } 
}