({
	myAction : function(component,event,helper) {
		// get component attribute
		// component.get('v.listOfNames');
		/*var button =  event.getSource();
		component.get('v.listOfNames');
		button.set('v.label', 'Dont Click Me!!');*/
		helper.helperMethod(component,event);
	},

	myAction2 : function(component,event,helper){

	}
})