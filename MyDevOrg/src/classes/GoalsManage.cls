public class GoalsManage{
    public List<Goal__c> goalList {get;set;}
    public String conId{get;set;}
    public List<goalModelClass> gmodel{get;set;}
    public Goal__c goal{get;set;}
    public Goal_Task__c task {get;set;} 
    public String goalid {get;set;}
    
    public GoalsManage(){
        goalList = new List<Goal__c>();
        gmodel = new  List<goalModelClass>();
        goal = new Goal__c();
        task = new Goal_Task__c();
        conId=ApexPages.currentPage().getParameters().get('id'); 
        goalList = [select id, Contact__c , goal__c , (select id , Subject__c, Status__c, Due_Date__c from GoalTasks__r)from goal__c where Contact__c =: conId order by createddate desc]; 
        for(Goal__c g : goalList ){
            goalModelClass gl = new goalModelClass();
            gl.goalModel = g;
            gl.taskModel = new  List<Goal_Task__c>();
            for(Goal_Task__c gt: g.GoalTasks__r){
                gl.taskModel.add(gt);
            }
            gmodel.add(gl);
        }
    }
    public pageReference save(){
          list<Goal_Task__c> mTmp =new list<Goal_Task__c>();
          
         for(goalModelClass pm : gmodel){            
          for(Goal_Task__c m: pm.taskModel){
               if(m.Subject__c!=''){
                   mTmp.add(m);
               }
           }            
       }
        upsert mTmp;
        System.debug('@@@@@'+ mTmp );
        return new pageReference('/apex/ManageGoals?id='+ conId).setRedirect(true);
    }
    public pageReference addgoal(){
        goal.Contact__c  = conId;
        insert goal;
        return new pageReference('/apex/ManageGoals?id='+ conId).setRedirect(true);
        
    }
    
    public pageReference addtask(){
        task.Goal__c = goalid;
        insert task;
        return new pageReference('/apex/ManageGoals?id='+ conId).setRedirect(true);
    }
    public class goalModelClass{
        public Goal__c goalModel{get;set;}
        public List<Goal_Task__c> taskModel{get;set;}
        
        public goalModelClass(){
            goalModel = new Goal__c();
            taskModel = new List<Goal_Task__c>();
        } 
   }
        
}