/*
                        Name:   AccountContactRowController
                        Author: Nisar Ahmed
                        Date:   27 Jan 2015  
                        Description: Controller to add Account and contact with heirarchy 
*/
public class AccountContactRowController{
    
    public integer modelIndex{get;set;}
    public integer contactIndex {get;set;}
    public List<model> modelList {get;set;}
    public integer modelSize {get;set;}
    //constructor 
    public AccountContactRowController(){
        modelList  = new List<model>();
        modelSize = 0;
    }
    
    // Add a new row
    public void addModel(){
        model m = new model();
        m.acc = new Account();
        m.contactSize = 0;
        m.contactList = new List<contact>();
        modelList.add(m);
        modelSize = modelList.size();
    }
    // Add new contact in a model
    public void addContact(){
        if(modelIndex != null){
            modelList.get(modelIndex).contactList.add(new contact());
            modelList.get(modelIndex).contactSize = modelList.get(modelIndex).contactList.size();
        }
    }
    
    //Delete a Model
    public void delModel(){
        if(modelIndex != null){
            modelList.remove(modelIndex);
            modelSize = modelList.size();
        }
    }
    
    // Delete a contact from the list
    public void delContact(){
        if(modelIndex != null && contactIndex != null){
            modelList.get(modelIndex).contactList.remove(contactIndex);
            modelList.get(modelIndex).contactSize = modelList.get(modelIndex).contactList.size();
        }
    }
    
    // model
    public class model{
        public Account acc {get;set;}
        public List<contact> contactList{get;set;}
        public integer contactSize {get;set;}
    }
    
    // Method to Insert Account and Contact
    public pagereference saveModel(){
        List<Account> accountToInsert = new list<Account>();
        List<Contact> contactToInsert = new List<contact>();
        for(model m : modelList){
            accountToInsert.add(m.acc);
        }
        if(accountToInsert.size()>0)
            insert accountToInsert;
        for(model m : modelList){
            for(contact con : m.contactList){
                con.AccountId = m.acc.id;
                contactToInsert.add(con);
            }
        }
        if(contactToInsert.size()>0)
            insert contactToInsert;
        return new pagereference('/apex/AccountContactRow').setRedirect(true);
    }
}