public class Assign6XmlController{
    public List<ModalXml> modalx{get;set;}
    private xmldom xmlObject; 
    
    ////////Constractor////////
    
    public Assign6XmlController(){
        List<Contact> con_list = new List<Contact>();
        modalx = new List<ModalXml>();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://mufiz12ka4-developer-edition.ap1.force.com/xmlParse');
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);
        String xml = response.getBody();
        xmlObject = new xmldom(xml);
        parse();
    }
    
    //////Function for getting Data////////
    
    public void parse(){
        integer i=1;
        List<xmldom.Element> xmlelements = xmlObject.getElementsByTagName('contact');
        for(xmldom.Element element : xmlelements){
            ModalXml mxml = new ModalXml();
            for(xmldom.Element node : element.ChildNodes){
                if(node.nodeName.toLowerCase()=='name'){
                    mxml.name = node.nodeValue;
                }
                if(node.nodeName.toLowerCase()=='phone'){
                    mxml.phone= node.nodeValue;
                }
                if(node.nodeName.toLowerCase()=='webiste'){
                    mxml.website= node.nodeValue;
                }
            }
            mxml.s_no = i;
            modalx.add(mxml);
            i++;
        }
        
    }
    
    /////Modal Class//////
    
    public class ModalXml{
        public integer s_no{get;set;}
        public String name{get;set;}
        public String phone{get;set;}
        public String website{get;set;}
    }
}