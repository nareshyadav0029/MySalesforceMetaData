/*

        Description    :    This class make a http request(REST request).

*/

public class AnimalLocator{
    public AnimalWrapper animal;
    //  Method to make a http request
    public static String getAnimalNameById(Integer id){
        AnimalLocator animalWrap = new AnimalLocator();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            System.debug('####'+response.getBody());
            // Deserialize the JSON string into collections of primitive data types.
            animalWrap = (AnimalLocator)System.JSON.deserialize(response.getBody(), AnimalLocator.class);
        }
        return animalWrap.animal.name;
    }
    
    //  Wrapper class
    public class AnimalWrapper{
        public Integer id;  //1
        public String name; //chicken
        public String eats; //chicken food
        public String says; //cluck cluck
    }

}