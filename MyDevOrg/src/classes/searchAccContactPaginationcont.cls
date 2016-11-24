public class searchAccContactPaginationcont{
    
    public List<SelectOption> select_acc{get;set;}
    public String Name{get;set;}
    public Boolean flag{get;set;}
    public Boolean con_flag{get;set;}
    Public Boolean msg_flag{get;set;}
    public Boolean page_flag{get;set;}
    public List<Contact> con_list{get;set;}
    public List<Contact> Tempcon_list{get;set;}
    public String selaccid {get;set;}
    public String selconid{get;set;}
    public List<Modalcon> modal{get;set;}
    public List<Modalcon> mainListOfContact{get;set;}
    public List<String> con_ids{get;set;}
    public String url{get;set;}
    public String detail_url{get;set;}
    public List<Contact> con_detail{get;set;}
    public List<String> temp_detail{get;set;}
    public List<String> detailId{get;set;}
    public integer count{get;set;}
    public integer index = 3;
    public integer start = 0;
    public Boolean prev{get;set;}
    public Boolean next{get;set;}
    public Boolean first{get;set;}
    public Boolean last{get;set;}

    
    //// CONSTRACTOR
    
    public searchAccContactPaginationcont(){       
        con_list = new List<Contact>();
        modal = new List<Modalcon>();
        mainListOfContact = new List<Modalcon>();
        select_acc = new List<SelectOption>();
          
        flag = false;
        con_flag = false;
        msg_flag = false;
        page_flag = false;
    }
    
    //// FUNCTION FOR SEARCHING
    
    public void searchaccount(){
        select_acc.clear();
        con_flag = false;
        page_flag = false;
        if(!Name.trim().equalsIgnoreCase('')){
            String Aname = name+'%';
            for(Account acc : [SELECT id, name FROM Account WHERE name like : Aname ]){
                select_acc.add(new SelectOption(acc.id, acc.name));
            }
            if(select_acc.size()==0){
                flag = false;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There is no account of this name !!!');
                ApexPages.addMessage(myMsg);
            }else{
                flag = true;
            }    
        }else{
            for(Account acc : [SELECT id, name FROM Account LIMIT 10]){
                select_acc.add(new SelectOption(acc.id, acc.name));
            }
            con_flag = false;
            flag = true;
        }
    }
    
    //// FUNCTION FOR SHOW CONTACTS
    
    public void showcontact(){
        modal.clear();
        con_list.clear();
        con_list = [SELECT id, firstname, lastname, email, name FROM Contact where AccountId =: selaccid];
        if(con_list.size()>0){
            con_flag = true;
        }else{
            con_flag = false;
        }
        for(Contact con : con_list){
            Modalcon mcon = new Modalcon();
            mcon.contact = con;
            mcon.check = false;
            modal.add(mcon);
        }
        count = modal.size();
        List<Modalcon> tempList = new List<Modalcon>();
        for(Integer i=start;i<index;i++){
            if(modal.size()>0){
                tempList.add(modal.get(i));
            }
        }
        mainListOfContact = tempList;
        prev = true;
        next = false;
        first = true;
        last = false;
        
    }
    
    // Function for Next Page Records 
    
    public void nextpage(){
        index = index+3;
        start = start+3;
        mainListOfContact.clear();
        if(index > count){
            index = Math.Mod(count,3)+start;
            next = true;
            prev = false;
            last = true;
            first = false;
            List<Modalcon> tempList = new List<Modalcon>();
            for(Integer i=start;i<index;i++){
                if(modal.size()>0){
                    tempList.add(modal.get(i));
                }
            }
            mainListOfContact = tempList;
            index = start+3;
        }else{
            List<Modalcon> tempList = new List<Modalcon>();
            for(integer i=start;i<index;i++){
                if(modal.size()>0){
                    tempList.add(modal.get(i));
                }
            }
            mainListOfContact = tempList;
            prev = false;
            first = false;  
        }
    }
    
    // Function for Previous Page Records 

    public void prevpage(){
        if(start > 3){
            index = index-3;
            start = start-3;
            List<Modalcon> tempList = new List<Modalcon>();
            for(integer i=start;i<index;i++){
                if(modal.size()>0){
                    tempList.add(modal.get(i));
                }
            }
            mainListOfContact = tempList;
            prev = false;
            next = false;
            last = false;
        }else{
            index = index - 3;
            start = start - 3;
            List<Modalcon> tempList = new List<Modalcon>();
            for(integer i=start;i<index;i++){
                if(modal.size()>0){
                    tempList.add(modal.get(i));
                }
            }
            mainListOfContact = tempList;
            prev = true;
            next = false;
            first = true;
            last = false;
        }
    }
    
    // Function for first page
    
    public void firstpage(){
        index = 3;
        start = 0;
        List<Modalcon> tempList = new List<Modalcon>();
        for(Integer i=start;i<index;i++){
            if(modal.size()>0){
                tempList.add(modal.get(i));
            }
        }
        
        mainListOfContact = tempList;
        prev = true;
        next = false;
        first = true;
        last = false;
    }
    
    // Function for Last page
    
    public void lastpage(){
        index = count - (Math.Mod(count,index));
        start = index-3;
        List<Modalcon> tempList = new List<Modalcon>();
        for(Integer i=start;i<index;i++){
            if(modal.size()>0){
                tempList.add(modal.get(i));
            }
        }
        mainListOfContact = tempList;
        prev = false;
        next = true;
        first = false;
        last = true;
    }
    
    ////   FUNCTION FOR Contact Ids 
     
    public void getid(){     
        url = '/apex/searchAccContactPagination_sendmail?id=';
        con_ids = new List<String>();
         for(modalcon mcon : modal){            
            if(mcon.check == true){
                msg_flag = false;                  
               con_ids.add(mcon.contact.id);
            }else{
                msg_flag = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Please first select the contact !!!');
                ApexPages.addMessage(myMsg);
            }             
         }
         if(con_ids.size()>0){
             msg_flag = false;
             for(Integer i=0;i<con_ids.size();i++){
                 url = url+String.valueOf(con_ids[i])+' ';
             }
         }    
    }
    
    //// FUNCTION FOR PAGE MESSAGES
    
    public void showPageMessage(){
        detail_url = '/apex/searchAccContactPagination_Detail?id=';
        temp_detail = new List<String>();
        for(modalcon mcon : modal){                       
            if(mcon.check == true){
                msg_flag = false;                  
                temp_detail.add(mcon.contact.id);
            }else{
                msg_flag = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Please first select the contact !!!');
                ApexPages.addMessage(myMsg);
            }             
        }
        if(temp_detail.size()>0){
             msg_flag = false;
             for(Integer i=0;i<temp_detail.size();i++){
                 detail_url = detail_url+String.valueOf(temp_detail[i])+' ';
             }
         }
    }
    
    //// FUNCTION FOR CONTACT DETAIL
    
     public void DetailIdsFromUrl(){
        con_detail = new List<Contact>();
        detailId = Apexpages.currentPage().getParameters().get('id').split(' ');
        system.debug('####'+detailId);
        for(contact con : [select id, name, email, firstname, lastname, phone, AccountId from contact where id in:detailId]){            
            con_detail.add(con);                
        }
        system.debug('####'+con_detail);
    }
    
   
    //// MODAL CLASS
     
     public class Modalcon{
         public Contact contact{get;set;}
         public Boolean check{get;set;}
     }
     
}