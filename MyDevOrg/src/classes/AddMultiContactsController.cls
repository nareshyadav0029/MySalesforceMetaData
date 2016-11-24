public class AddMultiContactsController{
    public List<ModelContact> contactmodel{get;set;}
    public String RowNum{get;set;}
    String accid{get;set;}
    public AddMultiContactsController(){
        accid = ApexPages.currentPage().getParameters().get('accid');
        RowNum = '0';
        contactmodel = new List<ModelContact>();
        ModelContact mcontact = new ModelContact();
        mcontact.index = contactmodel.size();
        mcontact.contact = new Contact();
        contactmodel.add(mcontact);
    }
    
    public void AddRow(){
        List<ModelContact> modelContact = new List<ModelContact>();
        modelContact = contactmodel;
        ModelContact mcontact = new ModelContact();
        mcontact.index = contactmodel.size();
        mcontact.contact = new Contact();
        modelContact.add(mcontact);
        contactmodel = modelContact;
    }
    
    public void DelRow(){
       integer index = Integer.ValueOf(RowNum);
       integer i=0;
       List<ModelContact> cModel = new List<ModelContact> ();
       for(ModelContact mcon : contactmodel){
           if(mcon.index != index){
               ModelContact mc = new ModelContact();
               mc.index = i;
               mc.contact = mcon.contact;
               cModel.add(mc);
               i++;
           }
       }
       contactmodel = cModel;
    }
    
    public pagereference Save(){
        List<Contact> con = new List<Contact>();
        for(ModelContact cmodel : contactmodel){
            if(cModel.contact.lastname != null){
                cModel.contact.AccountId = (ID)accid;
                con.add(cModel.contact);
            }
        }
        insert con;
         return new pagereference('/'+accid);
    }
    
    public class ModelContact{
        public integer index{get;set;}
        public Contact contact{get;set;}
    }  
}