/*
                        Name:   TestAccountContactRowController
                        Author: Nisar Ahmed
                        Date:   27 Jan 2015  
                        Description: Test class AccountContactRowController for the Controller to add Account and contact with heirarchy 
*/
@isTest
public class TestAccountContactRowController{
    @isTest
    public static void unitTest(){
        AccountContactRowController obj = new AccountContactRowController();
        
        obj.addModel();
        obj.modelIndex = 0;
        obj.addContact();
        obj.addContact();
        obj.modelList.get(0).acc = new Account(name = 'Test Account');
        
        obj.modelIndex = 0;
        obj.contactIndex = 1;
        obj.delContact();
        
        obj.modelList.get(0).contactList.get(0).lastname = 'test last';
        obj.addModel();
        obj.modelIndex = 1;
        obj.delModel();
        
        obj.saveModel();
    }
}