@isTest
public class TestjQueryAutoCompleteController{
    @isTest
    public static void unitTest(){
        insert new contact(lastname='nisar', email='nisarjavac799@gmail.com');
        insert new contact(lastname='naresh', email='devilnareshmayCry12@gmail.com');
        jQueryAutoCompleteController clsobj = new jQueryAutoCompleteController(); 
        clsobj.emailTo = 'nisarjavac799@gmail.com,devilnareshmayCry12@gmail.com';
        clsobj.subject = 'test subject';
        clsobj.body = 'test body';
        clsobj.sendEmail();
    }
}