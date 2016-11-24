public class PopContactController{
    public List<Contact> contact{get;set;}
    public List<Attachment> Att{get;set;}
    public List<ModelPopContact> modelpop{get;set;}
    public Map<String,String> attmap{get;set;}
    public String conid{get;set;}
    public PopContactController(){
        Att = [select id , parentId from Attachment];
        modelpop = new List<ModelPopContact>();
        attmap = new Map<String , String>();
        contact = [select id , firstname , lastname, email from Contact];
        integer i=1;
        for(Attachment at : Att){
            attmap.put(at.parentId,at.id);
        }
        for(Contact con : contact){
            ModelPopContact modelcontact = new ModelPopContact();
            conid = attmap.get(con.id);
            modelcontact.img = '/servlet/servlet.FileDownload?file='+conid;
            modelcontact.s_no = i;
            modelcontact.con = con;
            modelpop.add(modelcontact);
            i++;
        }
    }
    
    public class ModelPopContact{
        public String img{get;set;}
        public integer id{get;set;}
        public integer s_no{get;set;}
        public Contact con{get;set;}
    }
}