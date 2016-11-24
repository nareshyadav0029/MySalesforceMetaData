public class TreeViewController{
    public List<Account> accConList{get;set;}
    
    public TreeViewController(){
        accConList = [SELECT id, Name, (SELECT id, Name From Contacts) from Account];
    }
    
}