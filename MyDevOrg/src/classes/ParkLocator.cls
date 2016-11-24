/*

        Description    :    This class make a http request(SOAP REQUEST).

*/
public class ParkLocator{

    public static List<String> country(String countryName){
        List<String> parkList = new List<String>();
        ParkService.ParksImplPort park = new ParkService.ParksImplPort();
        parkList = park.byCountry(countryName);
        system.debug('#### '+parkList);
        return parkList;
    }
}