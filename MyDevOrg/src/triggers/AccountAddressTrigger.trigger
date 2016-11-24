trigger AccountAddressTrigger on Account (before insert, before update){
    for(Account acc : Trigger.new){
        if(acc.BillingPostalCode != null && acc.Match_Billing_Address__c){
            acc.ShippingPostalCode = acc.BillingPostalCode;
        }
    }

}