/*
    Name          :    insertContactandCase
    Date          :    24/03/2015
    Author        :    Naresh Yadav
    Description   :    When this trigger will fire than a Hire form record is insert with one Contact
                       Record and one case record.
*/
trigger insertContactandCase on Hire_Form__c (After insert, After update){
    Set<String> hireIds = new Set<String>();
    List<Hire_Form__c> hireToinsert = new List<Hire_Form__c>();
    List<Contact> conToInsert = new List<Contact>();
    List<Case> caseToInsert = new List<Case>();
    Map<String,Map<String,List<Case>>> hireCaseMap = new Map<String,Map<String,List<Case>>>();
    if(Trigger.isInsert){
        for(Hire_Form__c hf : Trigger.new){
            hireIds.add(hf.id);
            Contact con = new Contact();
            con.Firstname = hf.First_name__c;
            if(hf.Last_name__c != null){
                con.Lastname = hf.Last_name__c;
            }
            con.Email = hf.Email__c;
            con.Phone = hf.Phone__c;
            conToInsert.add(con);
        }
        if(conToInsert.size()>0){
           insert conToInsert;
        }
        for(Hire_Form__c hf : [select id, name, First_name__c, Last_name__c, Status__c, ContactLookUp__c From Hire_Form__c where id IN : hireIds]){
            for(Contact con : conToInsert){
                Case c = new Case();
                c.Status = 'New';
                c.ContactId = con.id;
                c.Origin = 'Web';
                caseToInsert.add(c);
                hf.ContactLookUp__c = con.id;
                if(hf.Status__c == '--None--' || hf.Status__c == null || hf.Status__c != null){
                    hf.Status__c = 'In Progress';
                }
                hireToInsert.add(hf);
            }
        }
        system.debug('####'+hireCaseMap);
        if(caseToInsert.size()>0){
            insert caseToInsert;
        }
        if(hireToInsert.size()>0){
            update hireToInsert;
        }
    }
    if(Trigger.isUpdate){
    system.debug('####  In Update Case');
        Set<String> conIds = new Set<String>();
        Map<String, List<Case>> tempMap = new Map<String, List<Case>>();
        List<Hire_Form__c> newhireList = new List<Hire_Form__c>(); 
        for(Hire_Form__c hf : Trigger.new){            
            conIds.add(hf.ContactLookUp__c);
            newhireList.add(hf);
        }
        List<case> temp;
        for(case c : [select id,status, ContactId from case where contactid in : conIds ]){
            if(tempMap.containskey(c.contactid)){
                temp = tempMap.get(c.contactid);
            }else{
                temp = new List<case>();
            }          
            temp.add(c);
            tempMap.put(c.contactid,temp);
        }
        for(Hire_Form__c hf : newhireList){
            if(hf.status__c == 'Completed' && !string.isEmpty(hf.contactlookup__c)){
                for(case ca : tempMap.get(hf.contactlookup__c)){
                    ca.status = 'Closed';
                    caseToInsert.add(ca);
                }
            }  
        } 
        if(caseToInsert.size()>0){
            update caseToInsert;
        }
    }
}