public class RestRequestValidationException extends Exception {
    private String errorMes;
    private Integer statusCode;
    
    public void RestRequestValidationException(String errorMes, Integer statusCode) {
        this.errorMes = errorMes;
        this.statusCode = statusCode;
    }
    
    public override String getMessage() {
        return errorMes;
    }
    
    public Integer getStatusCode() {
        return statusCode;
    }
}