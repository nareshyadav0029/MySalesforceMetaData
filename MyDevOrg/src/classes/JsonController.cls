public class JsonController{
    private String Jsonstr;
    
    // Constractor
    public JsonController(){
        Jsonstr = '{"Firstname":["Naresh","Nitin","Nisar","Sushil"],"Lastname":["Yadav","Sharma","Ahmed","verma"]}}';
        JSONParser parser = JSON.createParser(Jsonstr);
        while(parser.nextToken() != null){
            if(parser.getCurrentToken() == JSONToken.START_OBJECT){
            
            }
        }
    }
}