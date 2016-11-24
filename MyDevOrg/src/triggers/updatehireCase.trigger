/*
    Name          :    insertContactandCase
    Date          :    25/03/2015
    Author        :    Naresh Yadav
    Description   :    When this trigger will fire than it first checks the status of hire Form if it is completed than 
                       case will updated other wise gives error.
*/
trigger updatehireCase on Case (Before update){
    Map<String, List<Case>> conCaseMap = new Map<String, List<Case>>();
    List<Case> casetoUpdate = new List<Case>();
    if(Trigger.isUpdate){
            for(Case c : Trigger.new){
            List<Case> tempList = new List<Case>();
            tempList.add(c);
            if(c.ContactId != null){
                conCaseMap.put(c.ContactId, tempList);
            }    
        }
        for(Hire_Form__c hf : [select id, name, ContactLookUp__c, status__c from Hire_Form__c where ContactLookUp__c IN : conCaseMap.keySet()]){
            for(Case c : conCaseMap.get(hf.ContactLookUp__c)){
                if(c.status == 'Closed' && hf.Status__c != 'Completed'){
                    c.status.addError('You can not close the case until hire form  is completed');
                }
            }
        }
    }   
}