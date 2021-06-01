@IsTest
public class SpacePointManagerUnitTest {
    @TestSetup
    static void setup() {
        List<Space_Point__c> spacePoints = new List<Space_Point__c>{
            new Space_Point__c(Name = '#1', Country__c = 'USA', City__c = 'Boston', Latitude__c = 42.21, Longitude__c = 71.03),
            new Space_Point__c(Name = '#2', Country__c = 'United Kingdom', City__c = 'London', Latitude__c = 51.60, Longitude__c = 0.04),
            new Space_Point__c(Name = '#3', Country__c = 'South Korea', City__c = 'Seoul', Latitude__c = 37.32, Longitude__c = 37.19)   
        };
        insert spacePoints;
    } 
    
    @IsTest
    public static void testGetAll() {
        List<Space_Point__c> spacePoints = UnitTestFactory.getSpacePoints();
        Map<Id, Space_Point__c> allSpacePoints = SpacePointManager.getAll();
        
        System.assertEquals(3, allSpacePoints.size());
        System.assertEquals(spacePoints[0].Id, allSpacePoints.get(spacePoints[0].Id).Id);
    }
    
    @IsTest
    public static void testGetById() {
        List<Space_Point__c> spacePoints = UnitTestFactory.getSpacePoints();
        Map<Id, Space_Point__c> spacePointsById = SpacePointManager.getById(UnitTestFactory.getIds(spacePoints));
        
        System.assertEquals(3, spacePointsById.size());
        System.assertEquals(spacePoints[0].Id, spacePointsById.get(spacePoints[0].Id).Id);
        
        spacePointsById = SpacePointManager.getById(new Set<Id>());
        
        System.assertEquals(0, spacePointsById.size());
    }
}