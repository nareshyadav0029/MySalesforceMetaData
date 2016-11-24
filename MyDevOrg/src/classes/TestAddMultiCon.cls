@isTest
public class TestAddMultiCon{
    @isTest
    public static void MyTest(){
        AddMultiContactsController acc = new AddMultiContactsController();
        AddMultiContactsController.ModelContact cModel = new AddMultiContactsController.ModelContact();
        acc.AddRow();
        acc.DelRow();
        acc.Save();
        
    }
}