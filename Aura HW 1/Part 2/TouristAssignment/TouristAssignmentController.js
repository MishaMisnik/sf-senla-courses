({    
    handleChange : function(cmp, event, helper) {
        if (event.getParam('cmpId') == 'lookupTourist') {
            cmp.set('v.showSpinner', true);
            cmp.set('v.trips', []);
            cmp.set('v.isTripSelected', false);
            cmp.set('v.tourist', []);
            
            helper.getTourist(cmp).then(function(result) {
                cmp.set('v.tourist', result);
                
                helper.getTrips(cmp).then(function(result) {
                    if (result.length == 0) {
                        cmp.set('v.isTripSelected', false);
                        cmp.set('v.showSpinner', false);
                    } else {
                        let items = [];
                        let lastId;
                        
                        result.forEach(function(value) {
                            let item = { 'label' : value.Name, 'value' : value.Id };
                            items.push(item);
                        });
                        
                        cmp.set('v.tripsList', result); 
                        cmp.set('v.trips', items); 
                        cmp.set('v.isTripSelected', true);
                        cmp.set('v.selectedTripId', result[0].Id);
                        
                        const button = cmp.find('submitButton');
                        button.set('v.variant', 'brand');
                        button.set('v.disabled', 'false');
                        button.set('v.title', $A.get('$Label.c.NoSeats'));
                        
                        cmp.set('v.showSpinner', false);
                        cmp.set('v.mapMarkers', [ {
                            location: {
                                Latitude : result[0].Departure_Space_Point__r.Latitude__c,
                                Longitude : result[0].Departure_Space_Point__r.Longitude__c
                            }
                        }]);
                    }
                });
            });
        }
    },
    
    onChangeCombobox : function(cmp, event, helper) {
        let value = event.getParam('value');
        cmp.set('v.selectedTripId', value);
        cmp.set('v.isTripSelected', true);
        
        let array = ['first', 'second', 'third', 'fourth', 'fifth'];
        
        cmp.get('v.tripsList').forEach(function(record) {
            if (record.Id == value) {
                let finalList = [];
                
                cmp.set('v.mapMarkers', [ {
                    location: {
                        Latitude : record.Departure_Space_Point__r.Latitude__c,
                        Longitude : record.Departure_Space_Point__r.Longitude__c
                    }
                }]);
                
                array.forEach(function(number) {
                    const name = record.Name.replace(/ /g,'');
                    const profUrl = $A.get('$Resource.' + number + name) ;
                    finalList.push(profUrl); 
                });
                
                cmp.set('v.tripNames', finalList);
            }
        });
    },
    
    onClickButton : function (cmp, event, helper) {
        helper.createFlight(cmp).then(function(result) {
            if (result) {
                helper.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.CreateComplete'));
                $A.get('e.force:refreshView').fire();
            } else {
                cohelper.showToast($A.get('$Label.c.Error'), $A.get('$Label.c.CreateFlightsError'));
            }
        });
    }
})