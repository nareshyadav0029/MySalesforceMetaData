trigger UpdateCaseLastActivity on Task (after insert) {
    Set<ID> case_Ids = new Set<ID>();
    List<Case> case_list = new List<Case>();
    
    if(Trigger.isUpdate){
        for(Task t : Trigger.new){
            String RelatedToId = t.WhatId+'';
            String status = 'statusNotChanged';
            Task oldTask = Trigger.oldMap.get(t.id);
            if(oldTask != null && oldTask.status != t.status){
                status = t.status+'';
            }
            if(RelatedToId.startsWith('500') && (status.equals('completed')==true)){
                case_Ids.add(t.WhatId);
            }
        }
    }
    if(Trigger.isInsert){
        for(Task t : Trigger.new){
            String RelatedToId = t.WhatId+'';
            String status = 'statusNotChanged';
            if(RelatedToId.startsWith('500') && (status.equals('completed')==true)){
                case_Ids.add(t.WhatId);
            }
        }
    }
    
    if(case_Ids.size()>0){
        case_list = [SELECT Last_Activity_DateTime__c, id FROM Case WHERE id IN:case_Ids];
        for(Case c: case_list){
            c.Last_Activity_DateTime__c = DateTime.Now();
        }
        update case_list;
    }
}