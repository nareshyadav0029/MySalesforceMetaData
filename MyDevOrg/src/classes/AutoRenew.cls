global class AutoRenew implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        //String query = 'select id,AccountId, Account.name, CloseDate, Name, stageName,(select id,PricebookEntryId,unitprice,name,isAuto_Renew__c,Quantity,OpportunityId,Start_Date__c,End_Date__c from opportunityLineItems where isAuto_Renew__c = true) from opportunity where stageName =  \'Closed Won\'';
        Date dt=Date.Today()+7;
        String query = 'select id,opportunity.AccountId, opportunity.Account.name, opportunity.CloseDate, opportunity.Name, opportunity.stageName, PricebookEntryId,unitprice,name,isAuto_Renew__c,Quantity,OpportunityId,Start_Date__c,End_Date__c from opportunityLineItem where isAuto_Renew__c = true and End_Date__c=2015-01-15 and opportunity.stageName =  \'Closed Won\'';
        return Database.getQueryLocator(query);
        
   }
   
   global void execute(Database.BatchableContext BC, List<OpportunityLineItem> scope){
   
       Map<ID,List<OpportunityLineItem>> MapOpp = new Map<ID,List<OpportunityLineItem>>();
       List<Opportunity> opp_list = new List<Opportunity>();
       
       for(OpportunityLineItem oppitem_list :scope){ 
           List<OpportunityLineItem>  oppLine_list = mapOpp.get(oppitem_list.OpportunityId);
           if(oppLine_list == null){
                oppLine_list = new list<OpportunityLineItem>();       
           }
           oppLine_list.add(oppitem_list);
           mapOpp.put(oppitem_list.OpportunityId,oppLine_list);
       }
       system.debug('@@@@mapOpp'+mapOpp);
       system.debug('@@@@mapOpp'+mapOpp.keyset());
       
       for(Opportunity opp: [select Name, Account.name,CloseDate,stageName from Opportunity where id in :mapOpp.keyset()]){
           Opportunity opp_obj =  new Opportunity();
           if(opp.Account.name == '' || opp.Account.name == null){
               opp_obj.Name = opp.Name;
           }else{
               opp_obj.Name = opp.Account.name;
           }
           opp_obj.CloseDate = opp.CloseDate;
           opp_obj.stageName = opp.stageName;
           opp_list.add(opp_obj);
       }
       Database.SaveResult[] srList = Database.insert(opp_list, false);
       
       for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted : ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('fields that affected this error: ' + err.getFields());
                }
            }
       }
       
       List<OpportunityLineItem > opp_insertlist = new List<OpportunityLineItem >();
       for(Opportunity oppMap:[select id, Name, Account.name from Opportunity where id in :mapOpp.keyset()]){
           for(Opportunity opp:opp_list){
               if(oppMap.Account.Name == opp.Name || oppMap.Name == opp.Name){
                   for(OpportunityLineItem opli: mapOpp.get(oppMap.id)){
                       OpportunityLineItem tmp =new OpportunityLineItem();
                       //tmp=opli;
                       tmp.PricebookEntryId = opli.PricebookEntryId;
                       tmp.unitprice = opli.unitprice;
                       tmp.isAuto_Renew__c = opli.isAuto_Renew__c;
                       tmp.Quantity = opli.Quantity;
                       tmp.Start_Date__c = opli.End_Date__c;
                       tmp.End_Date__c = Date.Today()+372;
                       tmp.OpportunityId=opp.id;
                       opp_insertlist.add(tmp);
                   }
               }
           }
       }
       insert opp_insertlist;
   }

   global void finish(Database.BatchableContext BC){

   }
}