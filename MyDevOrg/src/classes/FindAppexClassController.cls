/*
        Name            :    FindAppexClass
        Author          :    Naresh
        Date            :    3/2/2016
        Description     :    This class is used to find a perticular apex class.
*/

public class FindAppexClassController{
    //  Declaration of objects
    public List<ApexClass> listOfApexClass{get;set;}
    public String className{get;set;}
        
    
    
    // Method to return list of all classes
    public string getAllClassList(){
        List<ApexClassWrapper> tempList = new List<ApexClassWrapper>();
        for(ApexClass ap : [SELECT Id, NamespacePrefix, Name, ApiVersion, Status, IsValid, CreatedDate, 
                    LastModifiedDate FROM ApexClass order By Name asc limit 10]){
            ApexClassWrapper t = new ApexClassWrapper();
            t.Id = ap.id;
            t.Name = ap.Name;
            t.Status = ap.status;
            t.ApiVersion = string.ValueOf(ap.ApiVersion);
            tempList.add(t);            
         }
        return JSON.serialize(tempList);
    }
    
    //  Wrapper class
    public class ApexClassWrapper{
        public String Id;
        public String Name;
        public String Status;
        public String ApiVersion;
    } 
}