@IsTest
public class TestMockHttpResponce implements HttpCalloutMock {
	
    public HTTPResponse respond(HTTPRequest req) { 
        HttpResponse response = new HttpResponse();
        
        return response; 
    }
}