({
	sendEmail : function(cmp) {
		let result = new Promise($A.getCallback( function (resolve, reject) {
            const email = cmp.get('c.sendEmailWithLink');
            
            email.setParams({
                'touristEmail' : cmp.get('v.email'),
                'urlLink' : ($A.get('$Label.c.CommunityURL') + '/s/tourist-assignment?recordId=' + cmp.get('v.recordId'))
            });
            
            email.setCallback(this, function(res) {
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
            
            $A.enqueueAction(email);    
        }));
        
        return result;
	},
    
    showToast : function(type, msg) {
        let toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            title: type,
            type: type,
            message: msg,
            duration: 5000
        });
        toastEvent.fire();
    },
})