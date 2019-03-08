({
	getContactsOnInit : function(component, event, helper) {
		debugger;
		// Creating an action to invoke server-side method
		var action = component.get("c.getCompanyRec");
		action.setParam('acc_name', component.get('v.cmpany_name'));
		action.setCallback(this, function(response) {
			debugger;
			console.log(response);
			component.set('v.contact_list', response.getReturnValue());
		});

		$A.enqueueAction(action);
	}
})