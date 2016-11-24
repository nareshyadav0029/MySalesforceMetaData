public class CsvParseController{
    public Attachment attach{get;set;}
    public String cid{get;set;}
    public String text{get;set;}
    public List<CsvModal> cmodal{get;set;}
    public CsvParseController(){
        cmodal = new List<CsvModal>();
        cid = '00P9000000FRnvo';
        attach = [select body, name, parentid , contenttype, bodylength from Attachment where id = :cid limit 1];
        text = attach.Body.toString();
        text = ParseCsv(text);
    }
    
    /////// Modal Class for CSV ///////
    
    public class CsvModal{
        public String firstname{get;set;}
        public String lastname{get;set;}
        public String account{get;set;}
        public String email{get;set;}
        public String phone{get;set;}
        public integer amount{get;set;}
    }
    
    ////// Function to parse the CSV File ///////
    
    public String ParseCsv(String csvfile){
        String s;
        List<String> csvdata = new List<String>();
        csvdata = text.split('\n');
        integer i = 0;
        for(String data : csvdata){
            if(i++ == 0)
                continue;
                
            CsvModal modalcsv = new CsvModal();
            try{
                String fname = data.substring(0, data.indexOf(','));
                if(fname.indexOf('')== -1){
                    modalcsv.firstname = fname.substring(0, data.indexOf(''));
                }else{
                    modalcsv.firstname = fname.substring(0, fname.indexOf(''));
                    modalcsv.lastname = fname.substring(fname.indexOf(''), fname.length());
                }
                
                data = data.substring(data.indexOf(',')+1);
                modalcsv.account = data.substring(0, data.indexOf(','));
                data = data.substring(data.indexOf(',')+1);
                modalcsv.phone = data.substring(0, data.indexOf(','));
                data = data.substring(data.indexOf(',')+1);
                modalcsv.email = data.substring(0, data.indexOf(','));
                data = data.substring(data.indexOf(',')+1);
                data = data.trim();
                modalcsv.amount = integer.valueOf(data);
            }catch(Exception ex){
            
            }
            cmodal.add(modalcsv);
        }
        return s; 
    }
    
}