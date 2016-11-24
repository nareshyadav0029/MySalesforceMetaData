public class CorpsSiteController{
    public Contact contact{get;set;}
    public CorpsSiteController(){
        contact = new Contact();
    }
    
    public pagereference Save(){
        Account Acc;
        try{
            Acc = [select id, name from Account where name='CLOUD' limit 1];
        }catch(Exception e){
            Acc = new Account();
            Acc.name = 'CLOUD';
            insert Acc;
        }
        contact.AccountId = Acc.id;
        insert contact;
        contact = null;
        contact = new Contact();
        return new pagereference('/apex/CorpsSite2');
    }
}