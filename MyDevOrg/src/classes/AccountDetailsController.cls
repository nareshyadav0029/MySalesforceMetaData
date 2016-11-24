public class AccountDetailsController{
    public List<Account> accountdetail{get;set;}
    public AccountDetailsController(){
        accountdetail = [select Name, AccountNumber, Phone, Website from Account];
    }
    
    public pagereference Redirect(){
        PageReference pgref = new PageReference('/apex/AddMultiContacts');
        return pgref;
    }
}