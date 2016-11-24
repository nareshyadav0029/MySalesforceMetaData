/*
   Name           :    SetPrimaryContact 
   Author         :    Naresh Yadav
   Date           :    24/03/2015
   Description    :    When the Opportunity object is created or edited, 
                       set the Primary Contact field (Primary Contact is a Lookup field to Contact) to a Contact associated 
                       with the Account that is associated with the Opportunity IF the Primary Contact field is not already 
                       set to a Contact.
*/
trigger SetPrimaryContact on Opportunity (After insert, After update){
    Set<String> accIds = new Set<String>();
    Set<String> oppIds = new Set<String>();
    Map<String, String> accConMap = new Map<String, String>();
    List<Opportunity> oppToInsert = new List<Opportunity>();
    for(Opportunity opp : Trigger.new){
        oppIds.add(opp.id);
        if(opp.accountId != null)
            accIds.add(opp.AccountId);
    }
    for(Account acc : [select id, name, (select id, name from Contacts limit 1) from Account where id IN : accIds]){
        if(acc.contacts.size() > 0)
            accConMap.put(acc.id,acc.contacts.get(0).id);
    }
    if(Trigger.isInsert){
        for(opportunity opp : [select id, name, primary_contact__c, AccountId from opportunity where AccountId IN : accIds And id IN : oppIds]){
            if(opp.AccountId != null && opp.primary_contact__c == null){
                opp.primary_contact__c = accConMap.ContainsKey(opp.AccountId)?accConMap.get(opp.AccountId):null;
                oppToInsert.add(opp);
            }
        } 
    }
    if(Trigger.isUpdate){
        for(opportunity opp : [select id, name, primary_contact__c, AccountId from opportunity where AccountId IN : accIds And id IN : oppIds]){
            if(opp.AccountId != null && opp.primary_contact__c == null){
                opp.primary_contact__c = accConMap.ContainsKey(opp.AccountId)?accConMap.get(opp.AccountId):null;
                oppToInsert.add(opp);
            }
        }
    }
    if(oppToInsert.size()>0){
        update oppToInsert;
    }
}