public class ProjectScientistController{
    
    public Contact con{get;set;}
    public Integer i{get;set;}
    
    ////   Constrauctor   ////
    
    public ProjectScientistController(){
        con = new Contact();
        i=0;
    }
    
    //// Function for next
    
    public void Next(){
        if(i==1){
        }
        i++;   
    }
    
    //// Function For Insert the contact
    
    public void Save(){
        Contact con_insert = new Contact();
        con_insert.firstname = con.firstname;
        con_insert.lastname= con.lastname;
        con_insert.email = con.email;
        con_insert.phone = con.phone;
        
        //insert con_insert;
    }
}