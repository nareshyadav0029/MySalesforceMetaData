/*
                            Name:    jQueryAutoCompleteController
                            Author:  Nisar Ahmed     
                            Date:    21 Jan 2015  
                            Description: A simple Demo for creating autoComplete of the contact Name with their email
*/
public class jQueryAutoCompleteController{
    
    public string emailTo {get;set;}
    public String jsonString {get;set;}
    public String subject {get;set;}
    public String body {get;set;}
    
    //Constructor
    public jQueryAutoCompleteController(){
       jsonString = createJson();
    }
    
    private String createJson(){
        Set<Id> conIds = new Set<Id>();
        Map<String,String> attachmentMap = new Map<String,String>();
        List<EmailModel> emailModelList = new List<EmailModel>();
        
        for(contact con: [SELECT name,email from contact]){
            if(con.email != null){
                conIds.add(con.Id);
                EmailModel eModel  = new EmailModel();
                eModel.label = con.name;
                eModel.value= con.email;
                eModel.conId  = con.id;
                emailModelList.add(eModel);
            }
        }
        
        for(Attachment att : [SELECT id,parentId FROM Attachment where parentId IN :conIds ORDER BY id DESC ]){
            if(attachmentMap.get(att.parentId) == null){
                attachmentMap.put(att.parentId,att.id);
            }
        }
        
        for(EmailModel eModel : emailModelList){
            eModel.imgUrl = attachmentMap.get(eModel.conId) == null ? '00P9000000K5jfM':attachmentMap.get(eModel.conId);
        }
        if(emailModelList.size()>0)
            return JSON.serialize(emailModelList);
            return '';
    }
    
    // Model
    public class EmailModel{
        public String label {get;set;}
        public String value {get;set;}   
        public String imgUrl {get;set;} 
        public String conId {get;set;}
    }
    
    public pagereference SendEmail(){
         messaging.singleEmailMessage email  = new messaging.singleEmailMessage();
         List<String> toEmailList = emailTo.trim().split(',');
         email.setToAddresses(toEmailList);
         email.setSubject(subject);
         email.setHtmlBody(body);
         messaging.sendEmail(new List<messaging.SingleEmailMessage>{email});  
         return new pagereference('/apex/jQueryAutoComplete').setRedirect(true);
    }
}