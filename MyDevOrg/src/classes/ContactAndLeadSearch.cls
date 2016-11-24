public class ContactAndLeadSearch{
    
    public static List<List< SObject>> searchContactsAndLeads(String Name){
        List<List<SObject>> conLeadList = new List<List<SObject>>();
        conLeadList = [FIND : Name IN ALL FIELDS RETURNING Lead(FirstName,LastName),Contact(FirstName,LastName)];
        return conLeadList;
    }
}