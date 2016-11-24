public class TimeSheetController{
    // Object, List Declaration
    public List<SelectOption> selectMonth{get;set;}
    public List<SelectOption> selectYear{get;set;}
    public List<SelectOption> selectContact{get;set;}
    public List<Date> dateList{get;set;}
    public Integer selectedMonth{get;set;}
    public Integer selectedYear{get;set;}
    public String selectedContact{get;set;}
    private Date startDate;
    private Date endDate;
    public List<ContactProject__c> showProjectList{get;set;}
    public List<Holiday__c> holidayList{get;set;}
    
    // Constructor
    public TimeSheetController(){
        selectMonth = new List<SelectOption>();
        selectYear = new List<SelectOption>();
        selectContact = new List<SelectOption>();
        showProjectList = new List<ContactProject__c>();
        holidayList = new List<Holiday__c>();
        dateList = new List<Date>();
        // Get all contacts list
        selectContact.add(new SelectOption('None', '---None---'));
        for(Contact con : [SELECT id, Name FROM Contact LIMIT 1000]){
            selectContact.add(new SelectOption(con.id, con.Name));
        }
        
        // Fill month list
        selectMonth.add(new SelectOption('None', '---None---'));
        selectMonth.add(new SelectOption('1', 'Jan'));
        selectMonth.add(new SelectOption('2', 'Feb'));
        selectMonth.add(new SelectOption('3', 'Mar'));
        selectMonth.add(new SelectOption('4', 'Apr'));
        selectMonth.add(new SelectOption('5', 'May'));
        selectMonth.add(new SelectOption('6', 'Jun'));
        selectMonth.add(new SelectOption('7', 'July'));
        selectMonth.add(new SelectOption('8', 'Aug'));
        selectMonth.add(new SelectOption('9', 'Sept'));
        selectMonth.add(new SelectOption('10', 'Oct'));
        selectMonth.add(new SelectOption('11', 'Nov'));
        selectMonth.add(new SelectOption('12', 'Dec'));
        
        // Fill year list
        selectYear.add(new SelectOption('None', '---None---'));
        for(Integer i=1980;i<2050;i++){
            selectYear.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        
    }
    
    public void CreateCal(){
        system.debug('#### Month value==' + selectedMonth);
        system.debug('#### Year value==' + selectedYear);
        system.debug('#### Contact value==' + selectedContact);
        dateList.clear();
        
        startDate = Date.newInstance(selectedYear,selectedMonth,1);
        endDate = startDate.addMonths(1);
        for(;startDate<endDate; startDate = startDate.addDays(1)){
            dateList.add(startDate);
        }
        System.debug('########### > '+dateList);
        
        showProjectList = [SELECT id, Name, Contact__c, Work_Day__c, Working_Hours__c FROM ContactProject__c WHERE Contact__c =: selectedContact And CALENDAR_Month(Work_Day__c) =: selectedMonth And CALENDAR_YEAR(Work_Day__c) =: selectedYear];
        system.debug('#### Contact Projects==' + showProjectList);
        
        holidayList = [SELECT id, Name, Start_Date__c, End_Date__c, Contact__c FROM Holiday__c WHERE Contact__c =: selectedContact];
        
    }
}