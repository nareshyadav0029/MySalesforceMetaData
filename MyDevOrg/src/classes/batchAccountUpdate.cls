Global class batchAccountUpdate implements Database.Batchable<sObject> {
    Global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,Name FROM Account';
        return Database.getQueryLocator(query);
        }
        Global void execute(Database.BatchableContext BC, List<Account> scope) {
            for(Account a : scope) {
                a.Name = a.Name + 'Updated';
            }
            update scope;
        }
        
        Global void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors,JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        String UserEmail = 'nareshyadav0029@yahoo.com';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {UserEmail});
        mail.setReplyTo('nareshyadav0029@yahoo.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed');
        mail.setPlainTextBody('Batch Process has completed');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}