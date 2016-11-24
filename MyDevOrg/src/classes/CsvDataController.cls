public class CsvDataController{
    public Attachment attach{get;set;}
    public List<Staging__c> stag_list{get;set;}
    public CsvDataController(){
        attach = new Attachment();
        stag_list = new List<Staging__c>();
    }
    
    /////// Function For Upload the CSV file and For Parsing ///////
    
    public void upload(){
        if(attach.contentType == 'application/vnd.ms-excel' || attach.contentType == 'text/csv'){
            String csvtext = attach.Body.toString();
            List<String> csvdata = new List<String>();
            csvdata = csvtext.split('\n');
            
            integer i = 0;
            for(String data : csvdata){
                if(i++ == 0)
                continue;
                
                Staging__c modalcsv = new Staging__c();
                try{
                    String name = data.substring(0, data.indexOf(','));
                    modalcsv.Name = name.trim();
                    if(name.indexOf(' ')== -1){
                        modalcsv.Firstname__c = name.substring(0, name.length()).trim();
                    }else{
                        modalcsv.Firstname__c = name.substring(0, name.indexOf(' ')).trim();
                        modalcsv.Lastname__c = name.substring(name.indexOf(' '), name.length()).trim();
                    }
                    
                    data = data.substring(data.indexOf(',')+1);
                    modalcsv.Account__c = data.substring(0, data.indexOf(',')).trim();
                    data = data.substring(data.indexOf(',')+1);
                    modalcsv.Phone__c = data.substring(0, data.indexOf(',')).trim();
                    data = data.substring(data.indexOf(',')+1);
                    modalcsv.Email__c = data.substring(0, data.indexOf(',')).trim();
                    data = data.substring(data.indexOf(',')+1);
                    data = data.trim();
                    modalcsv.Amount__c = integer.valueOf(data);
                }catch(Exception ex){
                
                }
                stag_list.add(modalcsv);
            }
            insert stag_list;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Data Parsed Successfully...');
            ApexPages.addMessage(myMsg); 
        }else{
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'Data Cannot Parsed Successfully !!!');
           ApexPages.addMessage(myMsg);
        }
        stag_list = new List<Staging__c>();
    }
    
    ////// Function For Processing the CSV Records //////
    
    public pagereference process(){
        CsvInsert obj = new CsvInsert();
        Database.executeBatch(obj, 5); 
        return new pagereference('/apex/CsvData');
    }
     
}