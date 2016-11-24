@isTest
global class ParkServiceMock implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        // start - specify the response you want to send
        ParkService.byCountryResponse response_x = new ParkService.byCountryResponse();
        List<String> cunList = new List<String>{'Yellowstone', 'Mackinac National Park', 'Yosemite'};
        response_x.return_x = cunList;
        // end
        response.put('response_x', response_x); 
   }
}