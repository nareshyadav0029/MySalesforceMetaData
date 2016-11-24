public class Ass3ContactController{
    public List<ModelContact> modelcontact{get;set;}
    public List<Contact> contact{get;set;}
    public String Fname{get;set;}
    public String Lname{get;set;}
    public String Phone{get;set;}
    public String Email{get;set;}
    public String conid{get;set;}
    Public Attachment att{get;set;}
    public Ass3ContactController(){
        att = new Attachment();
        modelcontact = new List<ModelContact>();
        contact = [select id, firstname, lastname, email, phone from Contact limit 1000];
        integer i=1;
        for(Contact contacts : contact){
            ModelContact mcon = new ModelContact();
            mcon.s_no = i;
            mcon.conid = contacts.id;
            mcon.con = contacts;
            modelcontact.add(mcon);
            i++;
        }
        Map<id,id> imgmap = new Map<ID,ID>();
        for(Attachment atch : [select id,parentid from Attachment order by id]){
            imgmap.put(atch.parentid, atch.id);
        }
        
        // Assigning last image to the modelContact list
        for(ModelContact cm :modelcontact){
            if(imgmap.get(cm.con.id)==null){
                cm.imgurl = 'null';
            }else{
                cm.imgurl = '/servlet/servlet.FileDownload?file='+imgmap.get(cm.con.id);
            }
        }
    }
    
    public pagereference Save(){
       Contact Con = new Contact();
       Con.id = conid;
       att.parentid = conid;
       Con.firstname = fname;
       Con.lastname =  lname;
       Con.Phone = phone;
       Con.Email = email;
       update Con;
       insert att;
       return new pagereference('/apex/Ass3Contact').setRedirect(true); 
    }
    
    public class ModelContact{
        public integer s_no{get;set;}
        public Contact con{get;set;}
        public String conid{get;set;}
        public String imgurl{get;set;}
    }
}