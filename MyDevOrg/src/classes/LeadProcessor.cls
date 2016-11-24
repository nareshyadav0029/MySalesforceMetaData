global class LeadProcessor implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, Name, LeadSource FROM Lead]);
    }

    global void execute(Database.BatchableContext bc, List<Lead> scope){
        List<Lead> leadList = new List<Lead>();
        if(scope.size()>0){
            for(Lead l : scope){
                l.LeadSource = 'Dreamforce';
                leadList.add(l);
            }
        }
        
        if(leadList.size()>0){
            update leadList;
        }
    }    

    global void finish(Database.BatchableContext bc){

    }    

}