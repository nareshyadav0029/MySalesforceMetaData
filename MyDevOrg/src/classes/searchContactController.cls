public class searchContactController{
    public List<Contact> contacts{get;set;}
    public String firstname{get;set;}
    public String lastname{get;set;}
    public searchContactController(){
        contacts = new List<Contact>();
        contacts = [select firstname , lastname from Contact]; 
    }
    public void Contactsearch(){
        if(firstname !=null && lastname !=null){
            String fname = firstname+'%' ;
            String lname = lastname+'%' ;
            contacts = [select firstname , lastname from contact where firstname like: fname and lastname like: lname];
        }else if(firstname !=null && lastname==null){
            String fname = firstname+'%' ;
            contacts = [select firstname , lastname from contact where firstname like: fname];
        }else if(lastname !=null){
            String lname = lastname+'%' ;
            contacts = [select firstname , lastname from contact where lastname like: lname];
        }else{
            contacts = [select firstname , lastname from contact];
        }
    }   
}