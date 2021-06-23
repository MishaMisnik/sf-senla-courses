({
	getTrips : function(cmp) {
        let result = new Promise($A.getCallback( function (resolve, reject) {
            const trip = cmp.get('c.getTrips');
            
            trip.setParams({
                'tourist' : cmp.get('v.tourist')
            });
            
            trip.setCallback(this, function(res) {
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
            
            $A.enqueueAction(trip);    
        }));
        return result;
    },
    
    getTourist : function(cmp) {
        let result = new Promise($A.getCallback( function (resolve, reject) {
            const tourist = cmp.get('c.getTourist');
            
            tourist.setParams({
                'touristId' : cmp.get('v.selectedTouristId')
            });
            
            tourist.setCallback(this, function(res) {
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
            
            $A.enqueueAction(tourist);    
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
    
    showToast : function(type, mes) {
        let toastEvent = $A.get('e.force:showToast');
        
        toastEvent.setParams({
            title: type,
            type: type,
            message: mes
        });
        
        toastEvent.fire();
    }
})