({
    init : function (cmp, event, helper) {
        cmp.set('v.spinner', true);
        cmp.set('v.columns', helper.getColumnDefinitions());
        
        helper.getTrip(cmp).then(function(result) {
            cmp.set('v.tripRecord', result);
            cmp.set('v.startDate', cmp.get('v.tripRecord.Start_Date__c'));
            
            helper.getData(cmp, 0).then(function(result) {
                cmp.set('v.data', result);
                
                helper.getCountSeats(cmp).then(function(result) {
                    cmp.set('v.countRemaining', result);
                    
                    const today = $A.localizationService.formatDate(new Date(), 'YYYY-MM-DD');
                    const tripStartDate = cmp.get('v.tripRecord.Start_Date__c');
                    const counRemSeats = cmp.get('v.countRemaining');
                    
                    if (tripStartDate < today || counRemSeats == 0) {
                        cmp.set('v.isActive', false);
                    }
                    cmp.set('v.spinner', false);
                });
                
                if (cmp.get('v.data').length < 10) {
                    cmp.set('v.enableInfiniteLoading', false);
                }
            });
        });
    },
    
    updateSelectedText : function (cmp, event) {
        const selectedRows = event.getParam('selectedRows');
        cmp.set('v.selectedRowsCount', selectedRows.length);
    },
    
    loadMoreData : function(cmp, event, helper) {
        cmp.set('v.spinner', true);
        let dataLenght = cmp.get('v.data').length;
        
        helper.getMoreData(cmp, event, dataLenght).then(function(result){
            if (cmp.get('v.data').length >= cmp.get('v.totalNumberOfRows')) {
                cmp.set('v.enableInfiniteLoading', false);
            }else {
                let data = cmp.get('v.data');
                cmp.set('v.data', data.concat(result));
            }
            cmp.set('v.spinner', false);
        });
    },
    
    onClick : function (cmp, event, helper) {
        cmp.set('v.spinner', true);
        const remainingSeats = cmp.get('v.countRemaining');        
        const records = cmp.find('touristsData').getSelectedRows(); 
        
        if (records.length > remainingSeats) {
            helper.showToast($A.get('$Label.c.Error'), $A.get('$Label.c.CreateFlightsError'));
            cmp.set('v.spinner', false);
        } else {
            if (records == 0) {
                helper.showToast($A.get('$Label.c.Error'), $A.get('$Label.c.NothingSelected'));
                cmp.set('v.spinner', false);
            } else {
                cmp.set('v.validation', true);
                $A.get('e.force:refreshView').fire();
            }
        }
    },
    
    yesOnClick : function (cmp, event, helper) {
        
        helper.createFlights(cmp).then(function(result) {
            if (result) {
                helper.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.CreateComplete'));
                cmp.set('v.validation', false);
                
                const reInit = cmp.get('c.init');
                cmp.set('v.spinner', false);
                $A.enqueueAction(reInit);
            } else {
                cohelper.showToast($A.get('$Label.c.Error'), $A.get('$Label.c.CreateFlightsError'));
                cmp.set('v.validation', false);
                cmp.set('v.spinner', false);
            }
            
            cmp.set('v.spinner', false);
        	$A.get('e.force:refreshView').fire();
        });
    },
    
    closeOnClick : function (cmp, event, helper) {
        cmp.set('v.validation', false);
        cmp.set('v.spinner', false);
    }
});