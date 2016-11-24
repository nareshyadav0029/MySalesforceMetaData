global with sharing class AccountRemoter {

    public String accountName { get; set; }
    public static Account account { get; set; }
    public static List<Account> accountList { get; set; }
    public AccountRemoter(){ 
        // empty constructor
    }
    
    /*global static List<Account> allAccounts() {
        account = [SELECT Id, Name, Phone, Fax, Website FROM Account Limit 100];
        return accountList;
    }*/ 
    
    @RemoteAction
    global static Account getAccount(String accountName) {
        account = [SELECT Id, Name, Phone, Fax, Website FROM Account WHERE Name = :accountName];
        return account;
    }
}