@IsTest
public class MetadataManagerUnitTest {
    @IsTest
    public static void testGetAllMetadataEmails() {
        List<String> metaDataEmails = MetadataManager.getAllMetadataEmails();
        
        System.assertEquals(1, metaDataEmails.size());
    }
}