@isTest
public class ParkLocatorTest {
    
    @isTest
    static void testParksByCountry() {
        ParkServiceMock mock = new ParkServiceMock();
        Test.setMock(WebServiceMock.class, mock);
        
        String[] parks = ParkLocator.country('India');
        
        System.assertEquals(3, parks.size());
    }
}