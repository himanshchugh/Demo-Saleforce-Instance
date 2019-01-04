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
			console.log("New Item:"+component.get("v.newItem"));
			var allItems =component.get("v.items");
			allItems.push(newItem);
			//Setting new Item back to default values
			newItem = {'sobjectType': 'Camping_Item__c',
						'Name':'New Item',
						'Price__c':0,
						'Quantity__c':0,
						'Packed__c':false};
			console.log("Default Item:" + JSON.stringify(newItem));
			component.set("v.newItem", newItem);
			component.set("v.items",allItems);
		}
	}
})