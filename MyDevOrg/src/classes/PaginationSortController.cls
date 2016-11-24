public class PaginationSortController{
    public List<Lead> lead_Templist{get;set;}
    public List<Lead> lead_Mainlist{get;set;}
    public List<String> alphabet_list {get;set;}
    public integer count{get;set;}
    public integer index = 5;
    public integer start = 0;
    public Boolean prev{get;set;}
    public Boolean next{get;set;}
    public String select_alphabet{get;set;}
    // the current sort direction. defaults to asc
    public String sortDir {
        get { 
            if (sortDir == null){  
                sortDir = 'asc'; 
            }
            return sortDir;
        }
        set;
    }
    
    // the current field to sort by. defaults to last name
    public String sortField {
        get { 
            if (sortField == null){
                sortField = 'firstname'; 
            } return sortField;
        }
        set;
    }
    
//////////// Constructor ///////////////
    
    public PaginationSortController(){
        lead_Mainlist = [select id, firstname, lastname, email, phone from Lead order by name];
        count = [select count() from Lead];
        alphabet_list = new String[] {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','ALL'};
        List<Lead> Temp = new List<Lead>();
        
        for(integer i=start;i<index;i++){
            Temp.add(lead_Mainlist.get(i));
        }
        lead_Templist = Temp;
        prev = true;
        next = false;
        select_alphabet = 'ALL';
        runQuery();
    }
    
//////////// Function for Next Page Records ///////////////
    
    public void nextpage(){
        index = index+5;
        start = start+5;
        lead_Templist.clear();
        if(index > count){
            index = Math.Mod(count,5)+start;
            next = true;
            prev = false;
            List<Lead> Temp = new List<Lead>();
            for(integer i=start;i<index;i++){
                Temp.add(lead_Mainlist.get(i));
            }
            lead_Templist = Temp;
            index = start+5;
        }else{
            List<Lead> Temp = new List<Lead>();
            for(integer i=start;i<index;i++){
                Temp.add(lead_Mainlist.get(i));
            }
            lead_Templist = Temp;
            prev = false;
        }
    }
    
//////////// Function for Previous Page Records ///////////////

    public void prevpage(){
        if(start > 5){
            index = index-5;
            start = start-5;
            List<Lead> Temp = new List<Lead>();
            for(integer i=start;i<index;i++){
                Temp.add(lead_Mainlist.get(i));
            }
            lead_Templist = Temp;
            prev = false;
            next = false;
        }else{
            index = index - 5;
            start = start - 5;
            List<Lead> Temp = new List<Lead>();
            for(integer i=start;i<index;i++){
                Temp.add(lead_Mainlist.get(i));
            }
            lead_Templist = Temp;
            prev = true;
            next = false;
        }
    }
    
    // toggles the sorting of query from asc<-->desc
    public void toggleSort() {
        // simply toggle the direction
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        // run the query again
        runQuery();
     }

  // runs the actual sorting query
     
     public void runQuery() {
         lead_Templist = Database.query('select id, firstname, lastname, email, phone from Lead order by ' + sortField + ' ' + sortDir + ' limit 5');
     }
     
  // Function for sorting    
    
     public void sort(){
         String query = 'SELECT firstname, lastname, email, phone FROM Lead';
         if(select_alphabet != null && select_alphabet != 'ALL'){
            query+=' WHERE '+sortField+ ' LIKE \''+select_alphabet+'%\'';
         }
         if(sortDir == 'asc' ){
            query +='  order by ' + sortField + ' ASC limit 5';   
         }else{
            query +='  order by ' + sortField +' DESC limit 5' ;   
         }
         lead_Templist = Database.query(query);
     }
}