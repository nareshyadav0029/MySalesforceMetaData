public class Austral_PrecastController{
    public Date start_date{get;set;}
    public Date end_date{get;set;}
    public Panel__c date_list{get;set;}
    public List<Date> date_diff{get;set;}
    public Map<String, Map<Date, Integer>> drawingDate{get;set;}
    public Map<String, Map<Date, Integer>> productionDate{get;set;}
    public Map<String, Map<Date, Integer>> installDate{get;set;}
    public List<Job__c> job_list{get;set;}
    public List<ModalList> modals{get;set;}
    public String jID{get;set;}
    public String jDate{get;set;}
    public Date realDate{get;set;}
    public List<Panel__c> updateList{get;set;}
    
    ////// Constrauctor //////
    
    public Austral_PrecastController(){
        date_list = new Panel__c();
        updateList = new List<Panel__c>();
        modals = new List<ModalList>();
        drawingDate = new Map<String, Map<Date, Integer>>();
        productionDate = new Map<String, Map<Date, Integer>>();
        installDate = new Map<String, Map<Date, Integer>>();
        
        job_list = [select id, Job_Name__c, (select id, Drawing_Date__c, Production_Date__c, Install_Date__c, Job_LookUp__c from Panels__r) from job__c];
        for(Job__c job : job_list){
            Map<Date, Integer> drawing_temp = new Map<Date, Integer>();
            for(Panel__c panel : job.panels__r){
                Integer count = drawing_temp.get(panel.Drawing_Date__c);
                if(count == null){
                    count = 0;
                }
                count++;
                drawing_temp.put(panel.Drawing_Date__c, count);
            }
            drawingDate.put(job.id, drawing_temp);
            
            Map<Date, Integer> production_temp = new Map<Date, Integer>();
            for(Panel__c panel : job.panels__r){
                Integer count = production_temp.get(panel.Production_Date__c);
                if(count == null){
                    count = 0;
                }
                count++;
                production_temp.put(panel.Production_Date__c, count);
            }
            productionDate.put(job.id, production_temp);
            
            Map<Date, Integer> install_temp = new Map<Date, Integer>();
            for(Panel__c panel : job.panels__r){
                Integer count = install_temp.get(panel.Install_Date__c);
                if(count == null){
                    count = 0;
                }
                count++;
                install_temp.put(panel.Install_Date__c, count);
            }
            installDate.put(job.id, install_temp);  
        }
        
    }
 
//////  VIEW FUNCTION   //////    
    
    public void View(){
        date_diff = new List<Date>();
        modals.clear();
        date_diff.clear();
        start_date = date_list.Start_Date__c;
        end_date = date_list.End_Date__c;
        if(start_date <= end_date){
            while(start_date <= end_date){
                date_diff.add(start_date);
                start_date = start_date.addDays(1);
            }
        }else{
            if(start_date == null && end_date == null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Fill The Dates !!!');
                ApexPages.addMessage(myMsg);
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Start Date Should Be Less Than End Date !!!');
                ApexPages.addMessage(myMsg);
            }
        } 
        
        for(Job__c job : job_list){
            Map<Date, Integer> drawingTemp = new Map<Date, Integer>();
            drawingTemp = drawingDate.get(job.id);
            
            Map<Date, Integer> productionTemp = new Map<Date, Integer>();
            productionTemp = productionDate.get(job.id);
            
            Map<Date, Integer> installTemp = new Map<Date, Integer>();
            installTemp = installDate.get(job.id);
            
            ModalList modal = new ModalList();
            modal.drawingCount = new List<ModalTemp>();
            modal.productionCount = new List<ModalTemp>();
            modal.installCount = new List<ModalTemp>();
            
            
            for(Date d : date_diff){
                ModalTemp temp = new ModalTemp();
                temp.Hdate = d;
                temp.drawing = drawingTemp.get(d);
                modal.drawingCount.add(temp);
            }
            for(Date d : date_diff){
                ModalTemp temp = new ModalTemp();
                temp.Hdate = d;
                temp.production = productionTemp.get(d);
                modal.productionCount.add(temp);
            }
            for(Date d : date_diff){
                ModalTemp temp = new ModalTemp();
                temp.Hdate = d;
                temp.install = installTemp.get(d);
                modal.installCount.add(temp);
            }
            
            modal.jobId = job.id;
            modal.jobName = job.Job_Name__c;
            modals.add(modal);
        }      
    }

    public void fillPopup(){
        updateList.clear();
        realDate = date.valueOf(jDate);
        for(Job__c job : job_list){
            if(job.id == jId){
                for(Panel__c panel : job.panels__r){
                    Panel__c p = new Panel__c(Job_LookUp__c = panel.Job_LookUp__c);
                    p.id = panel.id;
                    if(panel.Drawing_Date__c == realDate){
                        p.Drawing_Date__c = panel.Drawing_Date__c;
                    }
                    if(panel.Production_Date__c == realDate){
                        p.Production_Date__c = panel.Production_Date__c;
                    }
                    if(panel.Install_Date__c == realDate){
                        p.Install_Date__c = panel.Install_Date__c;
                    }
                    updateList.add(p);
                }
            }
        }      
    }
 
//////   Clear POPUP   ///////

    public void clear(){
        updateList.clear();
    }    
        
///////  UPDATE FUNCTION  //////

    public pagereference popupdate(){
        update updateList;
        return new pagereference('/apex/Austral_Precast').setRedirect(true);
    }    
    
//////   MODAL CLASS   //////    
    public class ModalList{
        public String jobId{get;set;}
        public String jobName{get;set;}
        public List<ModalTemp> drawingCount{get;set;}
        public List<ModalTemp> productionCount{get;set;}
        public List<ModalTemp> installCount{get;set;}
    }
    
    public class ModalTemp{
        public Integer drawing{get;set;}
        public Integer production{get;set;}
        public Integer install{get;set;}
        public Date Hdate{get;set;}
    }
}