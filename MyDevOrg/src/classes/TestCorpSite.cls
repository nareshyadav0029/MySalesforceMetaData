@isTest
public class TestCorpSite{
    @isTest
    public static void CropTest(){
        CorpsSiteController csc = new CorpsSiteController();
        Contact obj = new Contact();
        obj.lastname = 'yadav';
        csc.contact = obj;
        csc.Save();
        
        
    }
}