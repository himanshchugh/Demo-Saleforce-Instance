({
	createItem : function(component, camp_item) {
		//Fire and event to the parent component to save the record
        var addItemEvnt = component.getEvent("addItem");
        addItemEvnt.setParams({ "item": camp_item });
        addItemEvnt.fire();

        //Setting new Item back to default values
        var newItem = {'sobjectType': 'Camping_Item__c',
                    'Name':'New Item',
                    'Price__c':0,
                    'Quantity__c':0,
                    'Packed__c':false};
        // console.log("Default Item:" + JSON.stringify(newItem));

        component.set("v.newItem", newItem);
	}
})