@isTest
public class searchAccContactPaginationcont_Test{
    @isTest
    public static void TestsearchAccContactPaginationcont(){
        searchAccContactPaginationcont sa = new searchAccContactPaginationcont();
        searchAccContactPaginationcont.Modalcon mcon = new searchAccContactPaginationcont.Modalcon();
        sa.Name = 'Test';
        
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;

        sa.searchaccount();
        
        sa.Name = '';
        sa.searchaccount();
        
        sa.Name = 'Test1';
        sa.searchaccount();

        Contact con = new Contact();
        con.Firstname = 'Ftest';
        con.Lastname = 'LTest';
        con.AccountId = acc.id;
        insert con;
        sa.selaccid = acc.id;
        
        ApexPages.currentPage().getParameters().put('Id',con.id);
        sa.showcontact();
        
        sa.getid();
        sa.showPageMessage();
        sa.DetailIdsFromUrl();
        
        sa.prev();
        
        sa.temp_offset = 4;
        sa.prev();
        
        sa.next();
        sa.getprv();
        
        sa.temp_offset = 0;
        sa.getprv();
        
        sa.getnxt();
        
        sa.count = 8;
        sa.temp_offset = 0;
        sa.QueryLimit = 0;
        sa.getnxt();
    }
}