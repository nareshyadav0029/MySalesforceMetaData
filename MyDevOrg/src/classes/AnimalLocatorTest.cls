/*

        Description    :    This is test class for AnimalLocator.

*/

@isTest
public class AnimalLocatorTest{
    @isTest
    private static void unitTest(){
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        String response = AnimalLocator.getAnimalNameById(1);
        
    }
}