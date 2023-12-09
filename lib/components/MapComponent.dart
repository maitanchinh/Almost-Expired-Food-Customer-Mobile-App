import 'package:appetit/cubit/branch/branchs_cubit.dart';
import 'package:appetit/cubit/branch/branchs_state.dart';
import 'package:appetit/screens/StoreScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapComponent extends StatefulWidget {
  const MapComponent({Key? key}) : super(key: key);

  @override
  State<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  Position _currentPosition =
      Position(longitude: 0, latitude: 0, timestamp: DateTime.timestamp(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
  late BranchsCubit _branchsCubit;
  Set<Marker> markers = {};
  @override
  void initState() {
    super.initState();
    //  _getCurrentLocation();
    _branchsCubit = BlocProvider.of<BranchsCubit>(context);
    _getBranchsNearby();
  }

  Future<void> _getCurrentLocation() async {
    PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      try {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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

  void _getBranchsNearby() async {
    await _getCurrentLocation();
    await _branchsCubit.getBranchs(latitude: _currentPosition.latitude, longitude: _currentPosition.longitude);
    if (_branchsCubit.state is BranchsSuccessState) {
      var branchs = (_branchsCubit.state as BranchsSuccessState).branchs.branchs;
      branchs!.forEach((branch) {
        markers.add(Marker(
          markerId: MarkerId(branch.id!),
          position: LatLng(branch.latitude!, branch.longitude!),
          infoWindow: InfoWindow(
            title: branch.store!.name!,
            snippet: 'Chi nhánh: ' + branch.address! + '\n Chạm vào đây để xem cửa hàng.',
            onTap: () => Navigator.pushNamed(context, StoreScreen.routeName, arguments: branch.store),
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _currentPosition.latitude == 0 && _currentPosition.longitude == 0
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 14.0),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: markers,
          );
  }
}
