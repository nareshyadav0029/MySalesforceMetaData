/*
        Name        :  insertRevenuePeriods      
        Author      :  Naresh Yadav
        Date        :  10/04/2015
        Description :  This trigger will insert records of RevenuePeriods when an opportunity will insert or update.
*/
trigger insertRevenuePeriods on Opportunity (After insert, After update){
    List<Revenue_Periods__c> revenueToInsert = new List<Revenue_Periods__c>();
    if(Trigger.isInsert){
        for(Opportunity opp : Trigger.new){
            if(opp.StageName.equalsIgnoreCase('Closed Won') && opp.Contract_Start_Date__c != null && opp.Contract_End_Date__c != null && opp.Contract_Amount__c != null){
                for(Integer i=0;i<opp.Contract_Start_Date__c.monthsBetween(opp.Contract_End_Date__c)+1;i++){
                    Revenue_Periods__c revenueObj = new Revenue_Periods__c();
                    if(i==0){
                        revenueObj.Start_Date__c = opp.Contract_Start_Date__c;
                    }else{
                        revenueObj.Start_Date__c = opp.Contract_Start_Date__c.addMonths(i);
                    }
                    revenueObj.Amount__c = opp.Contract_Amount__c / opp.Contract_Start_Date__c.monthsBetween(opp.Contract_End_Date__c.addMonths(1));
                    revenueObj.Percentage__c = opp.Contract_Start_Date__c.monthsBetween(opp.Contract_End_Date__c.addMonths(1));
                    revenueObj.Opportunity__c = opp.id;
                    revenueToInsert.add(revenueObj);
                }
            }
        }
        system.debug('$$$$'+revenueToInsert);
    }  
}