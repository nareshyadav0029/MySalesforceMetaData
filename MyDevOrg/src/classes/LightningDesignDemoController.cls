public class LightningDesignDemoController{
    public List<Account> accList{get;set;}
    public LightningDesignDemoController(){
        accList = new List<Account>();
        accList.add(new Account());
    }
}