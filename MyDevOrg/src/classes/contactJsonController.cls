public class contactJsonController{
    
    //    DEFINE OBJECT

    public String contactJSON{get;set;}
    public String searchName{get;set;}
    
    //    CONSTRACTOR
    public contactJsonController(){
        searchName = apexpages.currentpage().getparameters().get('term');
        searchName += '%';
        List<Contact> conList = [SELECT id,name FROM Contact WHERE name like: searchName];
        contactJSON = '[';
        for(Integer i=0;i<conList.size();i++){
            if(i+1 == conList.size()){
                contactJSON += '{\"id\": \"'+ conList[i].id + '\",\"label\": \"' + conList[i].name + '\",\"value\": \"' + conList[i].name + '\"}';
            }else{
                contactJSON += '{\"id\": \"'+ conList[i].id + '\",\"label\": \"' + conList[i].name + '\",\"value\": \"' + conList[i].name + '\"},';
            }
        }
        contactJSON += ']';
    }
}