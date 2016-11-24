public class ModelsearchController{
    public List<Contact> contacts{get;set;}
    public String firstname{get;set;}
    public List<InnerModelsearch> modelsearch{get;set;}
    public ModelsearchController(){
        contacts = new List<Contact>();
        modelsearch = new List<InnerModelsearch>();
        contacts = [select firstname , lastname , email , phone from Contact];
        
        // Fill InnerModelsearch Class
        
        integer i=0;
        for(Contact con : contacts){
            i++;
            InnerModelsearch innermodel = new InnerModelsearch();
            innermodel.sno = i;
            innermodel.con = con;
            modelsearch.add(innermodel);  
        }
        
    }
    public void Modelsearch(){
         modelsearch.clear();
         contacts.clear();
        String fname = firstname+'%';
        if(firstname !=null){
            contacts = [select firstname , lastname , email , phone from Contact where firstname like :fname ];
        }
        integer i=0;
        for(Contact con : contacts){
            i++;
            InnerModelsearch innermodel = new InnerModelsearch();
            innermodel.sno = i;
            innermodel.con = con;
            modelsearch.add(innermodel);  
        }
        
    }
    public class InnerModelsearch{
        public integer sno{get;set;}
        public Contact con{get;set;}
    
    }
}