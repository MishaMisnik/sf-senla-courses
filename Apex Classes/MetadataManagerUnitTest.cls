@IsTest
public class MetadataManagerUnitTest {
    @IsTest
    public static void testGetAllMetadataEmails() {
        List<String> metaDataEmails = MetadataManager.getAllMetadataEmails();
        
        System.assertEquals(1, metaDataEmails.size());
        System.assertEquals('misnik22014@gmail.com', metaDataEmails[0]);
    }
}