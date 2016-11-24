trigger OrdertoOpportunitySpecification on Order (After insert){
    List<Opportunity> oppListtoInsert = new List<Opportunity>();
    List<Order> orederListtoUpdate = new List<Order>();
    Set<String> orderIds = new Set<String>();
    for(Order od : Trigger.new){
        orderIds.add(od.id);
        if(od.ND_Sales_Channel__c != 'Direct Sales' && od.ND_Status__c.equalsIgnoreCase('EXPIRED_NOT_RENEWED') && od.ND_Total_Amount__c != 0 && od.Effort_8_Created__c != true){
            Opportunity opp = new Opportunity();
            opp.Name = 'Individual Effort 8 Renewal';
            opp.CloseDate = od.EffectiveDate;
            opp.Revenue_Type__c = 'Individual';
            opp.OrderNumber__c = od.OrderNumber;
            opp.AccountId = od.AccountId;
            opp.StageName = 'Qualified';
            opp.LeadSource = 'Effort 8 Renewal';
            oppListtoInsert.add(opp);
        }
    }
    for(Order od : [select id, Effort_8_Created__c from Order where id IN : orderIds]){
        od.Effort_8_Created__c = true;
        orederListtoUpdate.add(od);
    }
    if(oppListtoInsert.size()>0){
        insert oppListtoInsert;
    }
    if(orederListtoUpdate.size()>0){
        update orederListtoUpdate;
    }
}