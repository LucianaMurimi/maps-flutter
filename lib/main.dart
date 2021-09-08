import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapHome extends StatefulWidget {
  @override
  State<MapHome> createState() => MapHomeState();
}

class MapHomeState extends State<MapHome> {

  Completer<GoogleMapController> _controller = Completer();
  static late final CameraPosition _currentLocationCameraPosition;


  // getLocation function => gets the current location
  getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    _currentLocationCameraPosition = CameraPosition(
      target: LatLng(_locationData.latitude!, _locationData.longitude!),
      zoom: 14.4746,
    );

    print(_locationData);
    return _locationData;
  }

  //----------------------------------------------------------------------------
  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(-3.3990299, 6.8009855),  // LatLng of NM-AIST as returned by the getLocation function
    zoom: 14.4746,
  );


  //----------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    super.initState();
  }

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },

        markers: Set<Marker>.of([Marker(
          position: LatLng(-3.3990299, 6.8009855), // LatLng of NM-AIST as returned by the getLocation function
          markerId: const MarkerId('NM-AIST'),
          infoWindow: const InfoWindow(title: 'Nelson Mandela African Institute of Science and Technology'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: (){}
        ),]),

      ),
    );
  }

}