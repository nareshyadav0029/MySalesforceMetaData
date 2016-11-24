trigger UpdateOwner on Account (After update){
    Map<ID, String> accmap = new Map<ID, String>();
    List<Contact> updateCon = new List<Contact>();
    for(Account acc : trigger.new){
        accmap.put(acc.id, acc.OwnerId);
    }
    For(Contact contact : [select id, OwnerId, AccountId from Contact where Accountid IN : accmap.keySet()]){
        contact.OwnerId = accmap.get(contact.AccountId);
        updateCon.add(contact);
    }
    if(updateCon.size()>0){
        update updateCon;
    }
}