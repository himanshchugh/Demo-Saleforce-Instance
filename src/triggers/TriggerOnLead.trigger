trigger TriggerOnLead on Lead (after insert) {
	
    /*//For each newly inserted lead, gather a list of emails, to find the related contacts.
    //Create a map associating a lead with its email.
    List<String> listofNewLeadEmails = new List<String>();
    Map<String, Lead> mapOfEmailtoNewLead = new Map<String, Lead>();
   	for (Lead newLead : Trigger.New) {
        if (newLead.Email != null && newLead.Email != ''){
            
            listofNewLeadEmails.add(newLead.Email);
            mapOfEmailtoNewLead.put(newLead.Email,newLead);
        }
    }
    
    //From the gathered list of emails, get the details of the contacts having the same email.   
    List<Contact> consWithNewLeadEmails = [select Id, FirstName, LastName, AccountId,  Email from Contact where email IN :listofNewLeadEmails];
    List<Lead> leadsToUpdate = new List<Lead>();
    List<Database.LeadConvert> converters = new List<Database.LeadConvert>();
    //Now we have the list of shared contacts, we have to link the contact and the related account to the lead and then directly convert the lead.
    //By iterating over related Contacts rather than all Lead reduces the number of records to be processesed as only records needed are the one with related Contacts.
    if (consWithNewLeadEmails != null) {
        for (Contact relatedContact: consWithNewLeadEmails) {
            //Get the the lead with the same email.
            Lead relatedLead = mapOfEmailtoNewLead.get(relatedContact.Email);
            //Setting the number of days lead remained in the current status
            if (relatedLead.Last_Status_Change_Date__c != null){
                Lead leadToUpdate = new Lead(id = relatedLead.Id);
                if (relatedLead.Status == 'open') {
                    leadToUpdate.Days_Opened__c = relatedLead.Last_Status_Change_Date__c.daysBetween(Date.today());
                } else if (relatedLead.Status == 'Working') {
                    leadToUpdate.Days_Worked__c = relatedLead.Last_Status_Change_Date__c.daysBetween(Date.today());
                } /*else if (relatedLead.Status == 'Converted') {
                    relatedLead.Days_Closed_Converted__c = relatedLead.Last_Status_Change_Date__c.daysBetween(Date.today());
                } else if (relatedLead.Status == 'Unconverted') {
                    relatedLead.Days_Uncoverted_Closed__c = relatedLead.Last_Status_Change_Date__c.daysBetween(Date.today());
                }*/
           		/*leadsToUpdate.add(leadToUpdate);
            }
            //Lead Conversion
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(relatedLead.Id);
            lc.convertedStatus = 'Converted';
            lc.setContactId(relatedContact.Id);
            lc.setAccountId(relatedContact.AccountId);
            //lc.setDoNotCreateOpportunity(true);
           	//Database.ConvertLead(lc,true);
            converters.add(lc);
        }
        //Comminting the changes to the Lead before it is converted.
        update leadsToUpdate;
        Database.convertLead(converters);
    }*/
}