trigger UpdateCase on Action_Plan__c (after insert, after update, after delete){
    Set<ID> case_Ids = new Set<ID>();
    List<Case> caseToUpdate = new List<Case>();
    Map<ID, List<Action_Plan__c>> apmap = new Map<ID, List<Action_Plan__c>>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Action_Plan__c AP : Trigger.new){
            if(AP.Action_Plan_Lookup__c != null){
                case_Ids.add(AP.Action_Plan_Lookup__c);
            }
        }
        for(Action_Plan__c AP : [SELECT id, Action_Plan_Lookup__c, Completed__c, Total__c FROM Action_Plan__c WHERE Action_Plan_Lookup__c IN : case_Ids]){
            List<Action_Plan__c> ap_list = apmap.get(AP.Action_Plan_Lookup__c);
            if(ap_list == null){
                ap_list = new List<Action_Plan__c>();
            }
            ap_list.add(AP);
            apmap.put(AP.Action_Plan_Lookup__c, ap_list);
        }
        for(ID caseId : case_Ids){
            Case case_obj = new Case(Id = caseId);
            Decimal completed = 0;
            Decimal total = 0;
            for(Action_Plan__c AP : apmap.get(caseId)){
                completed += AP.Completed__c == null ? 0 : AP.Completed__c;
                Total += AP.Total__c == null ? 0 : AP.Total__c;
            }
            case_obj.Completed__c = completed;
            case_obj.Total__c = total;
            caseToUpdate.add(case_obj);
        }
    }else if(Trigger.isDelete){
        Map<ID, Case> cmap = new Map<ID, Case>();
        for(Action_Plan__c AP : Trigger.old){
            if(AP.Action_Plan_Lookup__c != null){
                case_Ids.add(AP.Action_Plan_Lookup__c);
            }
        }
        for(Case c :[SELECT id, Completed__c, Total__c FROM Case WHERE id IN : case_Ids]){
            cmap.put(c.id, c);
        }
        for(Action_Plan__c AP : Trigger.old){
            if(AP.Action_Plan_Lookup__c != null){
                Case c_obj = cmap.get(AP.Action_Plan_Lookup__c);
                Decimal completed = c_obj.Completed__c == null ? 0 : c_obj.Completed__c;
                Decimal total = c_obj.Total__c == null ? 0 : c_obj.Total__c;
                Decimal a_completed = AP.Completed__c == null ? 0 : AP.Completed__c;
                Decimal a_total = AP.Total__c == null ? 0 : AP.Total__c;
                completed -= a_completed;
                total -= a_total;
                c_obj.Completed__c = completed;
                c_obj.Total__c = total;
                caseToUpdate.add(c_obj);
            }
        }
    }
    if(caseToUpdate.size()>0){
        update caseToUpdate;
    } 
}