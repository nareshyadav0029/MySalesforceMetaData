trigger ClosedOpportunityTrigger on Opportunity (after insert, after update){
    List<Task> taskToInsert = new List<Task>();
    for(Opportunity opp : Trigger.new){
        if(opp.StageName == 'Closed Won'){
            Task t = new Task();
            t.Subject = 'Follow Up Test Task';
            t.WhatId = opp.id;
            taskToInsert.add(t);
        }
    }
    
    if(taskToInsert.size()>0){
        insert taskToInsert;
    }
}