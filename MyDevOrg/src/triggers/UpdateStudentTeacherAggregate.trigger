/*

                Date : 30/01/2015
        Trigger Name : UpdateStudentTeacher
         Description : This trigger update the student and teacher field in Account.

*/

Trigger UpdateStudentTeacherAggregate on Contact (After Insert, After Update, After Delete, After Undelete){
    Set<ID> accIds = new Set<ID>();
    List<Account> accUpdate = new List<Account>();
    Map<string,string> Rtmap = new Map<string,string>();
    
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
        map<string,map<string,integer>> mapAccAgg=new map<string,map<string,integer>>(); 
         system.debug('#####'+[select count(RecordTypeId) scount, RecordType.Name rname, accountId accid from Contact where AccountId in : accIds and recordtypeid IN : Rtmap.KeySet() group by RecordType.Name, accountId]);
        for(AggregateResult AR: [select count(RecordTypeId) scount, RecordType.Name rname, accountId accid from Contact where AccountId in : accIds and recordtypeid IN : Rtmap.KeySet() group by RecordType.Name, accountId]){
            map<string,integer> mapTemp=mapAccAgg.get((string)AR.get('accid'));
            if(mapTemp==null){
                mapTemp=new map<string,integer>();
            }
            mapTemp.put((string)AR.get('rname'),(Integer)AR.get('scount'));
            system.debug('#####'+mapTemp);
            mapAccAgg.put((string)AR.get('accid'),mapTemp);
        }
        system.debug('#####'+mapAccAgg);
       for(account ac : [select id,Teacher__c,student__c from account where id in : accIds]){
           ac.student__c = 0;
           ac.Teacher__c = 0;
           if(mapAccAgg.get(ac.id).containsKey('Student')){
               ac.student__c=mapAccAgg.get(ac.id).get('Student');
           }
           if(mapAccAgg.get(ac.id).containsKey('Teacher')){
               ac.Teacher__c=mapAccAgg.get(ac.id).get('Teacher');
           }
           accUpdate.add(ac);
       }
    }
    if(accUpdate.size()>0){
        update accUpdate;
    }  
}







/*

    trigger CountTeacherStudent on Contact (after insert,after update,after delete, after undelete) {
    Map<Id, Account> IdAccount = new Map<Id, Account>();
    Set<String> accountIds = new Set<String>();
    if(trigger.isInsert || trigger.isUPdate || trigger.isUndelete) {
        for(Contact con : Trigger.New){
              if((Trigger.isInsert || trigger.isUndelete) && con.accountid != null){
                accountIds.add(con.AccountId);
            }else if(Trigger.isUpdate){
                    accountids.add(con.accountid);
                    accountids.add(trigger.oldMap.get(con.id).accountid);
            }
        }
    }
     if(Trigger.isDelete){
         for(contact con : Trigger.old){
                if(con.accountid != null){
                    accountids.add(con.accountid);
              }
         }
     }
     if(accountIds.size()>0){
         Map<id,integer> acountMapst = new Map<id,integer>();
         Map<id,decimal> acountMaptea = new Map<id,decimal>();
         list<account> accountlist = new list<account>([Select id,No_of_students__c,No_of_Teachers__c from account Where id in: accountIds]);
         RecordType RecType = [Select Id,name From RecordType  Where SobjectType = 'Contact' and Name = 'Student'];
         RecordType RecType1 = [Select Id,name From RecordType  Where SobjectType = 'Contact' and Name = 'Teacher'];
         LIST<AggregateResult> conlist = [select count(id) total,AccountId from contact where AccountId in : accountIds and recordtypeid =: RecType.id GROUP BY AccountId ];
         LIST<AggregateResult> conlist1 = [select count(id) totalteac,AccountId from contact where AccountId in : accountIds and recordtypeid =: RecType1.id GROUP BY AccountId ];
         
         for(AggregateResult a : conlist) {  
                acountMapst.put((id)a.get('accountid'),(Integer)a.get('total'));
         }
         for(AggregateResult a1 : conlist1) {  
                acountMaptea.put((id)a1.get('accountid'),(Integer)a1.get('totalteac'));
         }
         for(account acc : accountlist){
                //acc.No_of_Teachers__c = acc.No_of_Teachers__c = 0;
                if(acountMapst.containskey(acc.id)){
                    acc.No_of_students__c = acountMapst.get(acc.id);
                }
                if(acountMaptea.containskey(acc.id)){
                    acc.No_of_Teachers__c =  acountMaptea.get(acc.id);
                }
            }
        update accountlist;
     }
*/