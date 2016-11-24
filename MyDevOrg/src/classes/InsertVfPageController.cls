public class InsertVfPageController{
    public Contact conDetail{get;set;}
    public Attachment att{get;set;}  
    public String imgid{get;set;}
    public InsertVfPageController(Apexpages.standardController obj){
        conDetail = new Contact();
        att = new Attachment();
        Contact con = (Contact)obj.getRecord();
        conDetail = [select Firstname , Lastname from Contact where id=:con.id];
    }
    
    public pageReference save(){
        //update conDetail;        
            att.parentId = conDetail.Id;
            insert att;
            
            List<Attachment> attlist = [select ID from Attachment WHERE parentID=:conDetail.id ORDER BY ID ];
              for(Attachment a:attlist){
                imgid = a.ID;
              }
       return new pageReference('https://c.ap1.content.force.com/servlet/servlet.FileDownload?file='+imgid);
    }
}