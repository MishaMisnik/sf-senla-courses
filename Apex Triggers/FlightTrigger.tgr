trigger FlightTrigger on Flight__c (before insert) {
    
    switch on Trigger.operationType {
        when BEFORE_INSERT {            
            if (FlightTriggerHandler.onBeforeInsertIsFirstTime) {
                FlightTriggerHandler.onBeforeInsert(Trigger.new);
                FlightTriggerHandler.onBeforeInsertIsFirstTime = false;
            }
        }
    }
}