/*
        Name        :    insertOppLineItem
        Date        :    30/03/2015
        Description :    When will this trigger fire than opportunity line item will insert. A custom picklist is
                         used.
*/
trigger insertOppLineItem on Opportunity(After insert, After update){
    Set<String> primaryProductName = new Set<String>();
    Map<String, PriceBookEntry> productPriceBookMap = new Map<String, PriceBookEntry>();
    Set<String> oppIds = new Set<String>();
    List<OpportunityLineItem> oppLineItem = new List<OpportunityLineItem>();
    for(Opportunity opp : Trigger.new){
        oppIds.add(opp.id);
        if(opp.Primary_Product__c != null){
            primaryProductName.add(opp.Primary_Product__c);
        }
    }
    system.debug('##### primaryProductName=='+primaryProductName);
    system.debug('##### OppIds=='+oppIds);
    for(PricebookEntry pb : [select id, Name, product2.Name from PricebookEntry where product2.Name IN : primaryProductName]){
        productPriceBookMap.put(pb.product2.Name,pb);
    }
    system.debug('##### map=='+productPriceBookMap);
    if(Trigger.isInsert){ 
        for(Opportunity opp : [select id, Name, primary_product__c, Amount from opportunity where id IN : oppIds]){
            if(opp.Primary_Product__c != null && primaryProductName.contains(productPriceBookMap.get(opp.Primary_Product__c).Name)){
                OpportunityLineItem oppLine = new OpportunityLineItem();
                oppLine.OpportunityId = opp.id;
                oppLine.PriceBookEntryId = productPriceBookMap.get(opp.Primary_Product__c).id;
                oppLine.Quantity = 1;
                if(opp.Amount != null){
                    oppLine.UnitPrice = opp.Amount;
                }else{
                    oppLine.UnitPrice = 0;
                }
                oppLineItem.add(oppLine);
            }
        }
        if(oppLineItem.size()>0){
            insert oppLineItem;
        }
    }
    if(trigger.isUpdate){
    }    
}