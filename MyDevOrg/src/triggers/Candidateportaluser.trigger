/*

    Name         :    Candidateportaluser
    Date         :    2/02/2015
    Description  :    Run When we insert and update the Candidate.

*/

trigger Candidateportaluser on Candidate__c (After insert, After update){

    Map<String,Account> accMap = new Map<String,Account>();
    Map<String,Account> ManageBrokMap = new Map<String,Account>();
    Map<String, Contact> conMap = new Map<String, Contact>();
    List<Task> task_list = new List<Task>();
    List<User> insertUsers = new List<User>();
    List<User> userList = [SELECT username FROM User];
    Integer i = 1;
    
    if(Trigger.isInsert){
        for(Candidate__c can : Trigger.new){
            if(can.Brokerage__c != null){
                Account acc = new Account();
                acc.Name = can.Brokerage__c;
                accMap.put(can.id,acc);
            }else{
                can.Brokerage__c.addError('Please First Fill Brokerage !!!');
            }
            if(can.Manage_Brokerage__c != null){
                Account manageAcc = new Account();
                manageAcc.Name = can.Manage_Brokerage__c;
                ManageBrokMap.put(can.id,manageAcc);
            }else{
                can.Manage_Brokerage__c.addError('Please First Fill Manage Brokerage !!!');
            }
            Contact con = new Contact();
            con.Lastname = can.Name;
            con.Email = can.Email__c;
            con.Candidate__c = can.id;
            conMap.put(can.id, con);
        }
        if(accMap.size()>0){
            insert accMap.Values();
        }
        for(string str : accMap.keyset()){
            ManageBrokMap.get(str).parentId = accMap.get(str).id;
        }
        if(ManageBrokMap.size()>0){
            insert ManageBrokMap.Values();
        }
        for(string str : ManageBrokMap.keyset()){
            conMap.get(str).AccountId = ManageBrokMap.get(str).id;
        }
        if(conMap.size()>0){
            insert conMap.Values();
        }
        for(string str : conMap.keyset()){
            Task conTask = new Task();
            conTask.WhoId = conMap.get(str).id;
            conTask.WhatId = conMap.get(str).Candidate__c;
            conTask.Subject = 'Portal Contact Setup';
            task_list.add(conTask);
        }
        if(task_list.size()>0){
            insert task_list;
        }
    }else{
        System.debug('#### In Else Part');
        Profile pro = [select id from profile where name = 'Authenticated Website' limit 1];
        for(Candidate__c can : Trigger.new){
            for(Contact con : [SELECT id, AccountId, Lastname, Email FROM Contact WHERE Candidate__c IN : Trigger.new]){
                conMap.put(can.id, con);
            }
            System.debug('#### In For Loop');
            if(can.Candidate_Status__c == 'Webinar - Attended' && can.User_Created__c == false && can.Candidate_Status__c != Trigger.OldMap.get(can.id).Candidate_Status__c && can.User_Created__c != Trigger.OldMap.get(can.id).User_Created__c){
                for(String str : conMap.KeySet()){
                    System.debug('#### In if Part'+conMap.KeySet());
                    System.debug('#### In for Part');
                    User insertUser = new User();
                    insertUser.Username = 'newUser@gmail.com'+i;
                    insertUser.LastName = conMap.get(str).Lastname;
                    insertUser.Email = 'newUser@gmail.com';
                    insertUser.Alias = 'Test';
                    insertUser.TimeZoneSidKey ='Asia/Kolkata';
                    insertUser.LocaleSidKey ='en_Au';
                    insertUser.EmailEncodingKey ='UTF-8';  
                    insertUser.LanguageLocaleKey = 'en_US';  
                    insertUser.ContactId = conMap.get(str).id;
                    insertUser.isActive = true;
                    insertUser.CommunityNickname = conMap.get(str).Lastname;
                    
                    //user profile defines if it is a portal user
                    insertUser.ProfileId = pro.id;
                    
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    dmo.EmailHeader.triggerUserEmail = true;
                    insertUser.setOptions(dmo);
                    insertUsers.add(insertUser);
                    System.debug('#### In Else Part'+insertUser);
                }
                i++;
            }
        }
        if (insertUsers.size() > 0){
            try{
                 System.debug('####'+insertUsers);
                Database.insert(insertUsers);
            }catch(Exception e){
                //An error will thrown if there is an existing user account
                        //opty.addError('There was a problem creating the portal user.');
                System.debug('****err'+e);
            }
        }
    }
}