public class testClass {
	public String URL {get; set;}

	public testClass() {
		//Another comment to generate Conflict
		string domain=System.URL.getSalesforceBaseURL().getHost();
		list<string>DomainList=domain.split('\\.',0);
		string newDomein=DomainList[0];
		newDomein =  newDomein.substring(0,newDomein.length()-1);

		URL = '/apex/DisplayImage';
		System.debug('__URL__ '+ URL);
	}

	
}