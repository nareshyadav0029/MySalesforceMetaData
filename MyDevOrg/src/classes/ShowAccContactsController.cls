public class ShowAccContactsController{
    public Map<List<String>,List<String>> contacts{get;set;}
    public ShowAccContactsController(){
        contacts = new Map<List<String>,List<String>>();
        List<Contact> con = [select firstname , lastname from Contact];
        for(Contact contactone : con){
        }
        
    }
}