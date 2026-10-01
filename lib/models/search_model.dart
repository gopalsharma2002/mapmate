import 'dart:convert';

class SearchModel {
  final String displayName; // full search name
  final double latitude;
  final double longitude;

  SearchModel({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  //the json data come from nomination api is converted into this model
  // this model class is needed to get vdata from varibale name instead of calling json['lat'] this typed data
  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      displayName: json['display_name'],
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['lon']),
    );
  }
}
