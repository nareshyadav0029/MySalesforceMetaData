public class AssignEntitlementToCaseHelper{
    
    public static void assignEntitlement(){
        List<Entitlement> listOfEntitlement = new List<Entitlement>();
        List<Case> listOfCase = new List<Case>();
        Boolean isUpdate = false;
        for(Case c : [SELECT AccountId, Account.Name, RecordTypeId, RecordType.Name, EntitlementId, Entitlement.Name FROM Case WHERE Id IN : trigger.New]){
            if(c.AccountId != null && c.EntitlementId == null){
                if(entitlementRecordTypes() != null && entitlementRecordTypes().containsKey(c.RecordType.Name)){
                    if(c.RecordType.Name == entitlementRecordTypes().get(c.RecordType.Name)){
                        if(getEntitlementId() != null && getEntitlementId().containsKey(c.Account.Name+' - '+entitlementRecordTypes().get(c.RecordType.Name))){
                            c.EntitlementId = getEntitlementId().get(c.Account.Name+' - '+entitlementRecordTypes().get(c.RecordType.Name));
                            listOfCase.add(c);
                            isUpdate = true;
                        }else{
                            listOfEntitlement.add(setValues(c));
                            listOfCase.add(c);
                        }
                    }
                }
            }else{
                Map<Id, Case> caseMap = new Map<Id, Case>();
                caseMap = (Map<Id, Case>)trigger.oldMap;
                if(c.AccountId != caseMap.get(c.Id).AccountId || c.RecordTypeId != caseMap.get(c.Id).RecordTypeId){
                    if(c.RecordType.Name == entitlementRecordTypes().get(c.RecordType.Name)){
                        if(getEntitlementId() != null && getEntitlementId().containsKey(c.Account.Name+' - '+entitlementRecordTypes().get(c.RecordType.Name))){
                            c.EntitlementId = getEntitlementId().get(c.Account.Name+' - '+entitlementRecordTypes().get(c.RecordType.Name));
                            listOfCase.add(c);
                            isUpdate = true;
                        }else{
                            listOfEntitlement.add(setValues(c));
                            listOfCase.add(c);
                        }
                    }
                }
            }
        }
        
        if(listOfEntitlement.size()>0){
            insert listOfEntitlement;
        }
        
        if(listOfCase.size()>0){
            if(isUpdate == false){
                for(Integer i=0; i<listOfEntitlement.size();i++){
                    listOfCase[0].EntitlementId = listOfEntitlement[0].id;
                }
            }
            update listOfCase;
        }
    }
    
    // Method to set entitlement object for insert.
    public static Entitlement setValues(Case c){
        Entitlement et = new Entitlement();
        //et.RecordType.Name = c.RecordType.Name;
        et.Name = c.Account.Name+' - '+entitlementRecordTypes().get(c.RecordType.Name);
        et.AccountId = c.AccountId;
        et.StartDate = Date.Today();
        if(entitlementProcess() != null && entitlementProcess().containsKey(c.RecordType.Name)){
            et.SlaProcessId = entitlementProcess().get(c.RecordType.Name);
        }
        return et;
    }
    
    //  Method to get entitlement.
    public static Map<String, String> getEntitlementId(){
        Map<String, String> entitlementIdsMap = new Map<String, String>();
        for(Entitlement en : [SELECT Id, Name FROM Entitlement WHERE Status = 'Active']){
            entitlementIdsMap.put(en.Name, en.Id);
        }
        return entitlementIdsMap != null ? entitlementIdsMap : null;
    }
    
    //  Method to get entitlement process for entitlement.
    public static Map<String, String> entitlementProcess(){
        Map<String, String> entitlementProcess = new Map <String, String>();
        for(SlaProcess sl : [SELECT Id, Name FROM SlaProcess WHERE Name IN : entitlementRecordTypes().values() AND isActive = true]){
            entitlementProcess.put(sl.Name, sl.Id);
        }
        return entitlementProcess.size()>0 ? entitlementProcess : null;
    }
    
    //  Method to return all record types for entitlement.
    public Static Map<String, String> entitlementRecordTypes(){
        Map<String, String> entitlementRecordType = new Map <String, String>();
        for(RecordType rd : [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Entitlement']){
            entitlementRecordType.put(rd.Name, rd.Name);
        }
        return entitlementRecordType.size()>0 ? entitlementRecordType : null;
    } 
}