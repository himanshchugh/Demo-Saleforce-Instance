({
	createItem  : function(component, newItem) {
		// console.log("New Item:"+component.get("v.newItem"));
	    //Creating controller action to push new item to database.
	    var create_action = component.get('c.saveItem');
	    create_action.setParam('newItem', newItem);
	    create_action.setCallback(this, function(response) {
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
		$A.enqueueAction(create_action, true);
	}
})