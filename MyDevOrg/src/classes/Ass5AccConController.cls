public class Ass5AccConController{
    public List<List<String>> ConFields{get;set;}
    public List<String> btnmatch{get;set;}
    public String getid{get;set;}
    public Ass5AccConController(){
        ConFields = new List<List<String>>();
        btnmatch = new List<String>();
        List<String> Firstname = new List<String>();
        List<String> Lastname= new List<String>();
        List<String> Email= new List<String>();
        List<String> Phone= new List<String>();
        Firstname.add('First Name'); Lastname.add('Last Name'); Email.add('Email'); Phone.add('Phone');
        String accountid = ApexPages.currentpage().getparameters().get('accid');
        for(Contact con : [select firstname, lastname, email, phone from Contact where Accountid =: accountid and Contacted__c = false]){
            Firstname.add(con.firstname == null ? '' : con.firstname);
            Lastname.add(con.lastname);
            Email.add(con.email == null ? '' : con.email);
            Phone.add(con.phone == null ? '' : con.phone);
            btnmatch.add(con.id);
        }
        
        ConFields.add(Firstname);
        ConFields.add(Lastname);
        ConFields.add(Email);
        ConFields.add(Phone);
    }
    
    public void Check(){
        Contact contact = [select Contacted__c from Contact where id =: getid limit 1];
        contact.Contacted__c = true;
        update contact;
        ConFields = new List<List<String>>();
        btnmatch = new List<String>();
        List<String> Firstname = new List<String>();
        List<String> Lastname= new List<String>();
        List<String> Email= new List<String>();
        List<String> Phone= new List<String>();
        Firstname.add('First Name'); Lastname.add('Last Name'); Email.add('Email'); Phone.add('Phone');
        String accountid = ApexPages.currentpage().getparameters().get('accid');
        for(Contact con : [select firstname, lastname, email, phone from Contact where Accountid =: accountid and Contacted__c = false]){
            Firstname.add(con.firstname == null ? '' : con.firstname);
            Lastname.add(con.lastname);
            Email.add(con.email == null ? '' : con.email);
            Phone.add(con.phone == null ? '' : con.phone);
            btnmatch.add(con.id);
        }
        
        ConFields.add(Firstname);
        ConFields.add(Lastname);
        ConFields.add(Email);
        ConFields.add(Phone);
    }
}