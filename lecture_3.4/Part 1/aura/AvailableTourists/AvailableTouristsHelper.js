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
    
    loadTouristsByMinAgeAndDate : function(cmp, offset) {
        let result = new Promise($A.getCallback( function (resolve, reject) {
            const tourists = cmp.get('c.getTourists');
            
            tourists.setParams({
                'limits' : cmp.get('v.initialRows'),
                'offset' : offset,
                'trip' : cmp.get('v.tripRecord')
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
    
    showToast : function(type, msg) {
        let toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            title: type,
            type: type,
            message: msg
        });
        toastEvent.fire();
    },
    
    createFlights : function(cmp) {
        let result = new Promise($A.getCallback( function (resolve, reject) {
            const createNewFlights = cmp.get('c.createFlights');
            
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