@IsTest
public class SpacePointManagerUnitTest {
    @IsTest
    public static void testGetAll() {
        List<Space_Point__c> spacePoints = new List<Space_Point__c>{
            new Space_Point__c(Name = '#1', Country__c = 'USA', City__c = 'Boston', Latitude__c = 42.21, Longitude__c = 71.03)
        };
        insert spacePoints;
        
        Map<Id, Space_Point__c> allSpacePoints = SpacePointManager.getAll();
        
        System.assertEquals(1, allSpacePoints.size());
    }
    
    @IsTest
    public static void testGetById() {
        List<Space_Point__c> spacePoints = new List<Space_Point__c>{
            new Space_Point__c(Name = '#1', Country__c = 'USA', City__c = 'Boston', Latitude__c = 42.21, Longitude__c = 71.03)
        };
            
        insert spacePoints;
        
        List<Space_Point__c> spacePoint = [
            SELECT Id
            FROM Space_Point__c
        ];
        Map<Id, Space_Point__c> spacePointsById = SpacePointManager.getById(UnitTestFactory.getId(spacePoint));
        
        System.assertEquals(1, spacePointsById.size());
        System.assert(spacePointsById.keySet().contains(spacePoint[0].Id));

        spacePointsById = SpacePointManager.getById(new Set<Id>());
        
        System.assertEquals(0, spacePointsById.size());
    }
}