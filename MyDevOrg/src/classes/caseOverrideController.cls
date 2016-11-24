/*
           Date - 04/02/2015
     Class Name - caseOverrideController
      Page Name - caseOverrideController
    Description - Override standard button on case and show a custon VF page.
    
*/

public class caseOverrideController{
    
    //    DEFINE OBJECT
    
    public List<SelectOption> selectRecord{get;set;}
    public List<SelectOption> selectCon{get;set;}
    public String selected_Record{get;set;}
    public String selected_site{get;set;}
    public String selected_con{get;set;}
    public Contact conList{get;set;}
    public Boolean con_flag{get;set;}
    public Boolean pick_flag{get;set;}
    public Contact conSite{get;set;}
    public RecordType rec{get;set;}
    public String selected_acc{get;set;}
    public Account accName{get;set;}
    
    //    CONSTRUCTOR
    public caseOverrideController(Apexpages.standardController obj){
        selectRecord = new List<SelectOption>();
        selectCon = new List<SelectOption>();
        conList = new Contact();
        conSite = new Contact();
        accName = new Account();
        for(RecordType rec : [SELECT id,name FROM RecordType WHERE SobjectType='Case']){
            selectRecord.add(new Selectoption(rec.id, rec.Name));
        }
        con_flag = false;
        pick_flag = true;
    }
    
    //    FUNCTION FOR CONTACT INFO AND RELATED ACCOUNT
    
    public void getConacc(){
        con_flag = true;
        selectCon.clear();
        rec = [select id,name from recordType WHERE SobjectType='Case' And id =: selected_Record];
        if(selected_con != null && selected_con != ''){
            conList = [SELECT id, Name, Account.Name, AccountId, Title, Phone, Email FROM Contact WHERE id =: selected_con LIMIT 1];
            if(conList.accountId != null){
              accName.Name  = conList.Account.Name;
              accName.id  = conList.AccountId;
            }
        }
        List<Account> accList = [SELECT id, name, (SELECT id, name FROM Contacts) FROM Account WHERE id =: conList.AccountId LIMIT 1];
        for(Account acc : accList){
            if(acc.Contacts.size()>0){
                if(acc.Contacts.size()==1){
                    selected_site = acc.Contacts[0].name;
                }else{
                    for(Contact con : acc.Contacts){
                        selectCon.add(new Selectoption(con.Name, con.Name));
                    }
                }
            }
        }
        pick_flag = false;
        system.debug('####'+conList);
        system.debug('####'+selected_Record);
    }
    
    //    FUNCTION FOR CONTACT RELATED TO ACCOUNT
    
    public void getContact(){
        selectCon.clear();
        List<Account> accList = [SELECT id, name, (SELECT id, name FROM Contacts) FROM Account WHERE id =: selected_acc LIMIT 1];
        accName.Name = accList[0].Name;
        accName.id = accList[0].id;
        for(Account acc : accList){
            if(acc.Contacts.size()>0){
                if(acc.Contacts.size()==1){
                    selected_site = acc.Contacts[0].name;
                }else{
                    for(Contact con : acc.Contacts){
                        selectCon.add(new Selectoption(con.Name, con.Name));
                    }
                }
            }
        }
        pick_flag = false;  
    }
    
    //    FUNCTION FOR STANDARD CASE PAGE
    
    public pagereference next(){
        PageReference pageRef;
        PageReference pageRefone;
        PageReference pageReftwo;
        Account acc = new Account(); 
        system.debug('*******site'+ selected_site);
        if(selected_site != null && selected_site.trim().length()>0){
            conSite = [SELECT id, Name FROM Contact WHERE Name =: selected_site LIMIT 1];
        }
        /*if(selected_acc != ''){
            acc = [SELECT id, name FROM Account WHERE id =: selected_acc LIMIT 1];
        }*/               
        //String encoded = EncodingUtil.urlEncode(rec.Name+'&cas3='+conList.Name+'&cas3_lkid='+conList.id+'&cas4='+conList.Account.Name+'&cas4_lkid='+conList.AccountId+'&CF00N9000000DhnUS='+conSite.Name+'&CF00N9000000DhnUS_lkid='+conSite.id+'&retURL=%2F500%2Fo', 'UTF-8');
        if(selected_con == ''){   
            pageRefone =  new pagereference('/500/e?nooverride=1&cas4='+acc.Name+'&cas4_lkid='+acc.Id+'&CF00N9000000DhnUS='+ConSite.Name+'&CF00N9000000DhnUS_lkid='+ConSite.id+'&retURL=%2F500%2Fo');
            pageRef = pageRefone;
        }else{
            pageReftwo = new pagereference('/500/e?nooverride=1&RecordType='+rec.id+'&cas3='+conList.Name+'&cas3_lkid='+conList.id+'&cas4='+accName.Name+'&cas4_lkid='+accName.Id+'&CF00N9000000DhnUS='+conSite.Name+'&CF00N9000000DhnUS_lkid='+conSite.id+'&retURL=%2F500%2Fo');
            pageRef = pageReftwo;
        }
        return pageRef;
    }
}