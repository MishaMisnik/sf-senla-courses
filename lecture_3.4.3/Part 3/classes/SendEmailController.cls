public inherited sharing class SendEmailController {
    
    @AuraEnabled
    public static Boolean sendEmailWithLink(String touristEmail, String urlLink) {
        if (String.isBlank(touristEmail) || String.isBlank(urlLink)) return false;
        
        return TouristService.sendEmail(touristEmail, urlLink);
    } 

}