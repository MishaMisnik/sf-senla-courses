({    
    updateData : function (cmp, event, helper) {
        helper.getTrips(cmp).then(function(result) {
            if (result.length) {
                let items = [];
                let lastId;
                
                result.forEach(function(value) {
                    let item = { 
                        'label' : value.Name,
                        'value' : value.Id,
                        'Latitude' : value.Departure_Space_Point__r.Latitude__c, 
                        'Longitude' : value.Departure_Space_Point__r.Longitude__c
                    };
                    items.push(item);
                });
                
                cmp.set('v.trips', items); 
                cmp.set('v.isTripSelected', true);
                cmp.set('v.selectedTripId', result[0].Id);
                
                const button = cmp.find('submitButton');
                button.set('v.variant', 'brand');
                button.set('v.disabled', 'false');
                button.set('v.title', $A.get('$Label.c.NoSeats'));
                
                cmp.set('v.mapMarkers', [ {
                    location: {
                        Latitude : result[0].Departure_Space_Point__r.Latitude__c,
                        Longitude : result[0].Departure_Space_Point__r.Longitude__c
                    }
                }]);
                cmp.set('v.selectedTripId', result[0].Id);
                helper.createImagesList(cmp, cmp.get('v.selectedTripId'));
                
                cmp.set('v.showSpinner', false);
            } else {
                cmp.set('v.isTripSelected', false);
                cmp.set('v.showSpinner', false);
            }
        });
    },
    
    handleChange : function(cmp, event, helper) {
        if (event.getParam('cmpId') == 'lookupTourist') {
            cmp.set('v.showSpinner', true);
            cmp.set('v.trips', []);
            cmp.set('v.isTripSelected', false);
            cmp.set('v.tourist', []);
            
            cmp.find('recordLoader').reloadRecord(true);
        }
    },
    
    onChangeCombobox : function(cmp, event, helper) {
        let value = event.getParam('value');
                                                     
        cmp.set('v.selectedTripId', value);
        cmp.set('v.isTripSelected', true);
        
        helper.createImagesList(cmp, value);
    },
    
    onClickButton : function (cmp, event, helper) {
        helper.createFlight(cmp).then(function(result) {
            if (result) {
                helper.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.CreateComplete'));
                $A.get('e.force:refreshView').fire();
            } else {
                helper.showToast($A.get('$Label.c.Error'), $A.get('$Label.c.CreateFlightsError'));
            }
        });
    }
})