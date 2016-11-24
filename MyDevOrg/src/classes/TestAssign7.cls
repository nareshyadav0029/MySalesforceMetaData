@isTest
public class TestAssign7{
    @isTest
    public static void testassign(){
        Ass7AllSObjectsController a7obj = new Ass7AllSObjectsController();
        a7obj.selected_object = 'Contact';
        a7obj.obj = a7obj.createObject(a7obj.selected_object);
        Ass7AllSObjectsController.Allfields all = new Ass7AllSObjectsController.Allfields();
        Ass7AllSObjectsController.Modalclass modal = new Ass7AllSObjectsController.Modalclass();
        a7obj.getfields();
        a7obj.getfieldtype();
        a7obj.AddRow();
        a7obj.NextPage();
        //a7obj.Save();
    }
}