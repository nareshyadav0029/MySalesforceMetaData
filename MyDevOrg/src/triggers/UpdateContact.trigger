trigger UpdateContact on Contact (before insert, before update){
    Map<ID, String> accmap = new Map<ID, String>();
    Map<ID, Boolean> ownermap = new Map<ID, Boolean>();
    List<Contact> con_list = new List<Contact>();
    for(Account acc : [select id, OwnerId from Account]){
        accmap.put(acc.id, acc.OwnerId);
    }
    for(User u : [select id, isActive from User]){
        ownermap.put(u.id, u.isActive);
    }
    if(Trigger.isInsert){
        for(Contact con : Trigger.new){
            if(con.AccountId != null || con.AccountId != '' && ownermap.get(accmap.get(con.AccountId)) == true){
                con.OwnerId = accmap.get(con.AccountId);
                con.Lastname = con.Lastname;
            }else{
                con.addError('The account that you are trying to related this contact to has an Owner that is no longer an active Salesforce user. Please reassign ownership of the account to an active user before relating this contact to this account !!!');
            }
        }
    }
    if(Trigger.isUpdate){
        for(Contact con : Trigger.new){
            if(con.OwnerId != accmap.get(con.AccountId) && con.AccountId != null){
                con.addError('Account and Contact Owner will be same');
            }
        } 
    }
}