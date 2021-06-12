({
    getColumnDefinitions : function () {
        const columns = [
            {label: 'Tourist Name', fieldName: 'linkName', type: 'url', 
            typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            {label: 'Email', fieldName: 'Email__c', type: 'email', sortable: true},
            {label: 'Gender', fieldName: 'Gender__c', type: 'text', sortable:true}
        ];
        
        return columns;
    },
    
    getTrip : function(cmp) {
        let result = new Promise($A.getCallback( function (resolve, reject) {
            const trip = cmp.get('c.getTrip');
            trip.setParams({
                'tripId' : cmp.get('v.recordId')
            });
            
            trip.setCallback(this, function (res) {
                const state = res.getState();
                const value = res.getReturnValue();
                
                if (state === 'SUCCESS') {
                    resolve(value);
                }
                if (state == 'ERROR') {
                    console.log('ERROR', res.getError());
                    reject(res.getError());
                }
            });
            
            $A.enqueueAction(trip);
        }));
        
        return result;
    },
    
    getData : function(cmp, offset) {
        let result = new Promise($A.getCallback( function (resolve, reject) {
            const tourists = cmp.get('c.getTourists');
            tourists.setParams({
                'limits' : cmp.get('v.initialRows'),
                'offset' : offset,
                'minAge' : cmp.get('v.tripRecord.Minimal_Age__c'),
                'tripId' : cmp.get('v.recordId')
            });
            
            tourists.setCallback(this, function(res) {
                const state = res.getState();
                const value = res.getReturnValue();
                
                if (state == 'SUCCESS') {
                    value.forEach(function(value) {
                        value.Name = value.Name + ' ' + value.LastName__c;
                        value.linkName = '/' + value.Id;
                    });
                    resolve(value); 
                }
                if (state == 'ERROR') {
                    console.log('ERROR', res.getError());
                    reject( res.getError() );
                }
            });
            
            $A.enqueueAction(tourists);    
        }));
        return result;
    },
    
    getMoreData : function(cmp, event, offset) {
        let result = new Promise($A.getCallback( function (resolve, reject) {
            const newTourists = cmp.get('c.getTourists');
            
            newTourists.setParams({
                'limits': cmp.get('v.rowsToLoad'),
                'offset': offset,
                'minAge' : cmp.get('v.tripRecord.Minimal_Age__c')
            });
            
            newTourists.setCallback(this, function(res) {
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
            
            $A.enqueueAction(newTourists);
        }));
        return result;
    },
    
    getCountSeats : function(cmp) {
        let result = new Promise($A.getCallback( function (resolve, reject) {
            const countSeats = cmp.get('c.getCountSeats');
            
            countSeats.setParams({
                'tripId' : cmp.get('v.recordId')
            });
            
            countSeats.setCallback(this, function(res) {
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
            
            $A.enqueueAction(countSeats);
        }));
        
        return result;
    },
    
    showToast : function(type, mes) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: type,
            type: type,
            message: mes
        });
        toastEvent.fire();
    },
    
    createFlights : function(cmp) {
        let result = new Promise($A.getCallback( function (resolve, reject) {
            const createNewFlights = cmp.get('c.createFlgihts');
            
            createNewFlights.setParams({
                'tourists' : cmp.find('touristsData').getSelectedRows(),
                'trip' : cmp.get('v.tripRecord')
            });
            
            createNewFlights.setCallback(this, function(res) {
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
            
            $A.enqueueAction(createNewFlights);
        }));
        
        return result;
    }
});