@isTest
public class AccountManagerTest {
	
    @isTest
    static void getAccountContactTest() {
        RestRequest request = new RestRequest();
        String testAccId = '0012800000dMA5B';
        request.requestUri = 'https://ap2.salesforce.com/services/apexrest/Account/'+ testAccId + '/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
       	Account acc = AccountManager.getAccount();
        
        System.assertEquals(1, acc.contacts.size());
    }
}