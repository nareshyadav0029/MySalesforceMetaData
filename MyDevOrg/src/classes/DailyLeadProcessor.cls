global class DailyLeadProcessor implements Schedulable{
    
    global void execute(SchedulableContext ctx){
        List<Lead> leadUpdateList = new List<Lead>();
        
        for(Lead l : [SELECT Id, Name, LeadSource FROM Lead WHERE LeadSource = NULL]){
            l.LeadSource = 'Dreamforce';
            leadUpdateList.add(l);
        }
        
        if(leadUpdateList.size()>0){
            update leadUpdateList;
        }
    }

}