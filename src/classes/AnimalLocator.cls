public class AnimalLocator {

    public static String getAnimalNameById(Integer id) {
        //Create a Http request
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+ id);
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);
        //Deserialize the recieved JSON
        System.debug(response.getBody());
        Map<String, Object> detail = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        Map<String, Object> animal = (Map<String, Object>) detail.get('animal');
        return (String) animal.get('name');
    }
}