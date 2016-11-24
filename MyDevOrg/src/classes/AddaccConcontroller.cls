/*
           Date - 22/01/2015
     Class Name - AddaccConcontroller
      Page Name - AddaccContact
    Description - Add account and contact on button click.
    
*/

public class AddaccConcontroller{
    
    public List<Modalaccount> modals{get;set;}
    public integer modalaccountindex {get;set;}
    public integer modalcontactindex {get;set;}
    public List<Account> acc_list{get;set;}
    public List<Contact> con_insertlist{get;set;}
    public Integer accsize{get;set;}
    
    ////   CONSTRACTOR
    
    public AddaccConcontroller(){
        acc_list = new List<Account>();
        modals = new List<Modalaccount>();
        con_insertlist = new List<Contact>();
        Modalaccount modal = new Modalaccount();
        accsize = 0;
        modal.acc = new Account();
        modal.consize = 0;
        modals.add(modal);     
    }
    
    ////   FUNCTION FOR ADD NEW ROW FOR ACCOUNT
    
    public void addaccount(){
        Modalaccount modal = new Modalaccount();
        modal.acc = new Account();
        modal.consize = 0;
        modals.add(modal);
        accsize = modals.size(); 
    }
     
    ////   FUNCTION FOR ADD NEW ROW FOR CONTACT
    
    public void addcontact(){     
        Modalaccount modal = modals.get(modalaccountindex); 
        modal.con_list.add(new contact());
        modals.get(modalaccountindex).consize =  modals.get(modalaccountindex).con_list.size();
    }
    
    ////   FUNCTION FOR DELETE ACCOUNT
    
    public void delacc(){
        if(modals.size()>1){
            modals.remove(modalaccountindex);
            accsize = modals.size();
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'You can not delete it !!!');
            ApexPages.addMessage(myMsg);
        }
    }
    
    ////   FUNCTION FOR DELETE CONTACTS
    
    public void delcon(){
        modals.get(modalaccountindex).con_list.remove(modalcontactindex);
        modals.get(modalaccountindex).consize = modals.get(modalaccountindex).con_list.size();
    }
    
    ////   FUNCTION FOR INSERT ACCOUNTS AND CONTACTS
    
    public pagereference insertAccCon(){
        for(modalaccount mod : modals){
            for(contact con : mod.con_List){
                con.Account = mod.acc;   
                con_insertlist.add(con);             
            }
            acc_list.add(mod.acc);
        }        
        if(acc_list.size()>0){
            insert acc_list;
        }
        for(contact c : con_insertlist){
            c.accountid = c.account.id;
        }
        if(con_insertlist.size()>0)
            insert con_insertlist;
        return new pagereference('/apex/AddaccContact').setRedirect(true);
    }
        
    ////   MODAL CLASS
    
    public class Modalaccount{
        public Account acc{get;set;}
        public List<Contact> con_list{get;set;}
        public Integer consize{get;set;}
        
        public Modalaccount(){
            con_list = new List<contact>();
        }
    }
    
}