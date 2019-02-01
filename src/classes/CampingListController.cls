public with sharing class CampingListController {
	public CampingListController() {
		
	}

	@AuraEnabled
	public static List<Camping_Item__c> getItems() {
		List<Camping_Item__c> campItems = [Select id, Name, Price__c, Quantity__c, Packed__c from Camping_Item__c ORDER BY Name];
        return campItems;
	}

	@AuraEnabled
	public static void saveItem(Camping_Item__c newItem) {
		upsert newItem;
	}
}