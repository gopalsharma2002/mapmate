import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmate/models/route_model.dart';

class RouteService {
  final Dio _dio = Dio();
  // URL of find route btw 2 place on OSM  fixed
  // https://router.project-osrm.org/route/v1/driving/{start_lng},{start_lat};{end_lng},{end_lat}?overview=full&geometries=geojson
  Future<RouteModel?> fetchRoute(LatLng startPoint, LatLng endPoint) async {
    try {
      final url =
          "https://router.project-osrm.org/route/v1/driving/${startPoint.longitude},${startPoint.latitude};${endPoint.longitude},${endPoint.latitude}";

      final response = await _dio.get(
        url,
        queryParameters: {
          'overview': 'full', // as per url from this we get full detailed path route
          'geometries': 'geojson',//data neede in json format not encodd string
        },
      );

      print("route response ${response.data}");

      final coordinates =
         await response.data['routes'][0]['geometry']['coordinates']
              as List; //get first index data from api response as this type

      final points = coordinates
          .map((item) => LatLng(item[1], item[0]))
          .toList(); //oSM give long lat but we need lat long so replace its index

      final dis = response.data['routes'][0]['legs'][0]['distance'].toDouble();
      final time = response.data['routes'][0]['legs'][0]['duration'].toDouble();

      return RouteModel(
        points: points,
        distanceInMtr: dis,
        durationInSec: time,
      );
    } catch (e) {
      if (e is DioException) {
        print('Route Request URL: ${e.requestOptions.uri}');
        print('Route Response: ${e.response?.data}');
      }
      print("route error :$e");
      return null;
    }
  }
}
