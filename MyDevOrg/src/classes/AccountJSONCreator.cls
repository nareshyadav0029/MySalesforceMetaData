public with sharing class AccountJSONCreator{

    public String showJSON{get;set;}
    public String searchName{get;set;}
    
    public AccountJSONCreator (){
        searchName = apexpages.currentpage().getparameters().get('term');
        searchName += '%';
        List<Account> accList = [Select id,name from account where name like: searchName];
        showJSON = '[';
        for(Integer i=0;i<accList.size();i++){
            if(i+1 == accList.size()){
                showJSON += '{\"id\": \"'+ accList[i].id + '\",\"label\": \"' + accList[i].name + '\",\"value\": \"' + accList[i].name + '\"}';
            }else{
                showJSON += '{\"id\": \"'+ accList[i].id + '\",\"label\": \"' + accList[i].name + '\",\"value\": \"' + accList[i].name + '\"},';
            }
        }
        showJSON += ']';
    }
}