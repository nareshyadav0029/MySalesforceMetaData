public class AddRecordController{
    public Sobject obj{get;set;}
    List<String> fields {get;set;}
    public List<Modalfield> mfield {get;set;}
    public String f{get;set;}
    
    /////// Constructor///////
    
    public AddRecordController(){
        mfield= new List<Modalfield>();
        fields = new List<String>();
        String objecttype = ApexPages.CurrentPage().getParameters().get('objname');
        f = ApexPages.CurrentPage().getParameters().get('fields');
        fields = f.split(',') ;
        for(String fld : fields){
            Modalfield mf = new Modalfield();
            mf.label = Schema.getGlobalDescribe().get(objecttype).getDescribe().fields.getmap().get(fld).getDescribe().getLabel();
            mf.name = fld;
            mfield.add(mf);
        }
        obj = createSobject(objecttype);
    }
    
    // For Getting Sobject 
    public Sobject createSobject(String objectname){
        Schema.SobjectType targetObject = Schema.getGlobalDescribe().get(objectname);
        if(targetObject == null){
        
        }
        return targetObject.newSobject();
    }
    public class Modalfield{
        public String label{get;set;}
        public String name{get;set;}
    }
    public pagereference save(){
        insert obj;
        return new pagereference('/'+obj.id);
    }
}