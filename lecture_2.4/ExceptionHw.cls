public class ExceptionsPlayground {
    private static final String ERROR_INCOMING_DATA = 'Incoming data is empty';
    
    public class CustomException extends Exception{}
    
    public static void generateCustomException() {
        throw new CustomException(ERROR_INCOMING_DATA);    
    } 
    
    public static void generateRegularException() {
        integer i = 1 / 0;
    } 
    
    public static void handleExceptions() {
        try {
            generateCustomException();
            generateRegularException();
        } catch(CustomException ex) {
            System.debug(ex.getMessage());
        } catch(Exception ex) {
            System.debug(ex.getMessage());
        } finally {
            System.debug('Final');
        }
    } 
}