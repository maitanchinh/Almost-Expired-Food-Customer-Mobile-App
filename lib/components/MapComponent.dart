import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapComponent extends StatefulWidget {
  const MapComponent({Key? key}) : super(key: key);

  @override
  State<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  Position _currentPosition = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.timestamp(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentPosition = position;
        });
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Location permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _currentPosition.latitude == 0 && _currentPosition.longitude == 0 ? Center(child: CircularProgressIndicator(),) : GoogleMap(
        initialCameraPosition: CameraPosition(
            target:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
                zoom: 12.0), myLocationButtonEnabled: true, myLocationEnabled: true,);
  }
}
