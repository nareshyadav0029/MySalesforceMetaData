public class MapDemoController{
    public Map<id,List<Contact>> conmap{get;set;}
    public MapDemoController(){
        conmap = new Map<id,List<Contact>>();
        for(Contact con : [select id, firstname, lastname from Contact]){
            List<Contact> con_list = conmap.get(con.id);
            if(con_list == null){
                con_list = new List<Contact>();
                con_list.add(con);
            }
            conmap.put(con.id, con_list);
            system.debug('####'+conmap);
        }
    }
}