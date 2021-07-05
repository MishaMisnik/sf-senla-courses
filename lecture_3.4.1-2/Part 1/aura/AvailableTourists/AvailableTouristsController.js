({
    dataLoader : function (cmp, event, helper) {
        cmp.set('v.showSpinner', true);
        cmp.set('v.columns', helper.getColumnDefinitions());
        
        helper.loadTouristsByMinAgeAndDate(cmp, 0).then(function(result) {
            cmp.set('v.tourists', result);
            const today = $A.localizationService.formatDate(new Date(), 'YYYY-MM-DD');
            const tripStartDate = cmp.get('v.tripRecord.Start_Date__c');
            const counRemSeats = cmp.get('v.tripRecord.Remaining_Seats__c');
            
            if (tripStartDate < today) {
                cmp.set('v.isActive', false);
            }
            
            if (counRemSeats <= 0) {                
                const button = cmp.find('createButton');
                button.set('v.variant', 'destructive-text');
                button.set('v.disabled', 'true');
                button.set('v.title', $A.get('$Label.c.NoSeats'));
            }
            
            cmp.set('v.showSpinner', false);
            
            if (cmp.get('v.tourists').length < 10) {
                cmp.set('v.enableInfiniteLoading', false);
            }
        });
    },
    
    loadMoreTourists : function(cmp, event, helper) {
        cmp.set('v.showSpinner', true);
        let dataLenght = cmp.get('v.tourists').length;
        
        helper.loadTouristsByMinAgeAndDate(cmp, dataLenght).then(function(result){
            if (cmp.get('v.tourists').length >= cmp.get('v.totalNumberOfRows')) {
                cmp.set('v.enableInfiniteLoading', false);
            } else {
                let data = cmp.get('v.tourists');
                cmp.set('v.tourists', data.concat(result));
            }
            cmp.set('v.showSpinner', false);
        });
    },
    
    onClick : function (cmp, event, helper) {
        cmp.set('v.showSpinner', true);
        const remainingSeats = cmp.get('v.countRemaining');        
        const records = cmp.find('touristsData').getSelectedRows(); 
        
        if (records.length > remainingSeats) {
            helper.showToast($A.get('$Label.c.Error'), $A.get('$Label.c.CreateFlightsError'));
            cmp.set('v.showSpinner', false);
        } else {
            if (records == 0) {
                helper.showToast($A.get('$Label.c.Error'), $A.get('$Label.c.NothingSelected'));
                cmp.set('v.showSpinner', false);
            } else {
                cmp.set('v.showValidation', true);
                $A.get('e.force:refreshView').fire();
            }
        }
    },
    
    inSubmit : function (cmp, event, helper) {
        helper.createFlights(cmp).then(function(result) {
            if (result) {
                helper.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.CreateComplete'));
                cmp.set('v.showValidation', false);
                
                const reInit = cmp.get('c.dataLoader');
                $A.enqueueAction(reInit);
            } else {
                helper.showToast($A.get('$Label.c.Error'), $A.get('$Label.c.CreateFlightsError'));
                cmp.set('v.showValidation', false);
            }
            
            cmp.set('v.showSpinner', false);
            $A.get('e.force:refreshView').fire();
        });
    }
});
