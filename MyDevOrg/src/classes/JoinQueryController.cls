public class JoinQueryController{
    public List<account> ParentToChild{get;set;}
    public List<Student__c> ChildToParent{get;set;}
    public JoinQueryController(){
        ParentToChild = new List<account>();
        ChildToParent = new List<Student__c>();
        
        ParentToChild = [select Name , (select firstname , lastname , email from contacts) from account];
        ChildToParent = [select Name , class__r.name from Student__c];
    }
}