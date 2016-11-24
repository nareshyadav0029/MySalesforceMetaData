public class Ass7AllSObjectsController{
    public List<SelectOption> allsobjects{get;set;}
    public Map<String, Map<String, schema.SobjectField>> fieldmap;
    public String selected_object{get;set;}
    public SObject obj{get;set;}
    public List<Modalclass> mclass{get;set;}
    public List<Allfields> allf{get;set;}
    
    ////// Constractor//////////
    
    public Ass7AllSObjectsController(){
    
        //////Memory Alloction/////////
    
        allsobjects = new List<SelectOption>();
        fieldmap = new Map<String, Map<String, schema.SobjectField>>();
        
        mclass = new List<Modalclass>();
        allf = new List<Allfields>();
        
        List<Schema.SobjectType> allobject = Schema.getGlobalDescribe().values();
        for(Schema.SobjectType sobj : allobject){
            if(sobj.getDescribe().isCreateable()){
                allsobjects.add(new SelectOption(sobj.getDescribe().getname(),sobj.getDescribe().getLabel()));
                //fieldmap = sobj.getDescribe().fields.getmap();
                fieldmap.put(sobj.getDescribe().getname(),sobj.getDescribe().fields.getmap());
            }  
        }
        allsobjects.sort();
        allsobjects.add(0,new SelectOption('null', '---None---'));
    }
    
    ////////Modal Classes///////////
    
    public class Modalclass{
            public String Label{get;set;}
            public String name{get;set;}
            public String fieldtype{get;set;}
        }
        
        public class Allfields{
            public List<SelectOption> allfields{get;set;}
            public String fieldtype{get;set;}
            public String selected_field{get;set;}
            //public Object defaultvalue{get;set;}
            public String label{get;set;}
        }
    
    ////// Function That Return Target Object/////////
    
    public sObject createObject(String typeName) {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
        if (targetType == null) {
            // throw an exception
        }
        
        // Instantiate an sObject with the type passed in as an argument
        //  at run time.
        return targetType.newSObject(); 
    }
    
    /////Function For Get All Fields Of Selected Object//////////
    
    public void getfields(){
        mclass = new List<Modalclass>();
        allf = new List<Allfields>();
        obj = createObject(selected_object);
        List<SelectOption> allfield = new List<SelectOption>();
        Allfields afield = new Allfields();
        for(String fields : fieldmap.get(selected_object).keySet()){
            DescribeFieldResult dfr = fieldmap.get(selected_object).get(fields).getDescribe();
             if(dfr.isNillable()== false && dfr.isDefaultedOnCreate() == false){
                 Modalclass modalc = new Modalclass();
                 modalc.name = fields;
                 modalc.fieldtype = dfr.getType().name();
                 modalc.Label = dfr.getLabel();
                 mclass.add(modalc);
             }else if(dfr.isDefaultedOnCreate() == false ){
                 allfield.add(new SelectOption(fields,dfr.getLabel()));
                 afield.selected_field = fields;
                 afield.label = dfr.getLabel();
             }
         }
         allfield.sort();
         afield.allfields = allfield;
         allf.add(afield);
        }
        
        /////Function For Get All Fields Type Of Selected Field//////////
        
        public void getfieldtype(){
           for(Allfields field : allf){
                if(field.selected_field != 'null'){
                    field.fieldtype = fieldmap.get(selected_object).get(field.selected_field).getDescribe().getType().name();
                    field.label= fieldmap.get(selected_object).get(field.selected_field).getDescribe().getlabel();
                }
            }
        }
        
        //////Function For Adding New Row///////
        
        public void AddRow(){
            List<SelectOption> allfield = new List<SelectOption>();
            Allfields afield = new Allfields();
            for(String field : fieldmap.get(selected_object).keySet()){
                DescribeFieldResult dfr = fieldmap.get(selected_object).get(field).getDescribe();
                    if(dfr.isNillable()== false && dfr.isDefaultedOnCreate() == false){
                        continue;
                    }else if(dfr.isDefaultedOnCreate() == false){
                        Boolean flag = false;
                        for(Allfields af : allf){
                            if(af.selected_field == field){
                                flag = true;
                                break;
                            }
                        }
                        if(flag == false){
                              allfield.add(new SelectOption(field,dfr.getLabel()));
                              afield.selected_field = field; 
                              afield.label = dfr.getLabel();
                        }
                    }
            }
            allfield.sort();
            afield.allfields = allfield;
            allf.add(afield);
        }
        
        /////Function For Next Button//////
        
        public pagereference NextPage(){
           
            return new pagereference('/apex/AddRecord');
        } 
        
        //////Function For Insert New Record///////
        
        public pagereference Save(){
            insert obj;
            return new pagereference('/'+obj.id);
        }
  
}