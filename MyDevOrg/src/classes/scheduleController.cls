public class scheduleController{
    public List<ApexClass> classList{get;set;}
    public ApexClass classObj{get;set;}
    public Contact conObj{get;set;}
    public Opportunity oppObj{get;set;}
    public String jobName{get;set;}
    public String className{get;set;}
    public String classId{get;set;}
    public Date sDate{get;set;}
    public Date eDate{get;set;}
    public List<SelectOption> hoursList{get;set;}
    public List<SelectOption> WeekList{get;set;}
    public List<SelectOption> dayList{get;set;}
    public List<SelectOption> weekdayList{get;set;}
    public List<SelectOption> weeknameList{get;set;}
    public Integer selectedTime{get;set;}
    public Integer selectedDay{get;set;}
    public Integer selectedweekDay{get;set;}
    public Integer selectedweekName{get;set;}
    public List<String> selectedWeek {get;set;}
    public Integer weekCount{get;set;}
    
    public scheduleController(){
        selectedWeek = new List<String>();
        classList = new List<ApexClass>();
        classObj = new ApexClass();
        conObj = new Contact();
        oppObj = new Opportunity();
        hoursList = new List<SelectOption>();
        WeekList = new List<SelectOption>();
        dayList = new List<SelectOption>();
        weekdayList = new List<SelectOption>();
        weeknameList = new List<SelectOption>();
        
        for(ApexClass ac : [SELECT id, Name, body FROM ApexClass]){
            if(ac.body.Contains('implements Schedulable')){
                classList.add(ac);
            }
        }
        
        WeekList.add(new SelectOption('1', 'Sunday'));
        WeekList.add(new SelectOption('2', 'Monday'));
        WeekList.add(new SelectOption('3', 'Tuesday'));
        WeekList.add(new SelectOption('4', 'Wednesday'));
        WeekList.add(new SelectOption('5', 'Thursday'));
        WeekList.add(new SelectOption('6', 'Friday'));
        WeekList.add(new SelectOption('7', 'Saturday'));
        
        hoursList.add(new SelectOption('null', '--None--'));
        hoursList.add(new SelectOption('0', '12:00 AM'));
        hoursList.add(new SelectOption('1', '1:00 AM'));
        hoursList.add(new SelectOption('2', '2:00 AM'));
        hoursList.add(new SelectOption('3', '3:00 AM'));
        hoursList.add(new SelectOption('4', '4:00 AM'));
        hoursList.add(new SelectOption('5', '5:00 AM'));
        hoursList.add(new SelectOption('6', '6:00 AM'));
        hoursList.add(new SelectOption('7', '7:00 AM'));
        hoursList.add(new SelectOption('8', '8:00 AM'));
        hoursList.add(new SelectOption('9', '9:00 AM'));
        hoursList.add(new SelectOption('10', '10:00 AM'));
        hoursList.add(new SelectOption('11', '11:00 AM'));
        hoursList.add(new SelectOption('12', '12:00 PM'));
        hoursList.add(new SelectOption('13', '1:00 PM'));
        hoursList.add(new SelectOption('14', '2:00 PM'));
        hoursList.add(new SelectOption('15', '3:00 PM'));
        hoursList.add(new SelectOption('16', '4:00 PM'));
        hoursList.add(new SelectOption('17', '5:00 PM'));
        hoursList.add(new SelectOption('18', '6:00 PM'));
        hoursList.add(new SelectOption('19', '7:00 PM'));
        hoursList.add(new SelectOption('20', '8:00 PM'));
        hoursList.add(new SelectOption('21', '9:00 PM'));
        hoursList.add(new SelectOption('22', '10:00 PM'));
        hoursList.add(new SelectOption('23', '11:00 PM'));
        
        for(Integer i=1;i<=31;i++){
            dayList.add(new SelectOption(string.valueOf(i), string.valueOf(i)));
        }
        dayList.add(new SelectOption('32', 'Last'));
        
        weeknameList.add(new SelectOption('1', 'Sunday'));
        weeknameList.add(new SelectOption('2', 'Monday'));
        weeknameList.add(new SelectOption('3', 'Tuesday'));
        weeknameList.add(new SelectOption('4', 'Wednesday'));
        weeknameList.add(new SelectOption('5', 'Thursday'));
        weeknameList.add(new SelectOption('6', 'Friday'));
        weeknameList.add(new SelectOption('7', 'Saturday'));
        
        weekdayList.add(new SelectOption('1', 'the 1st'));
        weekdayList.add(new SelectOption('2', 'the 2nd'));
        weekdayList.add(new SelectOption('3', 'the 3rd'));
        weekdayList.add(new SelectOption('4', 'the 4th'));
        weekdayList.add(new SelectOption('5', 'the last'));
        
        /*for(ApexClass ac: [SELECT id, name FROM ApexClass]){
            classList.add(ac);
        }*/ 
        
    }
    
    private Boolean check(){
        Boolean flag=true;
        if(jobName != null){
            List<CronTrigger> job = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger where CronJobDetail.Name =: jobName];
            if(job.size()> 0){
                ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'job name already exist.');
                ApexPages.addMessage(message);
                flag=false;
            }
        }
        /*ApexClass ap = [SELECT id, name FROM ApexClass WHERE id =: classId LIMIT 1];
        if(ap.id == classId){
            ApexPages.Message message = new ApexPages.message(ApexPages.severity.ERROR,'This Apex class is already scheduled for execution.');
            ApexPages.addMessage(message);
            flag=false;
        }*/
        return flag;
    }
    
    public pagereference saveweek(){
        sDate = conObj.Birthdate;
        eDate = oppObj.CloseDate;
        weekCount = selectedWeek.size();
        Integer startDate = sDate.Day();
        Integer endDate = eDate.Day();
        system.debug('####'+selectedWeek);
        system.debug('####'+selectedTime);
        system.debug('####'+sDate);
        system.debug('####'+eDate);
        system.debug('####'+classId);
        system.debug('####'+weekCount);
        system.debug('####'+startDate);
        system.debug('####'+endDate);
        system.debug('####'+selectedDay);
        system.debug('####'+selectedweekDay);
        system.debug('####'+selectedweekName);
        
        scheduleclassController sc = new scheduleclassController();
        boolean f=check();
        if(f){
            if(selectedWeek != null){
                if(weekCount == 1){
                    String sche = '0 0 '+selectedTime+' ? * '+weekCount+' *';
                    system.debug('####===>'+sche);
                    system.schedule(jobName, sche, sc);
                }
                if(weekCount !=0 && weekCount != 1){
                    String sche = '0 0 '+selectedTime+' ? * 1-'+weekCount+' *';
                    system.debug('####===>'+sche);
                    system.schedule(jobName, sche, sc);
                }    
            }
            if(selectedDay != null && selectedDay != 32){
                String sche = '0 0 '+selectedTime+' '+selectedDay+' * ? *';
                system.debug('####===>'+sche);
                system.schedule(jobName, sche, sc);
            }
            if(selectedDay == 32){
                String sche = '0 0 '+selectedTime+' L * ? *';
                system.debug('####===>'+sche);
                system.schedule(jobName, sche, sc);
            }
            if(selectedweekDay != null && selectedweekName != null && selectedweekDay != 5){
                String sche = '0 0 '+selectedTime+' ? * '+selectedweekDay+'#'+selectedweekName+' *';
                system.debug('####===>'+sche);
                system.schedule(jobName, sche, sc);
            }
            if(selectedweekDay == 5 && selectedweekName != null){
                String sche = '0 0 '+selectedTime+' ? * '+selectedweekName+'L *';
                system.debug('####===>'+sche);
                system.schedule(jobName, sche, sc);
            }
        }
        

        //return new pagereference('/apex/schedule').setRedirect(true);
        return null;
    }
}