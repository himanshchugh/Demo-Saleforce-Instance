public class ParkLocator {

    
    public static String[] country(String country) {
        ParkService.ParksImplPort parks = new ParkService.ParksImplPort();
        
        return parks.byCountry(country);
    }
}