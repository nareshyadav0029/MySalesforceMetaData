@isTest
public class LeadProcessorTest{
    @isTest
    private static void unitTest(){
        List<Lead> lList = new List<Lead>();
        
        for(Integer i=0;i<200;i++){
            lList.add(new Lead(LeadSource='Dreamforce', LastName = 'Test', Company = 'TestCom'));
        }
        insert lList;
        
        Test.startTest();
        LeadProcessor LS = new LeadProcessor();
        Id batchId = Database.executeBatch(LS);
        Test.stopTest();
    }
}