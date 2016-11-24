public class searchAccContactPagination_sendmailcont{
    
    public List<String> urlids_list{get;set;}
    public List<Contact> con_to{get;set;}
    public String subject{get;set;}
    public String email_body{get;set;}
    public List<String> attach_urlIds{get;set;}
    public List<String> attach_ids{get;set;}
    public String attach_url{get;set;}
    public String selected_type{get;set;}
    public List<SelectOption> selectType{get;set;}
    public List<Modalattachment> mattach{get;set;}
    public List<Attachment> att_list{get;set;}
    public Attachment attach{get;set;}
    public Boolean att_flag{get;set;}
    public Boolean img_flag{get;set;}
    public Boolean doc_flag{get;set;}
    public Boolean out_flag{get;set;}
    public String att_name{get;set;}
    public List<String> attname_list{get;set;}
    public List<Attachment> attach_name{get;set;}
    
    //// CONSTRACTOR 
    
    public searchAccContactPagination_sendmailcont(){
        selectType = new List<SelectOption>();
        att_list = new List<Attachment>();
        attach_name = new List<Attachment>();
        att_flag = false;
        img_flag = false;
        doc_flag = false;
        out_flag = false;
    }
    
    ////   DUMMY 
    
    public void dummy(){
        attname_list = att_name.split(' ');
        system.debug('####dummy'+attname_list);
        attach_name = [select name,contentType from attachment where id IN : attname_list];
    }
    
    ////   FUNCTION FOR GET CONTACT IDS FROM URL
    
    public void getIdsFromUrl(){
        con_to = new List<Contact>();
        urlids_list = Apexpages.currentPage().getParameters().get('id').split(' ');
        system.debug('####'+urlids_list);
        for(contact con : [select id, name,email from contact where id in:urlids_list]){            
            con_to.add(con);                
        }
        system.debug('####'+con_to);
    }

    ////   FUNCTION FOR SEND EMAIL
      
    public void Send_Email(){  
        messaging.SingleEmailMessage email = new messaging.SingleEmailMessage();
        List<String> email_list = new List<String>();
        for(Contact con : con_to){
            if(con.email != null){
                email_list.add(con.email);
            }
        }
        email.setToAddresses(email_list);
        email.setSubject(subject);
        email.setHtmlBody(email_Body);
        
        List<messaging.emailFileAttachment> attachment_obj = new List<messaging.emailFileAttachment>();
        if(attach_name.size()>0){
            for(Integer i=0; i<attach_name.size();i++){
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                pagereference pgref = new pagereference('https://c.ap1.content.force.com/servlet/servlet.FileDownload');
                pgref.getParameters().put('file', attach_name[i].id);
                Blob body = pgref.getContent();
                efa.setFileName(attach_name[i].name);
                efa.setBody(body);
                attachment_obj.add(efa);
            }
        }
        email.setFileAttachments(attachment_obj);
        messaging.sendEmail(new List<messaging.SingleEmailMessage>{email}); 
    }
    
    ////   FUNCTION FOR ATTACHMENT IDS 
     
    public void getattachid(){     
        attach_url = '/apex/searchAccContactPagination_sendattach?attid=';
        attach_ids = new List<String>();
         for(Attachment att : [select id, name, contentType FROM Attachment WHERE parentid IN : urlids_list]){
             attach_ids.add(att.id);
         }
         if(attach_ids.size()>0){
             for(Integer i=0;i<attach_ids.size();i++){
                 attach_url = attach_url+String.valueOf(attach_ids[i])+' ';
             }
         }  
    }
    
    ////   FUNCTION FOR ATTACHMENT ID FROM URL
    
    public void getattachurlids(){
        attach_urlIds = Apexpages.currentPage().getParameters().get('attid').split(' ');
        selectType.add(new SelectOption('0', '---None---'));
        selectType.add(new SelectOption('1', 'Select Images'));
        selectType.add(new SelectOption('2', 'Select Documents'));
        selectType.add(new SelectOption('3', 'Browse From System'));
    }
    
    ////   FUNCTION FOR ATTACHMENT BROWES OPTION
    
    public void show(){
        system.debug('####'+selected_type);
        mattach = new List<Modalattachment>();
        mattach.clear();
        if(selected_type == '1'){
            img_flag = true;
            doc_flag = false;
            att_flag = false;
            for(Attachment att : [SELECT id, name, contentType FROM Attachment WHERE id IN :attach_urlIds AND (contentType = 'image/jpeg' OR contentType = 'image/png' OR contentType = 'image/gif')]){
               Modalattachment matt = new Modalattachment();
               matt.check = false;
               matt.temp_attach = att;
               mattach.add(matt); 
            }
        }else if(selected_type == '2'){
            doc_flag = true;
            img_flag = false;
            att_flag = false;
            for(Attachment att : [SELECT id, name, contentType FROM Attachment WHERE id IN : attach_urlIds and contentType = 'text/plain']){
               Modalattachment matt = new Modalattachment();
               matt.check = false;
               matt.temp_attach = att;
               mattach.add(matt); 
            }
        }else if(selected_type == '3'){
            att_flag = true;
            img_flag = false;
            doc_flag = false;
        }
    }
    
    
    ////   MODAL CLASS
    
    public class Modalattachment{
        public Boolean check{get;set;}
        public Attachment temp_attach{get;set;}
    }
}