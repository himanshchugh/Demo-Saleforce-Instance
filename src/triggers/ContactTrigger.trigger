trigger ContactTrigger on Contact (after update, after insert, before delete) {
    	Integer i = 1/0;
      
    List<Contact> contactsWithEmptyEmails = new List<Contact>(); 
    for (Contact c: Trigger.new)
    {
        if (c.Email == '')
            contactsWithEmptyEmails.add(c);
    }
    
    //List<Contact> con = [Select Id, Name, Email from Contact where email in :emails];
    System.debug('Contacts With Empty Emails : '+ contactsWithEmptyEmails ); //+ ' con ' + con);
}