@isTest
public class AccountManagerTest{
    
    @isTest 
    static void testGetAccount() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = 'https://paraforce-dev-ed.my.salesforce.com/services/apexrest/Accounts/'+ recordId+'/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account accTest = AccountManager.getAccount();
        // Verify results
        //System.assert(thisCase != null);
        //System.assertEquals('Test record', thisCase.Subject);
    }
    
    // Helper method
    static Id createTestRecord() {
        // Create test record
        Account accTest = new Account(Name='Test Account');
        insert accTest;
        return accTest.Id;
    }
}