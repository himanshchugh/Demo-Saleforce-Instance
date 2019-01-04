public class AccountHandler implements ITrigger {
	
    private set<Id> idsInUse;
    private List<String> accDeleted;
    private List<Contact> defaultContacts;
    
    
    public AccountHandler() {
        idsInUse = new Set<Id>();
        accDeleted = new List<String>();
        defaultContacts = new List<Contact>();
    }
    
    /**
	 * bulkBefore
	 *
	 * This method is called prior to execution of a BEFORE trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
    public void bulkBefore(){
        // Here we will filter the account which are in use.
        // Use the gateway to fetch the accounts already in use.
        if (Trigger.isDelete)
        {
            idsInUse = AccountGateway.findAccountIdsInUse(Trigger.oldMap.keySet());
        }
    }
	
	/**
	 * bulkAfter
	 *
	 * This method is called prior to execution of an AFTER trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
    public void bulkAfter() {
        
    }
	
	/**
	 * beforeInsert
	 *
	 * This method is called iteratively for each record to be inserted during a BEFORE
	 * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
	 */
    public void beforeInsert(SObject so) {
        
    }
	
	/**
	 * beforeUpdate
	 *
	 * This method is called iteratively for each record to be updated during a BEFORE
	 * trigger.
	 */
    public void beforeUpdate(SObject oldSo, SObject so) {
        Account newAcc = (Account) so;
        Account oldAcc = (Account) oldSo;
        //Verifying the account was updated by Approval Process
        if (oldAcc.Type == 'Pending' && newAcc.Type == 'Prospect') {
            so.addError('Can\'t Reject');
        }
    }

	/**
	 * beforeDelete
	 *
	 * This method is called iteratively for each record to be deleted during a BEFORE
	 * trigger.
	 */
    public void beforeDelete(SObject so) {
        //If the account being deleted is in the list of accounts which are in use
        Account currAcc = (Account) so;
        
        if (idsInUse.contains(currAcc.id))
        {
        }
        //else
        //delete the account
    }

	/**
	 * afterInsert
	 *
	 * This method is called iteratively for each record inserted during an AFTER
	 * trigger. Always put field validation in the 'After' methods in case another trigger
	 * has modified any values. The record is 'read only' by this point.
	 */
    public void afterInsert(SObject so) {
        //Create a default contact for the given account
        Account currAcc = (Account) so;
        Contact defaultContact = new Contact(FirstName = 'Default', LastName = 'Contact', AccountId = currAcc.Id, Phone = currAcc.Phone);
        defaultContacts.add(defaultContact);
        //copy the accounts phone number to the contact
    }

	/**
	 * afterUpdate
	 *
	 * This method is called iteratively for each record updated during an AFTER
	 * trigger.
	 */
    public void afterUpdate(SObject oldSo, SObject so){
        
    }

	/**
	 * afterDelete
	 *
	 * This method is called iteratively for each record deleted during an AFTER
	 * trigger.
	 */
    public void afterDelete(SObject so){
        
    }

	/**
	 * andFinally
	 *
	 * This method is called once all records have been processed by the trigger. Use this 
	 * method to accomplish any final operations such as creation or updates of other records.
	 */
    public void andFinally(){
        if (Trigger.isDelete)
        {
        	System.debug('Deleted Accounts' + accDeleted);
        
        }
        else if (Trigger.isInsert)
        {
            insert defaultContacts;
        }
    }
}