({
    loadDataForEmail : function(cmp, event, helper) {
        cmp.set('v.email', cmp.get('v.tourist.Email__c'));
        
        helper.sendEmail(cmp).then(function(result) {
            if (result) {
                helper.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.EmailSent'));
            } else {
                helper.showToast($A.get('$Label.c.Success'), $A.get('$Label.c.ErrorContactWithAdmin'));                
            }
        });
        $A.get('e.force:closeQuickAction').fire();
    }
})