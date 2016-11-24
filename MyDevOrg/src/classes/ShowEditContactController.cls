public class ShowEditContactController{
    public Map<id, ModalEditAble> modaledit{get;set;}
    public List<Contact> contact_list{get;set;}
    public ShowEditContactController(){
        modaledit = new Map<id, ModalEditAble>();
        contact_list = new List<Contact>();
        for(Contact con : [select firstname, lastname, UpdateCount__c from Contact]){
            con.UpdateCount__c = con.UpdateCount__c == null ? 0 : con.UpdateCount__c;
            contact_list.add(con);
            ModalEditAble medit = new ModalEditAble();
            medit.fname = con.firstname;
            medit.lname = con.lastname;
            modaledit.put(con.id, medit);
        }
    }
    
    public pagereference UpdateContact(){
        for(Contact con : contact_list){
            ModalEditAble mname = new ModalEditAble ();
            mname = modaledit.get(con.id);
            if(mname.fname != con.firstname || mname.lname != con.lastname){
                con.UpdateCount__c += 1;
                mname.fname = con.firstname;
                mname.lname = con.lastname;
                modaledit.put(con.id, mname);
            }
        }
        update contact_list;
        return new pagereference('/apex/ShowEditContact');
    }
    
    public class ModalEditAble{
        public String fname{get;set;}
        public String lname{get;set;}
    }
}