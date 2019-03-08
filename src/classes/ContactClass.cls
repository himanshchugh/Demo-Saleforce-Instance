public class ContactClass {

	@AuraEnabled
	public static List<Contact> getCompanyContacts(String acc_name) {
		//preparing account Expression
		String acc_name_exp = '%'+acc_name+'%';
		List<Contact> cmpany_cons = [Select id, FirstName, LastName from Contact where Account.Name LIKE :acc_name_exp];
		return cmpany_cons;
	}

	@AuraEnabled
	public static List<Account> getCompanyRec(String acc_name) {
		//preparing account Expression
		
		//List<Contact> cmpany_cons = [Select id, FirstName, LastName from Contact where Account.Name LIKE :acc_name_exp];
		List<Account> cmpany = new List<Account>();
		cmpany.add(new Account(Name='testAcc'));
		return cmpany;
	} 
}