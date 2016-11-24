trigger FillSalary on Contact (before insert , before update) {
    for(Contact con : trigger.new){
        if(con.Designation__c == 'Developer'){
            con.Salary__c = 10000;
        }else if(con.Designation__c == 'Faculty'){
            con.Salary__c = 7000;
        }else{
            con.Salary__c = 0;
            //con.addError('Please select one option form list');
        }
    }
}