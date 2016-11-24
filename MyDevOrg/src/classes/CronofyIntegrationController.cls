public class CronofyIntegrationController{

    // Variables, Lists Declaration
    private String access_token;
    private String refresh_token;
    private String scope1;
    private String calIds;
    public String calId{get;set;}
    public String code;
    public String events{get;set;}
    public String providerName;
    public String profileId;
    public String profileName;
    public String timeZoneId{get;set;}
    
    public string authtoken{get;set;}
    public string refereshtoken{get;set;}
    public string bodyprint{get;set;}
    
    public string CLIENT_SECRET='8wx-xOE2oFoPRO7osaIFoYYWTOm4_yMjHhdCY0ZgkuCDqIBhXhqU4xxoZvJHCuE-QCzSy-m4Q5bXsGl3OYDvMQ';
    public string CLIENT_ID='kbN6mcNoVpI4W5X_ya4U18IR3oEWHV3b';
    public string REDIRECT_URL='https://ap1.salesforce.com/apex/CronofyIntegration';
    
    //public static final string OAUTH_TOKEN_URL='https://api.cronofy.com/oauth/token';
    public string OAUTH_CODE_END_POINT_URL='https://app.cronofy.com/oauth/authorize';
    
    public string GRANT_TYPE='grant_type=authorization_code';
    
    public string SCOPE='list_calendars read_events create_event delete_event';
    
    //Constractor
    public CronofyIntegrationController(){
        events= '';
        timeZoneId =  UserInfo.getTimeZone().getID(); 
        if(ApexPages.currentPage().getParameters().get('code')!= null){
            code= String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('code'));
        }
    }
    
    public pagereference connect(){
        if(code == null){
            String x=OAUTH_CODE_END_POINT_URL+'?response_type=code'+'&scope='+EncodingUtil.urlEncode(SCOPE,'UTF-8')+'&redirect_uri='+EncodingUtil.urlEncode(REDIRECT_URL,'UTF-8')+'&client_id='+CLIENT_ID;
            
            pagereference p=new pagereference(x);
            return p;
        }else{
            getAccessToken();
            getCalendars();
        }
        return null;
    }
    
    private void getAccessToken(){
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint('https://api.cronofy.com/oauth/token');
        req.setMethod('POST');
        
        req.setHeader('Content-Type', 'application/json; charset=utf-8');  
        String reqBOdy='{'
                       +'"client_id": "'+CLIENT_ID+'",'
                       +'"client_secret": "'+CLIENT_SECRET+'",'
                       +'"grant_type": "authorization_code",'
                       +'"code": "'+code+'",'
                       +'"redirect_uri": "'+REDIRECT_URL+'"'
                       +'}';
        System.debug('******reqBOdy = '+reqBOdy);
        req.setBody(reqBOdy);
        try {
            res = http.send(req);
            // Parse JSON response to get access token.
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'access_token') {
                    parser.nextToken();
                    access_token = parser.getText();
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'refresh_token') {
                    parser.nextToken();
                    refresh_token = parser.getText();
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'scope') {
                    parser.nextToken();
                    scope1 = parser.getText();
                }
            }
            
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
        }
        
        System.debug('Access Token : '+ access_token);
        System.debug('Refresh Token : '+ refresh_token);
        System.debug('Scope1 Token : '+ scope1);
    }
    
    private void getCalendars(){
        calIds = '';
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint('https://api.cronofy.com/v1/calendars');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        req.setHeader('Authorization', 'Bearer '+access_token);
        try {
            res = http.send(req);
            System.debug('#### '+res.getBody());
            JSONParser parser = JSON.createParser(res.getBody());
            calId='';
            while (parser.nextToken() != null) {
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'provider_name') {
                    parser.nextToken();
                    providerName = parser.getText();
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'profile_id') {
                    parser.nextToken();
                    profileId = parser.getText();
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'profile_name') {
                    parser.nextToken();
                    profileName = parser.getText();
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'calendar_id') {
                    parser.nextToken();
                    calId= parser.getText();
                }
                
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'calendar_deleted') {
                    parser.nextToken();
                    if(parser.getBooleanValue()==false){
                        calIds += calId+',';
                    }
                }
                
            }
        }catch(exception e){
            
        } 
        
        System.debug('Provider Name : '+ providerName);
        System.debug('Profile Id : '+ profileId);
        System.debug('Profile Name : '+ profileName);
        System.debug('Calender Ids : '+ calId);
        System.debug('Calender deleted Ids : '+ calIds);
         
    }
    
    public void getAllEvents(){
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        Date startDate = System.today().addDays(-4);
        String fromStr = startDate.year()+'-'+startDate.month()+'-'+startDate.day();
        Date endDate = System.today().addMonths(4);
        String toStr = endDate.year()+'-'+endDate.month()+'-'+endDate.day();
        req.setEndpoint('https://api.cronofy.com/v1/events?calendar_ids[]='+calId+'&tzid='+timeZoneId+'&from='+fromStr+'&to='+toStr+'&include_managed=true');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        req.setHeader('Authorization', 'Bearer '+access_token);
        try {
            res = http.send(req);
            JSONParser parser = JSON.createParser(res.getBody());
            allevents Obj = (allevents)JSON.deserialize(res.getBody().replace('"end":', '"enddate":'), allevents.Class);
            /*while (parser.nextToken() != null){
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'calendar_id') {
                    parser.nextToken();
                    event.calendar_id = parser.getText();
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'event_uid') {
                    parser.nextToken();
                    event.event_uid = parser.getText();
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'summary') {
                    parser.nextToken();
                    event.summary = parser.getText();
                }
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'description') {
                    parser.nextToken();
                    event.description = parser.getText();
                }
            }*/
            events =+res.getBody();
            System.debug('####Result :  '+obj);
        }catch(exception e){
            
        }
    }
    
    // Wrapper class for both pages and events
    public class allevents{
        public cls_pages pages;
        public List<cls_events> events;
    }
    
    // Wrapper class for pages
    class cls_pages {
        public Integer current; //1
        public Integer total;   //1
    }
    
    // Wrapper class for events
    class cls_events {
        public String calendar_id;  //cal_VjHrUmDGpg-LAKQ8_yOQ1UvhfKYSbRH56acUQmg
        public String event_uid;    //evt_external_56330edae7d68f801b77c04c
        public String summary;  //Testing
        public String description;  //This event only for testing.
        public String start;    //2015-10-30T09:30:00Z
        public String endDate;  //2015-10-30T10:30:00Z
        public boolean deleted;
        public String created;  //2015-10-30T06:31:51Z
        public String updated;  //2015-10-30T06:32:23Z
        public cls_location location;
        public String participation_status; //accepted
        public cls_attendees[] attendees;
        public String transparency; //opaque
        public String status;   //confirmed
        public cls_categories[] categories;
    }
    class cls_location {
        public String description;  //Ajmer, Rajasthan, India
    }
    class cls_attendees {
    }
    class cls_categories {
    }
}