({
	helperMethod : function(component,event) {
		var button =  event.getSource();
		component.get('v.listOfNames');
		button.set('v.label', 'Dont Click Me!!');
		button.set('v.disabled', 'true');
		// button.set('v.onclick', '{!c.myAction2}')
	}
})