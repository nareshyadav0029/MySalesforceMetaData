@isTest
public class DailyLeadProcessorTest{
    public static String CRON_EXP = '0 0 1 * * ?';
    @isTest
    private static void unitTest(){
        
        List<Lead> lstLead = new List<Lead>();
        for(Integer i=0;i<200;i++){
            lstLead.add(new Lead(LastName = 'Test '+i, Company='TestCom '+i, Status='Open - Not Contacted'));
        }
        
        insert lstLead;
        
        Test.startTest();
            System.schedule('ScheduledApexTest', CRON_EXP, new DailyLeadProcessor());
            //DailyLeadProcessor DL = new DailyLeadProcessor();
        Test.stopTest();
    }
}