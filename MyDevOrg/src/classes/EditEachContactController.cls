public class EditEachContactController{
    public List<Contact> Con_list{get;set;}
    public List<ModalEditCon> modaledit{get;set;}
    public String conid{get;set;}
    public EditEachContactController(){
        Con_list = new List<Contact>();
        modaledit = new List<ModalEditCon>();
        conid = ' ';
        Con_list = [select firstname, lastname, email from Contact];
        integer i=1;
        for(Contact con : Con_list){
            ModalEditCon modal = new ModalEditCon();
            modal.s_no = i;
            modal.id = con.id;
            modal.flag = false;
            modal.contact = con;
            modaledit.add(modal);
            i++;
        }
    }
    
    public void Toggle(){
        for(ModalEditCon modal : modaledit){
            if(conid == modal.id){
                modal.flag = true;
            }
        }
    }
    
    public pagereference Save(){
        for(ModalEditCon mcon : modaledit){
            if(mcon.flag == true){
                Contact con = mcon.contact;
                upsert con;
                mcon.flag = false;
            }
        }
        return new pagereference('/apex/EditEachContact');
    }
    
    public class ModalEditCon{
        public integer s_no{get;set;}
        public Contact contact{get;set;}
        public String id{get;set;}
        public Boolean flag{get;set;}
    }
}