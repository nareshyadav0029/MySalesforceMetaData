public class CustomEmailTemplateController{
     public List<Contact> con_list{get;set;}
     public String con_name{get;set;}
     public String con_email{get;set;}
     public String add_email{get;set;}
     public List<EmailTemplate> email_Temp{get;set;}
     public List<SelectOption> select_email{get;set;}
     public List<Account> acc_list{get;set;}
     public List<SelectOption> select_acc{get;set;}
     public String selected_email{get;set;}
     public String selected_acc{get;set;}
     public String subject{get;set;}
     public String email_body{get;set;}
     public String emailBody {get;set;}
     public Attachment attach{get;set;}
     
////// Constructor /////////
     
     public CustomEmailTemplateController(){
         emailBody ='';
         attach = new Attachment();
         select_email = new List<SelectOption>();
         select_acc = new List<SelectOption>();
         con_list = [SELECT id, name, email FROM Contact];
         
         email_Temp = [SELECT id, name FROM EmailTemplate];
         for(EmailTemplate et: email_Temp){
             select_email.add(new SelectOption(et.id, et.name));
         }
         select_email.sort();
         select_email.add(0, new SelectOption('null', '--- Select Email Template ---'));
         
         acc_list = [SELECT id, name, phone, website, fax FROM Account];
         for(Account acc: acc_list){
             select_acc.add(new SelectOption(acc.id, acc.name));
         }
         select_acc.sort();
         select_acc.add(0, new SelectOption('null', '--- Select Account ---'));   
     }
     
     public void contact_search(){
         if(con_name != null){
             String name = con_name+'%';
             con_list = [select name, email from Contact where name like: name]; 
         }else{
             con_list = [select name, email from Contact]; 
         }
     }
     
     public pagereference Send_Email(){
         if(con_email != '' && con_email != null){
             
             messaging.SingleEmailMessage email = new messaging.SingleEmailMessage();
             List<String> email_list = new List<String>();
             if(add_email != null && add_email != ''){
                 
                 email_list = add_email.split(',');
                 
             }
             email_list.add(con_email);
             email.setToAddresses(email_list);
             email.setSubject(subject);
             email.setHtmlBody(emailBody);
             
             messaging.emailFileAttachment attachment = new  messaging.emailFileAttachment();
                 attachment.setFileName(attach.name);
                 attachment.setBody(attach.body);
                 if(attachment.body != null){
                     email.setFileAttachments(new List<messaging.emailFileAttachment>{attachment});
                 }
                 messaging.sendEmail(new List<messaging.SingleEmailMessage>{email});
         }
         return new pagereference('/apex/CustomEmailTemplate').setRedirect(true);  
     }
     
     public void  getBody(){
         Account acc_detail = new Account();
         List<String> exp_list = new List<String>();
         String temp;
         String finalBody = '';
         String msg = '';
         
         if(selected_acc != 'null'){
             acc_detail = [SELECT name, phone, fax, website FROM Account WHERE id =: selected_acc LIMIT 1];
             
             if(selected_email != 'null'){
             temp = [SELECT body FROM EmailTemplate where id =: selected_email limit 1].body;
             finalBody = temp;
             /*while(true){
                 if(temp.indexOf('{!') == -1){
                     break;
                 }
                 msg += temp.substring(0, temp.indexOf('{!'));
                 exp_list.add(temp.substring(temp.indexOf('{!'), temp.indexOf('}')+1));
                 temp = temp.substring(temp.indexOf('}')+1);
             }
             msg += temp;
             emailBody = msg; 
             system.debug('####'+msg);
             system.debug('$$$$'+exp_list);*/
             finalBody = finalBody.replace('{!Account.Name}',acc_detail.name == null ? '{!Account.Name}' : acc_detail.name );
             finalBody = finalBody.replace('{!Account.Phone}',acc_detail.phone == null ? '{!Account.Phone}' : acc_detail.phone);
             finalBody = finalBody.replace('{!Account.Website}',acc_detail.website == null ? '{!Account.Website}' :acc_detail.website);
             finalBody = finalBody.replace('{!Account.Fax}',acc_detail.fax == null ? '{!Account.Fax}' : acc_detail.fax );
             emailBody = finalBody;
         }
         }
     }
}