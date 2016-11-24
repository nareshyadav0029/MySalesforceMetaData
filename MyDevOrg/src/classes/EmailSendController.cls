public class EmailSendController{
    //Constructor
    public EmailSendController(){
       
    }
    public static void sendEmail(){
        messaging.SingleEmailMessage email = new messaging.SingleEmailMessage();
        email.setToAddresses(new List<string>{'devilnareshmaycry12@gmail.com'});
        email.setSubject('Salesforce Email Testing');
        email.setHtmlBody('This Email for Testing <b>saleforce</b> Email Send');
        messaging.sendEmail(new List<messaging.SingleEmailMessage>{email});
    }
    public static void sendAttachment(){
        messaging.SingleEmailMessage email = new messaging.SingleEmailMessage();
        email.setToAddresses(new List<string>{'devilnareshmaycry12@gmail.com'});
        email.setSubject('Salesforce Email Testing');
        email.setHtmlBody('This Email for Testing <b>saleforce</b> Email Send');
        messaging.emailFileAttachment attachment = new  messaging.emailFileAttachment();
        attachment.setFileName('demo.txt');
        attachment.setBody(blob.valueOf('Testing Attachment'));
        email.setFileAttachments(new List<messaging.emailFileAttachment>{attachment});
        messaging.sendEmail(new List<messaging.SingleEmailMessage>{email});
    }
    public static void sendEmailTemplate(){
         EmailTemplate template = [select id from EmailTemplate where developerName='FirstEmailTemplate'];
         messaging.SingleEmailMessage email = new messaging.SingleEmailMessage();
         email.setToAddresses(new List<string>{'devilnareshmaycry12@gmail.com'});
         email.setTemplateId(template.id);
         //Account,Contact,Lead
         email.setTargetObjectId([select id from contact limit 1].id);
         //Except Account,Contact,Lead
         // email.setWhatId(stu.id);
         email.setSaveAsActivity(false);
         messaging.sendEmail(new List<messaging.SingleEmailMessage>{email});
         
    }
    
}