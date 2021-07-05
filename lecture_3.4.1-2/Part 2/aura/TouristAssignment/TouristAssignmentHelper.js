({
    getTrips : function(cmp) {
        let result = new Promise($A.getCallback( function (resolve, reject) {
            const trips = cmp.get('c.getTrips');
            
            trips.setParams({
                'tourist' : cmp.get('v.tourist')
            });
            
            trips.setCallback(this, function(res) {
                const state = res.getState();
                const value = res.getReturnValue();
                if (state == 'SUCCESS') {
                    resolve(value); 
                }
                if (state == 'ERROR') {
                    console.log('ERROR', res.getError());
                    reject( res.getError() );
                }
            });
            
            $A.enqueueAction(trips);    
        }));
        
        return result;
    },
    
    createFlight : function(cmp) {
        let result = new Promise($A.getCallback( function (resolve, reject) {
            const createFlight = cmp.get('c.createFlgiht');
            
            createFlight.setParams({
                'touristId' : cmp.get('v.selectedTouristId'),
                'tripId' : cmp.get('v.selectedTripId')
            });
            
            createFlight.setCallback(this, function(res) {
                const state = res.getState();
                const value = res.getReturnValue();
                
                if (state == 'SUCCESS') {
                    resolve(value); 
                }
                if (state == 'ERROR') {
                    console.log('ERROR', res.getError());
                    reject(res.getError());
                }
            });
            
            $A.enqueueAction(createFlight);
        }));
        
        return result;
    },
    
    showToast : function(type, msg) {
        let toastEvent = $A.get('e.force:showToast');
        
        toastEvent.setParams({
            title: type,
            type: type,
            message: msg
        });
        
        toastEvent.fire();
    },
    
    createImagesList : function (cmp, selectedTripId) {
        let numbers = ['first', 'second', 'third', 'fourth', 'fifth'];
        
        cmp.get('v.trips').forEach(function(record) {
            if (record.value == selectedTripId) {
                let finalList = [];
                
                cmp.set('v.mapMarkers', [ {
                    location: {
                        Latitude : record.Latitude,
                        Longitude : record.Longitude
                    }
                }]);
                
                numbers.forEach(function(number) {
                    const name = record.label.replace(/ /g,'');
                    const profUrl = $A.get('$Resource.' + number + name);
                    finalList.push(profUrl);
                });
                
                cmp.set('v.tripNames', finalList);
            }
        });
    }
})
