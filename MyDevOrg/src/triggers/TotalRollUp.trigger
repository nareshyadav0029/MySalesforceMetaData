trigger TotalRollUp on Contact (before insert , before update) {
    Map<ID, List<Contact>> conmap = new Map<ID, List<Contact>>();
    Map<ID, Account> accmap = new Map<ID, Account>();
    List<Account> acc_list = new List<Account>();
    
        //Fill CONMAP ------->
        
        for(Contact con : trigger.new){
            List<Contact> con_list = conmap.get(con.AccountId);
            if(con_list == null){
                con_list = new List<Contact>();
            }
            con_list.add(con);
            conmap.put(con.AccountId, con_list);
        }
        
        //Fill ACCMAP ------->
        
        for(Account acc : [select id, Rollup_Amount_X__c, Rollup_Amount_Y__c,Rollup_Amount__c from Account where ID IN:conmap.KeySet()]){
            accmap.put(acc.id, acc);
        }
        
        // ROLLUP ASSIGNMENT ------>
        
        for(ID acc_id : conmap.KeySet()){
            Account account = accmap.get(acc_id);
            if(account != null){
            decimal sum_x = account.Rollup_Amount_X__c==null?0:account.Rollup_Amount_X__c;
            decimal sum_y = account.Rollup_Amount_Y__c==null?0:account.Rollup_Amount_Y__c;
            decimal sum = account.Rollup_Amount__c==null?0:account.Rollup_Amount__c;
            List<Contact> contact_list = conmap.get(acc_id);
            for(Contact contact : contact_list){
                if(contact.Type__c == 'Positive'){
                    sum_x += contact.Amount_X__c==null?0:contact.Amount_X__c;
                }
                if(contact.Type__c == 'Negative'){
                    sum_y += contact.Amount_Y__c==null?0:contact.Amount_Y__c;
                }
                sum += (contact.Amount_X__c==null?0:contact.Amount_X__c) + (contact.Amount_Y__c==null?0:contact.Amount_Y__c);
            }
            
                account.Rollup_Amount_X__c = sum_x;
                account.Rollup_Amount_Y__c = sum_y;
                account.Rollup_Amount__c = sum;
                acc_list.add(account);
            }
            
        }
        update acc_list;
}