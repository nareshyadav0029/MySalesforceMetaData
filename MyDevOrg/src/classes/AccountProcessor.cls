public class AccountProcessor{
    
    @future
    public static void countContacts(List<Id> AccountIds){
        List<Account> accToUpdate = new List<Account>();
        if(AccountIds.size()>0){
            for(Account acc : [SELECT Id, Number_of_Contacts__c, (SELECT Id, AccountId FROM Contacts) FROM Account WHERE Id IN : AccountIds]){
                acc.Number_of_Contacts__c = acc.Contacts.size()>0 ? acc.Contacts.size() : 0;
                accToUpdate.add(acc);
            }
        }
        
        if(accToUpdate.size()>0){
            update accToUpdate;
        }
    }
}