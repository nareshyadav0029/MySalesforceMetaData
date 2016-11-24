public class TimetrackingController{
    
    ///// object lists
    
    public List<User> user_list{get;set;}
    public List<User_Project__c> project_list{get;set;}
    public List<User_Task__c> task_list{get;set;}
    
    public String selected_user{get;set;}
    public String selected_project{get;set;}
    public String selected_task{get;set;}
    
    public List<selectOption> selectuser{get;set;}
    public List<selectOption> selectproject{get;set;}
    public List<selectOption> selecttask{get;set;}
    
    public Boolean flag{get;set;}
    public Boolean flag1{get;set;}
    public Boolean stop_flag{get;set;}
    
    //// Constractor
    public TimetrackingController(){
        flag = false;
        flag1 = true;
        stop_flag = false;
        
        user_list = [SELECT id, name FROM USER WHERE isActive = true];
        project_list = [SELECT id, name,(SELECT id, name, Task_Notes__C FROM user_tasks__r WHERE isActive__c = true) FROM User_Project__c WHERE isActive__c = true];
        task_list = [SELECT id, name, Task_Notes__C FROM User_Task__c WHERE isActive__c = true];
    }
    
    //// Function for start the task
    
    public void starttask(){
        selectuser = new List<selectOption>();
        if(flag == false && flag1 == true){
            flag = true;
            flag1 = false;
        }
        
        for(User u : user_list){
            selectuser.add(new SelectOption(u.id, u.name));
        }
        selectuser.sort();
        selectuser.add(0,new SelectOption('null', '-------Select User-------'));
        system.debug('####'+selected_user);
    }
    
    //// Function for start the task
    
    public pagereference startProject(){
        return new pagereference('/apex/Timetracking').setRedirect(true);
    }
    
    public void filllist(){ 
        selectproject = new List<selectOption>();
        selecttask = new List<selectOption>();
        
        for(User_Project__c project : project_list){
            selectproject.add(new SelectOption(project.id, project.name));
        }
        selectproject.sort();
        selectproject.add(0,new SelectOption('null', '-------Select Project-------'));
        system.debug('####'+selected_project);
        
        for(User_Task__c task : task_list){
            selecttask.add(new SelectOption(task.id, task.name));
        }
        selecttask.sort();
        selecttask.add(0,new SelectOption('null', '-------Select Task-------'));
        system.debug('####'+selected_task);
    }
    
    //// Function for Stop the task
    
    public void stoptask(){
        selectuser = new List<selectOption>();
        if(stop_flag == false && flag1 == true){
            stop_flag = true;
            flag1 = false;
        }
        for(User u : user_list){
            selectuser.add(new SelectOption(u.id, u.name));
        }
        selectuser.sort();
        selectuser.add(0,new SelectOption('null', '-------Select User-------'));
        system.debug('####'+selected_user);      
    }
    
    //// Function for Stop the task
    
    public void cancel(){
         if(flag1 == false && flag == true){
            flag1 = true;
            flag = false;
        }else{
            flag1 = true;
            stop_flag = false;
        } 
    }
    
    //// Function for Stop the task
    
    public pagereference ok(){
        return new pagereference('/apex/Timetracking').setRedirect(true);
    }
}