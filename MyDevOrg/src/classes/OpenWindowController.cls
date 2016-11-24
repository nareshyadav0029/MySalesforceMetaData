public class OpenWindowController{
    public String attid{get;set;}
    public String imgurl{get;set;}
    public Attachment attach{get;set;}
    public OpenWindowController(){
        attach = new Attachment();
        imgurl = ApexPages.currentpage().getparameters().get('img');
        attid = ApexPages.currentpage().getparameters().get('imgid');    
    }
    public void AddImage(){
        attach.parentId = attid;
        insert attach;
    }
}