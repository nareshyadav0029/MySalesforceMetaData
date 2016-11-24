public class batchProcessStagingsController{
    public List<String> Fname;
    public List<String> Lname;
    public List<String> Pcode;
    public List<String> Orgname;
    public List<Contact> insertCon;
    Map<id, Staging__c> map1;
    Map<id, Staging__c> map2;
    // Constractor
    public batchProcessStagingsController(){
        map1 = new Map<id, Staging__c>();
        map2 = new Map<id, Staging__c>();
        Fname = new List<String>();
        Lname = new List<String>();
        Pcode = new List<String>();
        Orgname = new List<String>();
        insertCon = new List<Contact>();
        List<Staging__c> stage = [SELECT Id, Name, Individual_or_Organization__c, Firstname__c, Lastname__c, Orgganization_Name__c, Postal_Code__c FROM Staging__c];
        system.debug('####===>Stage'+stage);
        for(Staging__c st : stage){
            if(st.Individual_or_Organization__c != null && st.Individual_or_Organization__c.startsWithIgnoreCase('i')){
            system.debug('####===>In If Part');
                map1.put(st.id, st);
                system.debug('####'+map1);
            }else{
                map2.put(st.id, st);
                system.debug('####'+map2);
            }
            if(st.Orgganization_Name__c != null && st.Postal_Code__c != null){
            system.debug('####===>In Second If Part');
                Orgname.add(st.Orgganization_Name__c);
                system.debug('####'+Orgname);
            }
        }
        List<Contact> conList = [SELECT id, Firstname, Lastname, MailingPostalCode FROM Contact];
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
    }
}