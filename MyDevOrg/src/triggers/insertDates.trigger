trigger insertDates on WorkOrder__c (After insert, After Update){
    List<Calender__c> workDates = new List<Calender__c>();
    Set<ID> work_Ids = new Set<ID>();
    if(Trigger.isInsert){
        for(WorkOrder__c work : [SELECT Start_Date__c, End_Date__c FROM WorkOrder__c WHERE id IN : Trigger.new]){
            if(work.Start_Date__c != null && work.End_Date__c != null){
                date startDate = work.Start_Date__c;
                date endDate = work.End_Date__c;
                integer numberDaysDue = startDate.daysBetween(endDate);
                //system.debug('####'+numberDaysDue);
                for(integer i=1;i<=numberDaysDue;i++){
                    workDates.add(new Calender__c(
                                   WorkOrder_LookUp__c = work.id,
                                   Work_Date__c = work.Start_Date__c.addDays(i)
                                  ));
                }
            }
        }
        insert workDates;
   }else if(Trigger.isUpdate){
       for(WorkOrder__c work : Trigger.new){
           work_Ids.add(work.id);
       }
       delete [SELECT id From Calender__c WHERE WorkOrder_LookUp__c IN : work_Ids];
       for(WorkOrder__c work : [SELECT id, Start_Date__c, End_Date__c FROM WorkOrder__c WHERE id IN : Trigger.new]){
            if(work.Start_Date__c != null && work.End_Date__c != null){
                date startDate = work.Start_Date__c;
                date endDate = work.End_Date__c;
                integer numberDaysDue = startDate.daysBetween(endDate);
                //system.debug('####'+numberDaysDue);
                for(integer i=1;i<=numberDaysDue;i++){
                    workDates.add(new Calender__c(
                                   WorkOrder_LookUp__c = work.id,
                                   Work_Date__c = work.Start_Date__c.addDays(i)
                                  ));
                }
            }
        }
        if(workDates.size()>0){
            insert workDates;
        }
   }
}