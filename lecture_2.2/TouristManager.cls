public class TouristManager {

    public static List<Tourist__c> getByName(String name){
        if(String.isBlank(name)){
            return new List<Tourist__c>();
        }
        
        return [
            SELECT Name, Age__c
            From Tourist__c
            Where name like :('%' + name + '%')
        ];
    }
    
    public static List<Tourist__c> getByAge(List<Integer> Ages){
        for(integer age : Ages){
            if(age == null){
                return new List<Tourist__c>();
            }
        }
        
        return [
            SELECT Name, Age__c
            From Tourist__c
            Where Age__c IN :Ages
        ];
    }
    
    public static List<Tourist__c> getByDateStart(){
        
        return [
            SELECT Name, Age__c
            From Tourist__c
            Where id IN (SELECT Tourist__c FROM Flight__c Where Trip__r.Start_Date__c >= 2020-01-01 and Trip__r.Start_Date__c <= 2021-01-01)
        ];
    }
   
    public static List<Tourist__c> getWithFlights(){

        return [
            SELECT Name, age__c, (SELECT Trip__r.Start_Date__c, Trip__r.Name FROM Flights__r)
            From Tourist__c
        ];
    }
    
    public static List<Tourist__c> getCountFlights(){

        return [
            SELECT Name, age__c
            From Tourist__c
            Where Upcoming_Flight_Count__c = 0
        ];
    }
}