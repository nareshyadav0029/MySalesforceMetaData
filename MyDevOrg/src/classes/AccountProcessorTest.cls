@isTest
public class AccountProcessorTest{
    @isTest
    private static void unitTest(){
        List<Id> accList = new List<Id>();
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
        accList.add(acc.Id);
        Account acc1 = new Account(Name = 'TestAccount1');
        insert acc1;
        accList.add(acc1.Id);
        Test.startTest(); 
            AccountProcessor.countContacts(accList);
        Test.stopTest();
    }
}