trigger UpdateAccount on Contact (after insert, after update, after delete) {
    Set<ID> acc_Ids = new Set<ID>();
    List<Account> accToUpdate = new List<Account>();
    Map<ID, List<Contact>> conmap = new Map<ID, List<Contact>>();
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Contact con : Trigger.new){
            if(con.AccountId != null){
                acc_Ids.add(con.AccountId);
            }
        }
        for(Contact con : [select id, AccountId ,My_Amount__c From Contact where Accountid IN : acc_Ids]){
            List<Contact> con_list = conmap.get(con.AccountId);
            if(con_list == null){
                con_list = new List<Contact>();
            }
            con_list.add(con);
            conmap.put(con.Accountid, con_list);
        }
        for(ID accId : acc_Ids){
            Account acc_obj = new Account(Id = accId);
            Decimal total = 0;
            for(Contact con : conmap.get(accId)){
                total += con.My_Amount__c == null ? 0 : con.My_Amount__c;
            }
            acc_obj.Total_My_Amount__c = total;
            accToUpdate.add(acc_obj);
        }  
   }else if(Trigger.isDelete){
       Map<id,Account> accmap = new Map<id,Account>();
       for(Contact con : Trigger.old){
            if(con.AccountId != null){
                acc_Ids.add(con.AccountId);
            }
       }
       for(Account acc : [select id,Total_My_Amount__c from Account WHERE id IN:acc_Ids]){
           accmap.put(acc.id,acc);
       }
       for(Contact con : Trigger.old){
            if(con.AccountId != null){
                Account acc_obj = accmap.get(con.AccountId);
                Decimal total = acc_obj.Total_My_Amount__c == null ? 0:  acc_obj.Total_My_Amount__c;
                Decimal conTotal = con.My_Amount__c == null ? 0 : con.My_Amount__c;
                total -= conTotal;
                acc_obj.Total_My_Amount__c = total;
                accToUpdate.add(acc_obj);
            }
       } 
   }
   
   if(accToUpdate.size()>0){
            update accToUpdate;
        }
}