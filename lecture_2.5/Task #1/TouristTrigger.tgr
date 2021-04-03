trigger TouristTrigger on Tourist__c (after insert, after update) {
    
    switch on Trigger.operationType {
        when AFTER_INSERT {
            if (TouristTriggerHandler.onAfterInsertIsFirstTime) {
                TouristTriggerHandler.onAfterInsert(Trigger.new);
                TouristTriggerHandler.onAfterInsertIsFirstTime = false;
            }
        }
        
        when AFTER_UPDATE {
            if (TouristTriggerHandler.onAfterUpdateIsFirstTime) {
                TouristTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
                TouristTriggerHandler.onAfterUpdateIsFirstTime = false;
            }
        }
    }
}