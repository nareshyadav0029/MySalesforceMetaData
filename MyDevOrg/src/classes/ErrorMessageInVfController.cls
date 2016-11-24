public with sharing class ErrorMessageInVfController {
    public Account acc{get;set;}
    public ErrorMessageInVfController(ApexPages.StandardController controller) {
        acc = new Account();
    }
 
    public void save(){
      if(acc.name == '' || acc.name == null)
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter Account name'));
 
      if(acc.AccountNumber == '' || acc.AccountNumber == null)
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Account number'));
 
      if(acc.phone == '' || acc.phone == null)
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Account phone'));
 
      if(acc.site == '' || acc.site == null)
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter Account site'));
 
      if(acc.industry == '' || acc.industry == null)
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Please enter Account industry'));
 
    }
}