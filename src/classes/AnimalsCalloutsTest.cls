@isTest
public class AnimalsCalloutsTest {
	
    @isTest
    static  void testGetCallout() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        //Creating a mock object
        mock.setStaticResource('GetAnimalResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        //Setting the created mock for callout
        Test.setMock(HttpCalloutMock.class, mock);
        
        HttpResponse response = AnimalsCallouts.makeGetCallout();
        
        System.assertEquals(200, response.getStatusCode());
    }
    
    @isTest
    static void testPostCallout() {
        
        //Set up the mock class
        Test.setMock(HttpCalloutMock.class, new AnimalsHttpCalloutMock());
        
        HttpResponse response = AnimalsCallouts.makePostCallout();
        
        System.assertEquals(200, response.getStatusCode());
    }
}