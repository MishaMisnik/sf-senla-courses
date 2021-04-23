public class TouristRestManager {
    
    public static List<List<Tourist__c>> getByNameAndAge(String name, Integer age) {
        
        if (age == null) {
            return [
                FIND :name IN Name Fields
                RETURNING Tourist__c(Name, Age__c)
            ];
        }
        
        return [
            FIND :name IN Name Fields
            RETURNING Tourist__c(Name, Age__c WHERE Age__c = :age)
        ];
    }
}