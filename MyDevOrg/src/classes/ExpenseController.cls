public class ExpenseController{
    //    SHOW THE LIST OF ALL EXPENSE RECORDS
    @AuraEnabled
    public static List<Expense__c> getExpenses(){
        return [SELECT id, name, amount__c, client__c, date__c,reimbursed__c, createdDate FROM Expense__c];
    }
    
    //    UPDATE OR INSERT EXPENSE RECORDS
    @AuraEnabled
    public static Expense__c saveExpense(Expense__c expense){
        upsert expense;
        return expense;
    }
}