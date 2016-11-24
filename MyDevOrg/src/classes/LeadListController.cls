public class LeadListController{
    public List<Lead> leads {get;set;}
    public List<String> alphabets {get;set;}
    public boolean orderflag {get;set;}
    public String fieldToSort {get;set;}
    public String alphabetFilter {get;set;}
    
    private List<lead> leadlist {get;set;}
    
    private static final Integer size = 5;
    private Integer startIndex{get;set;}
    private Integer endIndex {get;set;}
   
    //Constructor 
    public LeadListController(){
        alphabetFilter = 'ALL';
        fieldToSort = 'Company';
        leads = new List<lead>();
        leadlist = new List<lead>();
        orderflag = false;
        leadlist = [select name,OwnerId, Company,email,phone,status,DoNotCall from lead];
        alphabets = new String[] {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','ALL'};
        firstpage();    
    }
    
    //Function for filling list
    public void fillList(integer starting, integer ending){
         leads = new List<lead>();
         integer i = starting<0 ? 0 : starting;
         for(; i < ending && i < leadlist.size(); i++){
               leads.add(leadlist.get(i));
         }
    }
    public void firstPage(){
           startIndex = 0;
           endIndex = size < leadlist.size() ? size : leadlist.size();
           fillList(startIndex, endIndex); 
    }
    
    public void previousPage(){
        startIndex = (startindex-size) < 0 ? 0 : startindex - size;
        endIndex = endIndex-size <= 0 ? endIndex : endIndex-size;
        System.debug('######'+startIndex+' toindexesrange '+endIndex);
        if(startIndex >= 0){
            fillList(startIndex, endIndex);   
        } 
    }
    
    public void nextPage(){
        startIndex = startIndex+size >= leadlist.size() ? startIndex : startIndex+size;
        endIndex = endIndex+size >= leadlist.size() ? startIndex+size : endIndex+size;
        if(startIndex < leadlist.size()){
            fillList(startIndex, endIndex);   
        }
    }
    
    public void lastpage(){
        startIndex = math.mod(leadlist.size(),size) == 0 ? leadlist.size()-size : size*(leadList.size()/size);
        endIndex = startIndex+size;
        fillList(startIndex,leadlist.size());
    }
    
    public void sortData(){
        String query = 'SELECT name,OwnerId, Company,email,phone,status,DoNotCall FROM lead ';
        if(alphabetFilter !=null && alphabetFilter != 'All'){
            query+= 'WHERE '+ fieldToSort + ' like \''+ alphabetFilter +'%\'';
        }
        if(orderflag == true ){
            query +='  order by ' + fieldToSort + ' ASC';   
            orderflag=false;
        }
        else{
            query +='  order by ' + fieldToSort +' DESC' ;   
            orderflag=true;
        }
        leadlist = DataBase.query(query);
        firstpage();           
    }
}