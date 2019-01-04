@RestResource(urlMapping = '/Accounts/*/contacts')
global with sharing class AccountManager {
	
    @HttpGet
    global static Account getAccount() {
        RestRequest request = RestContext.request;
        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/', request.requestURI.length() - 10) + 1, request.requestURI.length()-9);
        List<Account> accs = [Select Id, Name, (Select Id, Name from Contacts) from Account where Id = :id LIMIT 1];  
        return accs.get(0);
    }
}