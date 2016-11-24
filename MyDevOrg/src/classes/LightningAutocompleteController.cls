public class LightningAutocompleteController{
    @AuraEnabled
    public static String autosearch(){
        String contactJSON;
        List<Contact> conList = [SELECT id,name FROM Contact];
        contactJSON = '[';
        for(Integer i=0;i<conList.size();i++){
            if(i+1 == conList.size()){
                contactJSON += '{\"id\": \"'+ conList[i].id + '\",\"label\": \"' + conList[i].name + '\",\"value\": \"' + conList[i].name + '\"}';
            }else{
                contactJSON += '{\"id\": \"'+ conList[i].id + '\",\"label\": \"' + conList[i].name + '\",\"value\": \"' + conList[i].name + '\"},';
            }
        }
        contactJSON += ']';
        
        return contactJSON;
    }
    
    @AuraEnabled
    public static List<Contact> getContacts(String con){
       // String con = 'naresh';
        system.debug('####'+con);
        if(con != null && con.trim().length()>0){
            con = String.escapeSingleQuotes(con);
            return Database.query('SELECT Id, Name, FirstName, LastName, Phone, Email FROM Contact WHERE Name LIKE \'%' + con + '%\'');
        }
        return [SELECT Id, Name, FirstName, LastName, Phone, Email FROM Contact];
    }
    
    @AuraEnabled
    public static List<Contact> updateContact(String conName){
        system.debug('#### conToUpdate== IN'+conName);
        return null;
    }
}