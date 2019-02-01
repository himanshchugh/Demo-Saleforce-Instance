({
	clickCreateItem : function(component, event, helper) {
		//Get the form values and check if all the 
		var allFieldsValid = component.find("itemForm").reduce(function (validStatus, currentComp){
			currentComp.showHelpMessageIfInvalid();
			console.log(currentComp.get("v.name"));
			return validStatus && currentComp.get("v.validity").valid;

		}, true);

		if(allFieldsValid){
            //Get new item using the new expense attribute
            var newItem = component.get("v.newItem");
            //Calling the helper method to save item to database.
			helper.createItem(component, newItem);
		}
	},

	doInit : function(component) {
		//Initializing component by loading up existing records from the database.
		//Creating controller action
        debugger;
		var get_action = component.get("c.getItems");
		get_action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                component.set('v.items', response.getReturnValue());
            }
		});

        //Adding the action to the queue
        $A.enqueueAction(get_action,true);

	}
})