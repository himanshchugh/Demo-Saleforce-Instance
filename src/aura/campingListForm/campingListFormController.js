({
	clickCreateItem : function(component, event, helper) {
		debugger;
		//Get the form values and check if all the 
		var allFieldsValid = component.find("itemForm").reduce(function (validStatus, currentComp){
			currentComp.showHelpMessageIfInvalid();
			console.log(currentComp.get("v.name"));
			return validStatus && currentComp.get("v.validity").valid;

		}, true);

		if(allFieldsValid){
            //Call helper mehod to fire event.
            helper.createItem(component, component.get('v.newItem'));
		}
	}
})