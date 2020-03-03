import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'buttom_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  GoogleMapController mapController;
  bool _visibility = false;
  LatLng _center = const LatLng(24.774265, 46.738586);
  LatLng _userPosition;
  Uint8List byteData;
  Set<Marker> _markers;
  List<String> _randomLocations =
      '24.86146928,46.69903575,24.88316324,46.69854317,24.93996718,46.76643857,24.6993607,46.56438094,24.69793692,46.69062082,24.63449564,46.69748834,24.79167131,46.59003239,24.80303949,46.72174665,24.63893682,46.72256229,24.7844077,46.84134829,24.67704144,46.79674636,24.64808747,46.6998683,24.6202194,46.71829173,24.73029649,46.67289744,24.82366259,46.63587723,24.93323531,46.66575324,24.80882471,46.56780604,24.71954391,46.76374092,24.62784976,46.7145642'
          .split(',')
          .toList();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    getUserLocation();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      byteData = await getUserLocationIcon(context);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _markers = _generateMarkers();
  }

  Set<Marker> _generateMarkers() {
    var _lat, _lon;
    _markers = {};

    for (int i = 0; i < _randomLocations.length - 1; i + 2) {
      _lat = double.parse(_randomLocations.elementAt(i));
      _lon = double.parse(_randomLocations.elementAt(++i));

      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(_lat, _lon),
          infoWindow: InfoWindow(
            title: 'Bus Station $i',
          ),
          onTap: () {
            setState(() {
              _visibility = !_visibility;
            });
          },
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }
    return _markers;
  }

  @override
  Widget build(BuildContext context) {
    print('location : $_locationData');
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () async {
          await getUserLocation();
          setState(() {
            _markers.add(Marker(
              markerId: MarkerId('userLocation'),
              position: _userPosition,
              icon: BitmapDescriptor.fromBytes(byteData),
            ));
          });
        }),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              markers: _markers,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200,
                child: Visibility(
                  visible: _visibility,
                  child: Card(
                    child: Center(
                      child: BusArrivingTime(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUserLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    _locationData = await location.getLocation();

    _userPosition = LatLng(_locationData.latitude, _locationData.longitude); //if location is not null will use location, but if it is null use the same old value '_center'
  }
   
   Future<Uint8List> getUserLocationIcon(context) async {
    var temp = await DefaultAssetBundle.of(context).load('assets/images/user_location.png');
    return temp.buffer.asUint8List();
  }
}
