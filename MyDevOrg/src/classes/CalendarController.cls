/*
    Class Name        :    CalendarController
    Date              :    7/01/2016
    Developer Name    :    Naresh
    Description       :    Used to show calendar.
*/

public class CalendarController{ //Class level comments missing
    // Objects and variables declaration
    public List<WeekWrapper> weekList{get;set;}
    private Date startDate;
    public Integer yearVal{get;set;}
    public Integer monthVal{get;set;}
    public String tempHoliday{get;set;}
    public Set<String> holidays{get;set;}
    
    // Constructor
    public CalendarController(){
        weekList = new List<WeekWrapper>();
        holidays = new Set<String>();
    }
    
    // Method to show calendar
    public List<WeekWrapper> getWeek(){ 
        if(check()){
            startDate = Date.newInstance(yearVal,monthVal, 1);
            startDate = startDate.toStartOfWeek();
            holidays.addAll(new Set<String>(tempHoliday.split(',')));
            system.debug('####'+holidays);
            for(Integer i=0;i<6;i++){
                WeekWrapper week = new WeekWrapper();
                List<DayWrapper> tempList = new List<DayWrapper>();
                for(Integer j=1;j<=7;j++){
                    DayWrapper d = new DayWrapper(null,null);
                    if(startDate.month() == monthVal){
                        d = new DayWrapper(startDate, holidays.contains(String.valueOf(startDate.day())));
                    }
                    tempList.add(d);
                    startDate = startDate.addDays(1);
                }
                week.dayList = tempList;
                weekList.add(week);
            }
            return weekList;
        }
        return null;
    }
    
    // Method to check year value month value.
    private boolean check(){
        if(yearVal<1900 || monthVal<1){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Year Or Month !!!');
            ApexPages.addMessage(myMsg);
            return false;
        }
        return true;
    }
    
    // Wrapper class
    public class WeekWrapper{
       public List<DayWrapper> dayList{get;set;}
    }
    
    public class DayWrapper{
        public Date day{get;set;}
        public boolean isHoliday{get;set;}
        
        public DayWrapper(Date d, Boolean isHoliday){
            this.day = d;
            this.isHoliday = isHoliday;
        }
    }
}