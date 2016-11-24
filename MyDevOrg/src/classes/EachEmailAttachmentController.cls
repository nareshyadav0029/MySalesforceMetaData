////     PARENT CLASS    ////

public class EachEmailAttachmentController{
    public List<ModelEachEmailAttachment> contactlist{get;set;}
    public EachEmailAttachmentController(){
        contactlist = new List<ModelEachEmailAttachment>();
        integer i=1;
        for(Contact c : [select Firstname, Lastname, Email from Contact]){
            ModelEachEmailAttachment model = new ModelEachEmailAttachment();
            model.sno = i;
            model.con = c;
            model.check = false; 
            contactlist.add(model);
            i++;
        }
    } 
    
    ////    MODEL CLASS    ////
    
    public class ModelEachEmailAttachment{
            public integer sno{get;set;}
            public Contact con{get;set;}
            public Boolean check{get;set;}
    }
    
    ////    FUCTION FOR CHECKBOX    ////
    
    public pagereference SendEmail(){
        List<String> emails = new List<String>();
        for(ModelEachEmailAttachment mea : contactlist){
            if(mea.check==true){
                emails.add(mea.con.Email);
            }
        }
        
        messaging.SingleEmailMessage email = new messaging.SingleEmailMessage();        
        email.setToAddresses(emails);        
        email.setSubject('Salesforce Email Testing');        
        email.setHtmlBody('This Email for Testing <b>saleforce</b> Email Send');       
         messaging.sendEmail(new List<messaging.SingleEmailMessage>{email});        
        return new pagereference('/apex/EachEmailAttachment').setRedirect(true);
        
    }   
}