import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:location/location.dart' as LocationManager;

class MapPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MapPage> {
  GoogleMapController mapController;

  var location = Location();
  var currentLocation = <String, double>{};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    refresh();
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation = <String, double>{};
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation["latitude"];
      final lng = currentLocation["longitude"];
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  void refresh() async {
    final center = await getUserLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emrals Map'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        options: GoogleMapOptions(
          trackCameraPosition: true,
          myLocationEnabled: true,
          cameraPosition: const CameraPosition(
            target: LatLng(0.0, 0.0),
          ),
        ),
      ),
    );
  }
}