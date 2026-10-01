

//all location realted function implement here..
import 'package:geolocator/geolocator.dart';

class LocationService {




Future<LocationResult>getCurrentLocation()async{
    bool serviceEnabled= await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return LocationResult(error: LocationError.serviceDisabled);
    }
    LocationPermission checkPermission=await Geolocator.checkPermission();

    if(checkPermission==LocationPermission.denied){ //for 1 user or if user denied previous.
      checkPermission = await Geolocator.requestPermission();

    }
    if(checkPermission==LocationPermission.deniedForever){
      return LocationResult(error: LocationError.permissionDeniedForever); //forevr denied
    }
    if (checkPermission == LocationPermission.denied) {
      return LocationResult(error: LocationError.permissionDenied);
    }

    return  LocationResult(position: await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ));
}
}


// creating a class for store location position and error reason to get why posiiton is return null the reason get from eror varible


enum LocationError {serviceDisabled, permissionDenied, permissionDeniedForever}
// enum defined because we know these 3 only option cause for fail fetch device location fixed and also prevent typo error
class LocationResult{ //this class store both result either positon get or failed with some reason
  Position? position; //null operotr use because one of them can be null on run time to prevent null check
  LocationError? error;
  LocationResult({this.position, this.error});
}