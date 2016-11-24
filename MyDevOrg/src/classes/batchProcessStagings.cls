Global class batchProcessStagings implements Database.Batchable<sObject> {
    Global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Name, Individual_or_Organization__c, Firstname__c, Lastname__c, Orgganization_Name__c, Postal_Code__c FROM Staging__c';
        return Database.getQueryLocator(query);
    }
    Global void execute(Database.BatchableContext BC, List<Staging__c> stage) {
        system.debug('####'+stage);
        List<String> Fname = new List<String>();
        List<String> Lname = new List<String>();
        List<String> Pcode = new List<String>();
        List<String> Orgname = new List<String>();
        List<Contact> insertCon = new List<Contact>(); 
        for(Staging__c st : stage){
            if(st.Individual_or_Organization__c != null && st.Individual_or_Organization__c.startsWithIgnoreCase('i')){
            system.debug('####===>In If Part');
                Fname.add(st.Firstname__c);
                Lname.add(st.Lastname__c);
                Pcode.add(st.Postal_code__c);
                system.debug('####'+Fname);
                system.debug('####'+Lname);
                system.debug('####'+Pcode);
            }
            if(st.Orgganization_Name__c != null && st.Postal_Code__c != null){
            system.debug('####===>In Second If Part');
                Orgname.add(st.Orgganization_Name__c);
                system.debug('####'+Orgname);
            }
        }
        List<Contact> conList = [SELECT id, Firstname, Lastname, MailingPostalCode FROM Contact WHERE Firstname IN : Fname And Lastname IN : Lname And MailingPostalCode IN : Pcode];
        List<Account> accList = [SELECT id, Name FROM Account WHERE Name IN : Orgname And BillingPostalCode IN : Pcode];
        system.debug('####'+accList);
        system.debug('####'+conList);
        if(conList.size()== 0 ){
            Contact con = new Contact();
            for(Staging__c s : stage){
                con.Firstname = s.Firstname__c;
                con.Lastname = s.Lastname__c;
                con.MailingPostalCode = s.Postal_code__c;
                insertCon.add(con);
            }
        }
        /*if(insertCon.size()>0){
            insert insertCon;
        }*/
    }
        
    Global void finish(Database.BatchableContext BC) {

    }
}