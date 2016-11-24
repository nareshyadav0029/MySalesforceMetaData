public class AggregateQueryController{
    public List<ModelClass> StudentCount{get;set;}
    
    public AggregateQueryController(){
        StudentCount = new List<ModelClass>();
        List<aggregateResult> result = [select count(id) scount , class__c classname from student__c group by class__c];
        
        for(aggregateResult obj : result){
            ModelClass model = new ModelClass((integer)obj.get('scount') , (String)obj.get('classname'));
            StudentCount.add(model);
        }
        
    }
    
    public class ModelClass{
        public integer count{get;set;}
        public String classname{get;set;}
        
        public modelclass(Integer c , String n){
            this.count = c;
            this.classname = n;
        }
    }
}