/*

                Date : 30/01/2015
        Trigger Name : UpdateStudentTeacher
         Description : This trigger update the student and teacher field in Account.

*/


Trigger UpdateStudentTeacher on Contact (After Insert, After Update, After Delete, After Undelete){

    Map<ID, List<Contact>> accConmap = new Map<ID, List<Contact>>();
    Map<string,string> Rtmap = new Map<string,string>();
    List<Account> accUpdate = new List<Account>();
    set<string> accIds = new Set<string>();
    Account acc = new Account();
    Integer sum_student = 0;
    Integer sum_teacher = 0;
    
    for(recordtype r : [select id,name from recordtype where SobjectType = 'Contact']){
        Rtmap.put(r.id, r.name);
    }
    if(Trigger.isDelete){        
        for(Contact con : Trigger.old){
            accIds.add(con.AccountId);            
        }
    }else{
        for(Contact con : Trigger.new){
            accIds.add(con.AccountId);            
        }
    }
    if(accIds.size()>0){
        for(Contact con: [select id,RecordTypeId,AccountId from contact where AccountId in : accIds]){
            List<Contact> con_list = accConmap.get(con.AccountId);
            if(con_list == null){
                con_list = new List<Contact>();
            }
            con_list.add(con);
            accConmap.put(con.AccountId, con_list);
        }

        for(account ac: [select id from account where id in :accConmap.keySet()] ){
            sum_student = 0;
            sum_teacher = 0;
            for(Contact con : accConmap.get(ac.id)){
                if(Rtmap.containsKey(con.RecordTypeid)){
                     if(Rtmap.get(con.RecordTypeid).equalsIgnoreCase('Student')){
                        sum_student ++;
                    }
                    if(Rtmap.get(con.RecordTypeid).equalsIgnoreCase('Teacher')){
                        sum_teacher ++;
                    }
                }
            }
            ac.Student__c = sum_student;
            ac.Teacher__c = sum_teacher;
            accUpdate.add(ac);
        }
        if(accUpdate.size()>0){
            update accUpdate;
        }
   }
}