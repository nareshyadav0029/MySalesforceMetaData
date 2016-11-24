global class CsvInsert implements Database.Batchable<Sobject>{
    global Map<String, Account> acc_map;
    global CsvInsert(){
        acc_map = new Map<String, Account>();
        for(Account acc : [select id, name from Account]){
            acc_map.put(acc.name.toLowerCase().trim(), acc);
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Firstname__c, Lastname__c, Account__c, Email__c , Phone__c, Amount__c, Error__c from staging__c';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Staging__c> stag_list){
        List<Contact> con_list = new List<Contact>();
        List<Account> acc_list = new List<Account>();
        List<Staging__c> stag_remove = new List<Staging__c>();
        for(Staging__c stag : stag_list){
            if(stag.Error__c == null || stag.Error__c.trim().length() == 0){
                if(acc_map.get(stag.Account__c.toLowerCase().trim()) == null){
                    Account acc = new Account();
                    acc.name = stag.Account__c;
                    acc_list.add(acc);
                }
            }
        }
        
        //// Insert Account ////
        
        if(acc_list.size()>0){
            insert acc_list;
        }
        
        for(Account ac : acc_list){
            acc_map.put(ac.name.toLowerCase().trim(), ac);
        }
        
        ///// Insert Contact /////
        
        for(Staging__c stag : stag_list){
            if(stag.Error__c == null || stag.Error__c.trim().length() == 0){
               Contact con = new Contact();
               if(stag.Firstname__c != null && stag.Firstname__c.trim().length()>0)
                   con.Firstname = stag.Firstname__c;
                   con.AccountId = acc_map.get(stag.account__c.toLowerCase().trim()).id;
                   con.Lastname = stag.Lastname__c;
               if(stag.Phone__c != null)
                     con.phone  = stag.Phone__c;
                     con.email = stag.Email__c;
                     con.Amount__c = stag.Amount__c;
                     con_list.add(con);
                     stag_remove.add(stag);
            }
        }
        
        if(con_list.size()>0){
            insert con_list;
        }
        if(stag_remove.size()>0){
            delete stag_remove;
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
    
    }
    
}