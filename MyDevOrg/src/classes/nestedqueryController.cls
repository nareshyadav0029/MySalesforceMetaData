/*
   Name           :    nestedqueryController
   Page           :    nestedquery
   Author         :    Naresh Yadav
   Date           :    24/03/2015
   Descritpion    :    This class used for expand and collapse functionality.
*/


public class nestedqueryController{
  public List<Account> getaccsandtmember(){
      List<Account> accounts = [Select Id,(Select TeamMemberRole, User.Name From Account.AccountTeamMembers), Name, BillingCountry from Account];
      return accounts;
  }
}