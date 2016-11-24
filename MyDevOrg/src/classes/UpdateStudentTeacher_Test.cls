@isTest
public class UpdateStudentTeacher_Test{
    @isTest
    public static void TestUpdateStudentTeacher(){
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Contact con = new Contact();
        con.Firstname = 'TestCon';
        con.Lastname = 'Test';
        con.AccountId = acc.id;
        insert con;
    }
}