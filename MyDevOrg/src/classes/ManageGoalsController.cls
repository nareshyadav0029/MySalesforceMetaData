/*
             Date : 13/03/2015
            Class : ManageGoalsController
             Page : ManageGoals
      Description : This class used to Manage goals on related contact.
*/

public class ManageGoalsController{
    public String conId{get;set;}
    public List<Goal__c> goalList{get;set;}
    public List<Modalgoal> mgList{get;set;}
    public Integer goalIndex{get;set;}
    public Integer taskIndex{get;set;}
    // Constractor
    public ManageGoalsController(){
        conId = ApexPages.CurrentPage().getParameters().get('id');
        mgList = new List<Modalgoal>();
        system.debug('####conId'+conId);        
        
        for(Goal__c g : [select id,name,goal__c,(select id,name,status__c, subject__c, due_date__c from GoalTasks__r) from Goal__c WHERE Contact__c =: conId order by CreatedDate desc]){
            Modalgoal mg = new Modalgoal();
            mg.gObj = g;
            mg.taskList.addall(g.GoalTasks__r);
            mgList.add(mg);
        }
    }
    
    // Function to Add Goal
    
    public void addgoal(){
        Modalgoal mg = new Modalgoal();
        mg.gObj = new Goal__c();
        mg.taskSize = 0;
        mgList.add(mg);
    }
    
    // Function to insert the Goal
    
    public void insertGoal(){
        List<Goal__c> insList = new List<Goal__c>();
        Goal__c insertGoal = new Goal__c();
        for(Modalgoal mg : mgList){
            if(mg.gObj.Goal__c != '' || mg.gObj.Goal__c != null){
                insertGoal.Goal__c = mg.gObj.Goal__c;
                insertGoal.contact__c = conId;
                insList.add(insertGoal);
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Invalid Email !!!');
                ApexPages.addMessage(myMsg);
            }
        }
        if(insList.size()>0){
            insert insList;
        }
    }
    
    // Function for Add Tasks
    
    public void addTask(){
        Modalgoal mg = mgList.get(goalIndex);
        mg.taskList.add(new Goal_Task__c());
        mgList.get(goalIndex).taskSize = mgList.get(goalIndex).taskList.size();
    }
    
    // function for insert task
    
    public void insertTask(){
        List<Goal_Task__c> insertTask = new List<Goal_Task__c>();
        for(Modalgoal mg : mgList){
            for(Goal_Task__c t : mg.taskList){
                t.Goal__c = mg.gObj.id;
                insertTask.add(t);
            }
        }
        if(insertTask.size()>0){
            insert insertTask;
        }
    }
    
    // Function for delete the Tasks
    
    public void delTask(){
        mgList.get(goalIndex).taskList.remove(taskIndex);
        mgList.get(goalIndex).taskSize = mgList.get(goalIndex).taskList.size();
    }
    
    // Function to edit Goal
    
    public void editGoal(){
        mgList.get(goalIndex).flag = true;
    }
    
    // Update the Goal
    
    public void updateGoal(){
    }
    
    
    // Modal Class
    
    public class Modalgoal{
        public Goal__c gObj{get;set;}
        public List<Goal_Task__c> taskList{get;set;}
        public Integer taskSize{get;set;}
        public Boolean flag{get;set;}
        
        public Modalgoal(){
            gObj = new Goal__c();
            taskList = new List<Goal_Task__c>();
            flag =  false;
        } 
    }
}