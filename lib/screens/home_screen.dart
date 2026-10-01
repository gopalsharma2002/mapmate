import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmate/models/route_model.dart';
import 'package:mapmate/services/location_service.dart';
import 'package:mapmate/services/route_service.dart';

import 'search_screen.dart';
import '../services/search_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController =
      TextEditingController(); //search controller
  LatLng? currentLocation; //current location value store in this varible intialial its null
  LocationError? locationError; //store error reason
  bool loading = false; //loader

  final RouteService _routeService=RouteService(); //object of route service

  RouteModel? _routeInfo; //varible which stroe route info(time,dis,point => model class)

  final MapController _mapController =
      MapController(); // for move map at searched location
  // search varibles
  final SearchService _searchService =
      SearchService(); // sercive object needed to call fucntion api
  LatLng? searchedLocation; //store search location lat long
  String? placeName; // place name store
  bool? searchLoader;
  final LocationService _locationService =
      LocationService(); // object of location service to use their fucntion

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchLocation();
  }

  // search location function...

  Future<void> _handleSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      searchLoader = true;
    });

    final result = await _searchService.fetchLocation(query);
    setState(() => searchLoader = false);

    if (result.isNotEmpty) {
      final data = result.first;

      setState(() {
        searchedLocation = LatLng(data.latitude, data.longitude);
        placeName = data.displayName;
      });
      _mapController.move(searchedLocation!, 19);
//when recieve both coordinate instant call route fucntion
      final route=await _routeService.fetchRoute(currentLocation!, searchedLocation!);

      setState(() {
        _routeInfo= route; // all info routes stroe in route varible and pss to  route info
        searchLoader=false;
      });
    }
    else{
      if(mounted)
        {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location not found')),
          );
        }
    }
  }

  //main fucntion to fetch user curent location and store in that curent location vrible dtatype latlng

  Future<void> _fetchLocation() async {
    setState(() {
      loading = true;
    });
    final result = await _locationService.getCurrentLocation();

    setState(() {
      loading = false;
      if (result.position != null) {
        currentLocation = LatLng(
          result.position!.latitude,
          result.position!.longitude,
        );
        locationError = null;
      } else {
        locationError = result.error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: searchedLocation == null,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;


        setState(() {
          searchedLocation = null;
          placeName = null;
          _routeInfo = null;
          _searchController.clear();
        });
        _mapController.move(currentLocation!, 15);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MapMate'),
          backgroundColor: const Color(
            0xFF2E8B87,
          ), // sea green - splash se consistent
          foregroundColor: Colors.white,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (locationError != null) {
      return _buildErrorUI();
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: currentLocation!, //once show starting point its now change dynmically
            initialZoom: 14,
            maxZoom: 19,
            minZoom: 3,
          ),

          children: [
            TileLayer(
              maxZoom: 19,
              userAgentPackageName: "com.example.mapmate",
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            if(_routeInfo!=null) //only show route if route fetch from api to prevent null crash
              PolylineLayer(polylines: [ //its  a widget in flutter map to draw multiple lines on map
                Polyline( // take point list and mae a line on map
                  points: _routeInfo!.points,

                  color: const Color(0xFF2E8B87),   // sea green -
                  strokeWidth: 4,


                )
              ]),
            if (currentLocation != null)
              MarkerLayer(
                markers: // its place specific pin at the current exact coordiante in the map
                [
                  Marker(
                    point: currentLocation!,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  //search location marker

                  if(searchedLocation!=null)
                    Marker(
                      point: searchedLocation!,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                ],
              ),
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: SearchBarWidget(
              controller: _searchController,
              onSearch: () {
                _handleSearch();
              },
            ),
          ),
        ),
        if(_routeInfo!=null) // if route data not null a card show distnce and tym btw routes
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem(Icons.directions, _routeInfo!.distanceText, 'Distance'),
                  Container(width: 1, height: 40, color: Colors.grey[300]),
                  _buildInfoItem(Icons.access_time, _routeInfo!.durationText, 'Time'),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF2E8B87), size: 22),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
  Widget _buildErrorUI() {
    String message;
    String buttonText;
    VoidCallback onPressed;

    switch (locationError!) {
      case LocationError.serviceDisabled:
        message = 'Location is turned off. Please enable GPS to continue.';
        buttonText = 'Open Location Settings';
        onPressed = () => Geolocator.openLocationSettings();
        break;

      case LocationError.permissionDenied:
        message = 'Location permission is needed to show the map.';
        buttonText = 'Try Again';
        onPressed = _fetchLocation;
        break;

      case LocationError.permissionDeniedForever:
        message = 'Location permission was permanently denied. Please enable it from app settings.';
        buttonText = 'Open App Settings';
        onPressed = () => Geolocator.openAppSettings();
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onPressed, child: Text(buttonText)),
          ],
        ),
      ),
    );
  }
}
