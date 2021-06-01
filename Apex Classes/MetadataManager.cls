public class MetadataManager {
	
    public static List<String> getAllMetadataEmails () {
        List<String> emails = new List<String>();
        List<Data__mdt> metaData = [
        	SELECT Email__c
            FROM Data__mdt
        ];
        
        for (Data__mdt data : metaData){
  			emails.add(data.Email__c);
		}

        return emails;
    }
}