public with sharing class AccountToLeadConveterController implements Database.Batchable<SObject> {
	private Map<String, String> mapOfAccountToLeadFields;
	private Map<String, String> mapOfAccountToLeadCustomFields;
	private Map<String, String> mapOfContactToLeadFields;
	private Map<String, String> mapOfContactToLeadCustomFields;
	private String accQuery;
	private String[] accIds =new String[] {'00128000018Z8rp', '0012800001EaZCF', '0012800000ZXEPs', '0012800001I5OPt'};
	private String accWhereCondition = 'id in: accIds';
    private String accid = '0012800001WQdU2';
    private Account acc = new Account();
	private String conQuery;
	
	
	
	
	
	public AccountToLeadConveterController() {
		this.acc = [Select id, Name from Account where id = '0012800001WQdU2' LIMIT 1];
		/*//Create map of standard account fields
		mapOfAccountToLeadFields =  new Map<String, String>{'Name'=>'Company', 'AnnualRevenue'=>'AnnualRevenue', 'BillingStreet' => 'Street', 
															'BillingState' => 'State', 'BillingCity' => 'City', 'BillingCountry' => 'Country',
															'BillingPostalCode' => 'PostalCode', 'Industry'=>'Industry'};
		
		mapOfAccountToLeadCustomFields = new Map<String, String>();
		//Create a map of standard contact fields
		mapOfContactToLeadFields = new Map<String, String>{'Salutation' => 'Salutation', 'FirstName'=>'FirstName', 'LastName'=>'LastName', 'Email' => 'Email'};
		mapOfContactToLeadCustomFields = new Map<String, String>();
		//Get the mapping from custom settings
		Map<String,ConvertToLeadFieldMapping__c> mapOfAllCustomFields = ConvertToLeadFieldMapping__c.getAll();
		for (String fieldKey: mapOfAllCustomFields.keySet()){
			ConvertToLeadFieldMapping__c currSetting = mapOfAllCustomFields.get(fieldKey);
			if (currSetting.Source_Object_Type__c.equalsIgnoreCase('Account')){
				mapOfAccountToLeadCustomFields.put(fieldKey, currSetting.Lead_Field_api__c);
			} else if(currSetting.Source_Object_Type__c.equalsIgnoreCase('Contact')){
				mapOfContactToLeadCustomFields.put(fieldKey, currSetting.Lead_Field_api__c);
			}
		} 
		
		//Build query on account object for all fields
		Set<String> allAccfields = new Set<String>(mapOfAccountToLeadFields.keySet());
		//Add custom fields if present
		if (mapOfAccountToLeadCustomFields!=null && !mapOfAccountToLeadCustomFields.isEmpty())
			allAccfields.addAll(mapOfAccountToLeadCustomFields.keySet());
		accQuery = buildQueryWithFields(allAccfields);
		System.debug('Acc_query: '+ accQuery);
		
		//Build query on contact object for all fields
		Set<String> allConfields = new Set<String>(mapOfContactToLeadFields.keySet());
		//Add custom fields if present
		if (mapOfContactToLeadCustomFields!=null && !mapOfContactToLeadCustomFields.isEmpty())
			allConfields.addAll(mapOfContactToLeadCustomFields.keySet());
		conQuery = buildQueryWithFields(allConfields);
		System.debug('Con_query: '+ conQuery);*/
	}
    
	public Database.QueryLocator start(Database.BatchableContext BC) {
		/*String mainBatchQuery = accQuery+' From Account ';
		if (String.isNotEmpty(accWhereCondition)){
			mainBatchQuery+='where ' + accWhereCondition;	
		}
		
		System.debug('Acc_query: '+ mainBatchQuery);	
		return Database.getQueryLocator(mainBatchQuery);*/
        String query = 'Select id, Name from Account';
        return Database.getQueryLocator(query);
	}
	
	public void execute(Database.BatchableContext BC, list<Account> accsInScope){
        try{
            for(Account acc:accsInScope){
                if (acc.name.containsIgnoreCase('test')){
                    Integer i = 1/0;
                }
            }
        } catch(Exception e) {
            String name =  acc.Name;
            name+='Exception';
            acc.Name = name;
         	update acc;
            System.debug('Exception Caught');
        }
		/*List<Lead> leadsToBeInserted = new List<Lead>();
		//Collect ids of all the accounts in the 
		
		//Get all contacts related to accounts in current scope
		String currConQuery = conQuery+' ,accountId'+' From Contact';
		currConQuery +=' WHERE AccountId in :accsInScope';
		
		List<Contact> allCons = Database.query(currConQuery);
		
		
		//Create a map of all Account and there contacts
		Map<Id, List<Contact>> mapOfAccsAndCons = new Map<Id, List<Contact>>();
		for (Contact c:allCons){
			if (!mapOfAccsAndCons.containsKey(c.AccountId))
				mapOfAccsAndCons.put(c.AccountId, new List<Contact>());
			
			mapOfAccsAndCons.get(c.AccountId).add(c);
		}
		
		for (Account acc:accsInScope){
			Lead finalLead = new Lead();
    	
			//Copy Account standard fields
			finalLead = (Lead) copyFieldValues(acc, finalLead, mapOfAccountToLeadFields);
			
			//Copy all Account custom fields
			finalLead = (Lead) copyFieldValues(acc, finalLead, mapOfAccountToLeadCustomFields);
			List<Contact> linkedCons = mapOfAccsAndCons.get(acc.id);
			Contact mainCon = null;
			if (linkedCons != null && linkedCons.size()>0){
				mainCon = linkedCons.get(0);
				
				//Copy Contact standard fields
				finalLead = (Lead) copyFieldValues(mainCon, finalLead, mapOfContactToLeadFields);
				
				//Copy all Contact custom fields
				finalLead = (Lead) copyFieldValues(mainCon, finalLead, mapOfContactToLeadCustomFields);
				
				leadsToBeInserted.add(finalLead);
			}
			
		}
		
		if (leadsToBeInserted!=null && leadsToBeInserted.size()>0)
			insert leadsToBeInserted;*/
	}
	
	public void finish(Database.BatchableContext BC){
        String name =  acc.Name;
        name+='Finish';
        acc.Name = name;
        update acc;
        System.debug('In finish method');
        
    }
	
    
    //Method to copy the field values of one SObject into the fields of another SObject with the help of given field Map.
    public SObject copyFieldValues(SObject sourceObj, SObject destinationObj, Map<String, String> fieldMap){
    	if (fieldMap!=null){
	    	for (String sourceField:fieldMap.keySet()){
	    		try {
	    			if (sourceObj!=null && destinationObj!=null && sourceObj.get(sourceField) != null)
	    				destinationObj.put(fieldMap.get(sourceField), sourceObj.get(sourceField));
	    		}
	    		
	    		catch (SObjectException e){
	    			System.debug('Field_not_exist_error: '+ sourceField +','+fieldMap.get(sourceField));
	    			System.debug('Message: '+ e.getMessage());
	    			continue;
	    		}
	    	}
    	}
    	return destinationObj;
    }
    
    //Method to build Query with the given set of fields. This method does not add any object type or where condition.
    public String buildQueryWithFields(Set<String> fieldSet){
    	String query = 'Select ';
    	List<String> strFields = new List<String>(fieldSet);
		for (Integer i=0; i < strFields.size(); i++){
			if (i!=strFields.size()-1){
				query+=strFields[i];
				query+=',';
			} else {
				query+=strFields[i];
			}
				
		}
		return query;
    }
}