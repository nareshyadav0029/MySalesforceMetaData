trigger CopyAccountAttach on Contact (after insert) {
    Set<ID> acc_Ids = new Set<ID>();
    Map<ID, List<Attachment>> attmap = new Map<ID, List<Attachment>>();
    List<Attachment> attToInsert = new List<Attachment>();
    // Collecting Accound ids
    for(Contact contact : Trigger.new){
        if(contact.AccountId != null){
            acc_Ids.add(contact.AccountId);
        }
    }
    
    // Filling Attachment list to the accounts
    for(Attachment att : [SELECT id, name , parentid, contentType , body from Attachment WHERE parentId IN : acc_Ids]){
        List<Attachment> temp = attmap.get(att.parentId);
        if(temp == null){
            temp = new List<Attachment>();
        }
        temp.add(att);
        attmap.put(att.parentId,temp);
    }
    for(Contact con : Trigger.new){
        if(con.AccountId != null){
            for(Attachment att : attmap.get(con.AccountId)){
                Attachment attach = new Attachment();
                attach.parentId = con.id;
                attach.name = att.name;
                attach.body = att.body;
                attach.contentType = att.contentType;
                attToInsert.add(attach);
            }
        }
    }
    
    if(attToInsert.size()>0){
        insert attToInsert;
    }
}