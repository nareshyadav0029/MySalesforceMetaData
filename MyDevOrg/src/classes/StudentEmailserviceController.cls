public class StudentEmailserviceController{
    public List<Student__c> student_list{get;set;}
    public StudentEmailserviceController(){
        student_list = new List<Student__c>();
        student_list = [select Name , Class__c , Email__c from Student__c ]; 
    }
    
    public static void sendEmailTemplate(){
         EmailTemplate template = [select id from EmailTemplate where developerName='StudentEmailService'];
         messaging.SingleEmailMessage email = new messaging.SingleEmailMessage();
         email.setToAddresses(new List<string>{'devilnareshmaycry12@gmail.com'});
         email.setTemplateId(template.id);
         //Account,Contact,Lead
         email.setWhatId([select id from Student__c Limit 1].id);
         //Except Account,Contact,Lead
         // email.setWhatId(stu.id);
         email.setSaveAsActivity(false);
         messaging.sendEmail(new List<messaging.SingleEmailMessage>{email});
         
    }
    
}