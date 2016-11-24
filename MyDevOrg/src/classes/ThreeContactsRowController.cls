public class ThreeContactsRowController{
    public List<Contact> contact{get;set;}
    public List<ModelRow> modelrow{get;set;}
    public ThreeContactsRowController(){
        modelrow = new List<ModelRow>();
        contact = [select firstname , lastname , email from Contact];
        integer i=1;
        for(Contact con : contact){
            ModelRow modelcon = new ModelRow();
            modelcon.s_no = i;
            modelcon.contacts = con;
            modelrow.add(modelcon);
            if(math.mod(modelrow.size() , 3)==0){
            }
            i++;
        }
        //System.debug('####'+size);
    }
    public class ModelRow{
        public integer s_no{get;set;}
        public Contact contacts{get;set;}
    }
}