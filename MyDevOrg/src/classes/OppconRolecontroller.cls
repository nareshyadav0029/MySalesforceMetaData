/*
             Date : 16/02/2015
            Class : OppconRolecontroller
             Page : OppconRolecontroller
      Description : This page class used to insert the Opportunity and their Contact Roles.
*/

public class OppconRolecontroller{

    //    Object Area ---->
    
    public List<Opportunity> oppList{get;set;}
    public Opportunity oppObj{get;set;}
    public List<OpportunityContactRole> roleList{get;set;}
    public List<OpportunityContactRole> insertRole{get;set;}
    public OpportunityContactRole roleObj{get;set;}
    public List<SelectOption> conList{get;set;}   
    public String seloption;
    public List<ModaloppRole> modalList{get;set;}
    public Set<String> name{get;set;}
    public Set<ID> conId{get;set;}
    
    //    End Of Object Declaration
    
    //    GET AND SET
    
    public string getseloption(){
        if(seloption==null){
            if(conlist.size()>0)
                return String.valueOf(conlist[0].getvalue()); 
            else
                return null;    
        }
        
        return seloption;        
    }
    public void setseloption(string name){
        seloption =name;
    }
    
    //    Constructor
    
    public OppconRolecontroller(){
        oppObj = new Opportunity();
        roleObj = new OpportunityContactRole();
        oppList = new List<Opportunity>();
        roleList = new List<OpportunityContactRole>();
        conList = new List<SelectOption>();
        modalList = new List<ModaloppRole>();
        name = new Set<String>();
        conId = new Set<ID>();
    }
    
    //    FUNCTION FOR ADD CONTACT ROLE
    
    public void addConrole(){
        roleList.add(roleObj);
        System.debug('####'+seloption);
        Contact con = [SELECT id, name FROM Contact WHERE id =: roleObj.ContactId];
        conList.add(new SelectOption(con.id, con.name+' '+roleObj.role));
        roleObj = new OpportunityContactRole();
    }
    
    //    FUNCTION FOR ADD OPPORTUNITY AND CONTACT ROLE 
    
    public void addOpprole(){
        for(OpportunityContactRole oc : roleList){
            name.add(oc.ContactId);
        }
        ModaloppRole mopp = new ModaloppRole();
        mopp.conName = '';
        mopp.opp = oppObj;
        mopp.oppRoleList = roleList;
        for(Contact con : [select id, name from Contact where id IN : name]){
            if(con.Name != null){
                mopp.conName += con.Name+' ,';
            }
        }
        mopp.conName =mopp.conName.substring(0,mopp.conName.length()-1);
        modalList.add(mopp);
        conId.add(seloption);
        seloption = null;
        oppObj = new Opportunity();
        conList.clear();
        roleList = new List<OpportunityContactRole>();
        name.clear();
    }
    
    //    FUNCTION FOR INSERT OPPORTUNITY AND CONTACT ROLE
    
    public pagereference saveOpp(){
        List<opportunitycontactrole> newContactRoleList = new List<opportunitycontactrole>();
        map<integer,opportunity> opportunityMap = new Map<integer,opportunity>();
        map<integer,List<opportunitycontactrole>> childMap = new Map<integer,List<opportunitycontactrole>>();

        integer index = 0;
        for(ModaloppRole m : modalList){
            opportunityMap.put(index ,m.opp);
            childMap.put(index ,m.oppRoleList);
            index ++;
        }
        if(opportunityMap.size() >0){
            try{
                insert opportunityMap.values();
            }catch(Exception e){}
        }
        for(integer i=0;i<modalList.size();i++){
            for(opportunitycontactrole c : childMap.get(i)){
                if(conId.contains(c.ContactId)){
                    c.Isprimary = true;
                }
                c.opportunityid = opportunityMap.get(i).id;
                newContactRoleList.add(c);
            }
        }
        if(newContactRoleList.size()>0){
            try{
            insert newContactRoleList;
            }catch(Exception e){}
        }
        return new pagereference('/apex/OppconRole').setRedirect(true);
    }
    
    //    MODAL CLASS
    
    public class ModaloppRole{
        public Opportunity opp{get;set;}
        public List<OpportunityContactRole> oppRoleList{get;set;}
        public String conName{get;set;}
        public ModaloppRole(){
            opp = new Opportunity();
            oppRoleList = new List<OpportunityContactRole>();
        }
    }
}