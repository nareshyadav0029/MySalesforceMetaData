@isTest
public class TestEditEachContact{
    @isTest
    public static void EditTest(){
        
        Contact con1 = new Contact();
        con1.lastname = 'test';
        insert con1;
        
        
        EditEachContactController econ = new EditEachContactController();
        econ.conid = con1.id;
        EditEachContactController.ModalEditCon modalcon = new EditEachContactController.ModalEditCon();
        econ.Toggle();
        econ.Save();
    }
}