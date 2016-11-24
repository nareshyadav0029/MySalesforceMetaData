public class AttachmentManagerController{
    public List<Attachment> att{get;set;}
    public String attid{get;set;}
    public String attachid{get;set;}
    public List<id> accid{get;set;}
    public List<id> conid{get;set;}
    public List<id> leadid{get;set;}
    public List<id> oppid{get;set;}
    public List<selectOption> selectobj{get;set;}
    public String selected_obj{get;set;}
    public String selected_name{get;set;}
    public List<Modalimgtype> mtype{get;set;}
    public List<selectOption> selectname{get;set;}
    public List<Account> acc_list{get;set;}
    public List<Contact> con_list{get;set;}
    public List<Lead>  lead_list{get;set;}
    public List<Opportunity> opp_list{get;set;}
    public AttachmentManagerController(){
        attid = '';
        attachid = '';
        mtype = new List<Modalimgtype>();
        accid = new List<id>();
        conid = new List<id>();
        leadid = new List<id>();
        oppid = new List<id>();
        acc_list = [select id, Name from Account];
        con_list = [select id, name from Contact];
        lead_list = [select id, name from Lead];
        opp_list = [select id, name from Opportunity];
        selectname = new List<selectOption>();
        selectobj = new List<selectOption>();
        selectobj.add(new SelectOption('null', '---None---'));
        selectobj.add(new SelectOption('001', 'Account'));
        selectobj.add(new SelectOption('003', 'Contact'));
        selectobj.add(new SelectOption('00Q', 'Opportunity'));
        selectobj.add(new SelectOption('006', 'Lead'));
        
        att = [select id, parentid, name, contenttype, BodyLength from Attachment];
        for(Attachment a : att){
            Modalimgtype mimg = new Modalimgtype();
            mimg.Atach = a;
            mimg.imgurl = getimgtype(a.contenttype);
            mtype.add(mimg);
        }
        for(Account acc : [select id from Account]){
            accid.add(acc.id);
        }
        for(Contact con : [select id from Contact]){
            conid.add(con.id);
        }
        for(Lead l : [select id from Lead]){
            leadid.add(l.id);
        }
        for(Opportunity opp : [select id from Opportunity ] ){
            oppid.add(opp.id);
        }    
    }
    
    ////// Modal Class//////
    
    public class Modalimgtype{
        public String imgurl{get;set;}
        public Attachment Atach{get;set;}
    }
    
    ////// Function for Image Type //////
    
    public String getimgtype(String imgtype){
        if(imgtype == 'image/jpeg'){
            return 'jpeg.jpg';
        }else if(imgtype == 'image/png'){
            return 'png.png';
        }else if(imgtype == 'image/gif'){
            return 'gif.gif';
        }else{
            return 'jpeg.jpg';
        }
    }
    
    ////// Function For Filling PickList In New Window //////
    
    public void fillList(){
        selectname = new List<SelectOption>();
        if(selected_obj=='001'){
            
            selectname.add(new SelectOption('null', '---None---'));
            for(Account acc : acc_list){
                selectname.add(new SelectOption(acc.id, acc.name));
            }
        }else if(selected_obj == '003'){
            
            selectname.add(new SelectOption('null', '---None---'));
            for(Contact con : con_list){
                selectname.add(new SelectOption(con.id, con.name));
            }
        }else if(selected_obj == '00Q'){
            
            selectname.add(new SelectOption('null', '---None---'));
            for(Lead l : lead_list){
                selectname.add(new SelectOption(l.id, l.name));
            }
        }else if(selected_obj == '006'){
            
            selectname.add(new SelectOption('null', '---None---'));
            for(Opportunity opp : opp_list){
                selectname.add(new SelectOption(opp.id, opp.name));
            }
        }
    }
    
    /////// Function for Copy Attachment ///////
    
    public void copyatt(){
        Attachment catt = new Attachment();
        Attachment natt = new Attachment();
        attachid = ApexPages.currentPage().getParameters().get('id');
        catt = [select name, Body, contenttype, BodyLength from Attachment where id = :attachid limit 1];
        if(selected_obj == '001'){
            for(Account acc : acc_list){
                if(selected_name == acc.id){
                    natt.parentid = acc.id;
                    natt.name = catt.name;
                    natt.Body = catt.Body;
                    natt.contenttype = catt.contenttype;
                }
            }
            insert natt;
        }else if(selected_obj == '003'){
           for(Contact con : con_list){
                if(selected_name == con.id){
                    natt.parentid = con.id;
                    natt.name = catt.name;
                    natt.Body = catt.Body;
                    natt.contenttype = catt.contenttype;
                }
            }
            insert natt; 
        }else if(selected_obj == '00Q'){
           for(Lead lead : lead_list){
                if(selected_name == lead.id){
                    natt.parentid = lead.id;
                    natt.name = catt.name;
                    natt.Body = catt.Body;
                    natt.contenttype = catt.contenttype;
                }
            }
            insert natt; 
        }else if(selected_obj == '006'){
            for(Opportunity opp : opp_list){
                if(selected_name == opp.id){
                    natt.parentid = opp.id;
                    natt.name = catt.name;
                    natt.Body = catt.Body;
                    natt.contenttype = catt.contenttype;
                }
            }
            insert natt;
        }
    }
    
    ////// Function For Delete Attachment //////
    
    public PageReference DeleteAtt(){
        Attachment attach = [select id from Attachment where id =: attid limit 1];
        delete attach;
        return new PageReference('/apex/AttachmentManager').setRedirect(true);
    }
    
    ////// Function For Search Attachment //////
    
    public void Search(){
       List<id> ids = new List<id>();
       boolean flag = false;
       if(selected_obj=='001'){
            ids = accid;
       }else if(selected_obj=='003'){
            ids = conid;
       }else if(selected_obj=='00Q'){
            ids = leadid;
       }else if(selected_obj=='006'){
            ids = oppid;
       }else{
           flag = true;
       }
       if(flag == false){
           att = [select id,name, bodylength,contenttype, parentid from Attachment WHERE parentid IN:ids];
       }else{
           att = [select id,name, bodylength,contenttype, parentid from Attachment];
       }
       mtype = new List<Modalimgtype>();
       for(Attachment a : att){
            Modalimgtype mimg = new Modalimgtype();
            mimg.atach = a;
            mimg.imgurl = getimgtype(a.contentType);
            mtype.add(mimg);
       }
    }
}