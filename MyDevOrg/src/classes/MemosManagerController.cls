public class MemosManagerController{
    public List<Contact> con_list{get;set;}
    public String UserEmail{get;set;}
    public String Lastname{get;set;}
    public String Firstname{get;set;}
    public String Email{get;set;}
    public String Phone{get;set;}
    public List<ModalMemo> memomodal{get;set;}
    public MemosManagerController(){
        memomodal = new List<ModalMemo>();
        con_list = [select firstname, lastname, email from Contact];
        /*Cookie c = ApexPages.currentPage().getCookies().get('conid');
        String conid = c.getValue();
        for(Memo__c m : [select title__c , status__c, createdDate__c, modifiedDate__c, body__c from Memo__c where contact__c = :conid]){
            ModalMemo modal = new ModalMemo();
            modal.memo = m;
            memomodal.add(modal);
        }*/
        
    }
    
    ////// Modal Class ///////
    
    public class ModalMemo{
        public Memo__c memo{get;set;}
    }
    
    public pagereference Check(){
        for(Contact con : con_list){
            if(con.email == UserEmail || con.email == null && Apexpages.currentPage().getCookies().get('conid') != null){
                return new pagereference('/apex/AttachmentManager');
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Invalid Email !!!');
                ApexPages.addMessage(myMsg);
            }
        }
        return null;
    }
    
    public void coninsert(){
        Contact con = new Contact();
        if(Lastname != null){
            con.firstname = Firstname;
            con.lastname = Lastname;
            con.email = email;
            con.phone = Phone;
            insert con;
        }
    }
}