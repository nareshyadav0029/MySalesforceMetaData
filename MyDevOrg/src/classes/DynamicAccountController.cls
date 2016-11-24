public class DynamicAccountController{
    //  Object declaration
    public Account account{get;set;}
    
    //  Constructor
    public DynamicAccountController(ApexPages.StandardController controller){
        String accountId = ApexPages.CurrentPage().getParameters().get('id');
        if(string.isNotBlank(accountId)){
            for(Account acc : [SELECT Name, BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode
                               From Account WHERE Id =: accountId]){
               account = acc;                    
            }
        }else{
            account = new Account();
        }
    }
}