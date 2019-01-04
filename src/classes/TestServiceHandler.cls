global class TestServiceHandler implements Messaging.InboundEmailHandler {

	private STRING con_id = '0030I00001hYb8T';
	
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email,
																Messaging.InboundEnvelope env) {
		
		Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();


		System.debug('Email_to_address: '+ email.toAddresses);
		System.debug('Email_textBody: '+email.plainTextBody);
		System.debug('Email_htmlBody: '+email.htmlBody);

		//Create an acrtivity record for the incoming message
		Task t =  new Task();
		t.Priority = 'Normal';
		t.ActivityDate = Date.today();
		t.status = 'Completed';
		t.subject = 'Email:' + email.subject;
		t.TaskSubtype = 'Email';
		t.whoId=con_id;
		t.Description = createTaskDescriptionFromEmail(email);
		Insert t;

		System.debug('Task_Record: '+ t);

		//Create an Email Message record to be logged in as an activity
		EmailMessage em = new EmailMessage();
		em.ActivityId = t.id;
		em.FromAddress = email.fromAddress;
		em.FromName = email.fromName;
		em.HtmlBody = email.htmlBody;
		em.Incoming = false;
		em.MessageDate = Date.today();
		em.Subject = email.subject;
		em.TextBody = email.plainTextBody;
		em.ToAddress = email.toAddresses[0];

		//insert em;

		System.debug('Email_record: '+ em);


		result.success = true;
		return result;
	}

	public String createTaskDescriptionFromEmail(Messaging.inboundEmail email){
		String tempDesc='';

		tempDesc+='To:' + String.join(email.toAddresses, '; ');
		tempDesc+='\n';
		tempDesc+='CC: '+(email.ccAddresses!=null?String.join(email.ccAddresses, '; '):'');
		tempDesc+='\n';
		tempDesc+='Attachment: --none--';
		tempDesc+='\n';
		tempDesc+='\n';
		tempDesc+='Subject: '+email.subject;
		tempDesc+='\n';
		tempDesc+='Body:';
		tempDesc+='\n';
		tempDesc+=email.plainTextBody;
		return tempDesc;
	}
}