public class contactController{
    //    SHOW ALL CONTACTS RECORDS
    @AuraEnabled
    public static List<Contact> getContacts(){
        return [SELECT Id, Name, MailingStreet, Phone, Email, Level__c FROM Contact];
    }
    
    //    RETRIVE ALL PRIMARY CONTACTS
    @AuraEnabled
    public static List<Contact> getPrimary(){
        return [SELECT Id, Name, MailingStreet, Phone, Email, Level__c FROM Contact WHERE Level__c = 'Primary'];
    }
    
    //    RETRIVE ALL Secondary CONTACTS
    @AuraEnabled
    public static List<Contact> getSecondary(){
        return [SELECT Id, Name, MailingStreet, Phone, Email, Level__c FROM Contact WHERE Level__c = 'Secondary'];
    }
}