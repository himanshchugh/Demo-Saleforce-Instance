({
	createItem  : function(component, newItem) {
		// console.log("New Item:"+component.get("v.newItem"));
	    //Creating controller action to push new item to database.
	    var action = component.get("c.saveItem");
	    action.setParam('item', newItem);
	    action.setCallback(this, function(response) {
	        //If the save to database was a success
	        if (response.getState() == 'SUCCESS'){
	            var allItems =component.get("v.items");
	            allItems.push(newItem);
	            //Setting new Item back to default values
	            newItem = {'sobjectType': 'Camping_Item__c',
	                        'Name':'New Item',
	                        'Price__c':0,
	                        'Quantity__c':0,
	                        'Packed__c':false};
	            // console.log("Default Item:" + JSON.stringify(newItem));

	            component.set("v.newItem", newItem);
	            component.set("v.items",allItems);
	        }
	    });
		$A.enqueueAction(action, true);
	}
})