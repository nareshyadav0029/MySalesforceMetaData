public class TimeAndMatController{
    public Milestone__c mile_name{get;set;}
    public List<Project__c> project_list{get;set;}
    public String url_Id{get;set;}
    public String url_Type{get;set;}
    public String Page_instructions{get;set;}
    public TimeAndMatController(){
        mile_name = new Milestone__c();
        project_list = new List<Project__c>();
        url_Id = ApexPages.currentPage().getParameters().get('id');
        url_Type = ApexPages.currentPage().getParameters().get('type');
        project_list = [SELECT id, name, Previous_Billing_Milestone__c, Project_Manager__c, End_Date__c, Start_Date__c, Created_Date__c FROM Project__c];
        
        if(url_Type == 'tmbill'){
            Page_instructions = 'This screen allows a project manager to generate a billing milestone based on approved timecards on a project. The table below shows all approved timecards splits that have not been included in a previous T&M billing milestone. Select the timecard splits to include and click Create Billing Milestone.';
        }
        else{
            Page_instructions = 'This screen allows a project manager to generate a billing milestone based on approved billable expenses on a project. The table below shows all approved billable expenses that have not been included in a previous Expense billing milestone. Select the expenses to include and click Create Billing Milestone.';
        }
        
        
    }   
}