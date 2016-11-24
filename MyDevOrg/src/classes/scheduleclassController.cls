public class scheduleclassController implements Schedulable{
    
    public void execute(SchedulableContext sc){
        try 
        {
            // Abort the job you have just scheduled via Setup 
            CronTrigger ct = [SELECT id,CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :SC.getTriggerId()];
            if(ct != null){
                System.abortJob(ct.Id);
            }
        }catch(Exception e){
            System.debug('No jobs scheduled ' + e.getMessage()); 
        }
        batchAccountUpdate b= new batchAccountUpdate();
        Database.executebatch(b);
         
    }
}