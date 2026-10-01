import 'package:latlong2/latlong.dart';

class RouteModel {
  final List<LatLng>points; // OSM give 200-300 small points so joins this make a line  on map
  final double distanceInMtr; //distnce btw 2 point
  final double durationInSec;//time tken

RouteModel({required this.points,required this.distanceInMtr,required this.durationInSec});

  String get distanceText {
    final km = distanceInMtr / 1000;
    return '${km.toStringAsFixed(1)} km';   // rount only decimal 1 ex. 45.2 not 45.33"
  }

  // converted text in hr/min duration
  String get durationText {
    final totalMinutes = (durationInSec / 60).round();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours > 0) {
      return '$hours hr $minutes min';
    } else {
      return '$minutes min';
    }
  }
}