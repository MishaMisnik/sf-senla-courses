public class ExceptionHw {
    public class CustomException extends Exception{}
    
    public integer first(integer a, integer b) {
		Integer i;		
        
        try {
            i = a / b;
            if (i < 2) {
                throw new CustomException('your result is too small');    
            }
        } catch(CustomException e) {
            System.debug(e.getMessage());
        }
        
        return i;
    } 
    
    public integer second(integer a, integer b) {
        Integer i;
        
        try {
            i = a / b;
        } catch(Exception ex) {
            System.debug(ex.getMessage());
        }
        return i;
        
    } 
    
    public void third(integer a, integer b) {
        integer i;

        try {
            i = second(a, a) / first(b, b);
        } catch(Exception ex) {
            System.debug(ex.getMessage());
        } finally {
            System.debug('Final');
            System.debug('Result:' + i);
        }
    } 
}