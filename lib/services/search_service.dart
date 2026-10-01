
import 'package:dio/dio.dart';


import '../models/search_model.dart';

class SearchService {
  final Dio _dio = Dio();

  /// object of dio

  Future<List<SearchModel>> fetchLocation(String query) async {
    try {
      final response = await _dio.get(
        "https://nominatim.openstreetmap.org/search", //url of search location
        queryParameters: {
          //it joins param at the end of url
          "q": query,
          "format": "json", // must be string keyword json so that api give response in simple plain json
          "limit": 5, //show only 5 limit of search place
        },
        options: Options(
          headers: {
            "User-Agent": "com.example.mapmate", //needed as per osm policy
          },
        ),
      );

      print("raw json :${response.data}");

      final List<dynamic> result = response.data;

      return result.map((item) => SearchModel.fromJson(item)).toList(); //every raw josn item converted into search model in list at once
    } catch (e) {
      if (e is DioException) {
        print('Request URL: ${e.requestOptions.uri}');
        print('Response: ${e.response?.data}');
      }
      print("error $e");
      return [];
    }
  }
}
