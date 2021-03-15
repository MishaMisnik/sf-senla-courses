public class TouristManager {

    public static List<Tourist__c> getByName(String name) {
        if (String.isBlank(name)) {
            return new List<Tourist__c>();
        }
        
        return [
            SELECT Name, Age__c
            FROM Tourist__c
            WHERE name LIKE :('%' + name + '%')
        ];
    }
    
    public static List<Tourist__c> getByAge(Set<Integer> ages) {
        for (integer age : Ages ) {
            if (age == null) {
                return new List<Tourist__c>();
            }
        }
        
        return [
            SELECT Name, Age__c
            FROM Tourist__c
            WHERE Age__c IN :Ages
        ];
    }
    
    public static List<Tourist__c> getByDateStart(Date startDate) {
        Date firstDate = startDate.addYears(-1);
        Date secondDate = startDate.addYears(1);
        
        return [
            SELECT Name, Age__c
            FROM Tourist__c
            WHERE id IN (SELECT Tourist__c FROM Flight__c WHERE Trip__r.Start_Date__c >= :firstDate AND Trip__r.Start_Date__c <= :secondDate)
        ];
    }
   
    public static List<Tourist__c> getWithFlights() {

        return [
            SELECT Name, age__c, 
            	(SELECT Trip__r.Start_Date__c, Trip__r.Name FROM Flights__r)
            FROM Tourist__c
        ];
    }
    
    public static List<Tourist__c> getCountFlights() {

        return [
            SELECT Name, age__c
            FROM Tourist__c
            WHERE Upcoming_Flight_Count__c = 0
        ];
    }
}