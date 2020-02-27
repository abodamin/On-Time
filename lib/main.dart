import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(24.774265, 46.738586);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> _markers;
  String _randomLocations =
        '24.86146928,46.69903575,24.88316324,46.69854317,24.93996718,46.76643857,24.6993607,46.56438094,24.69793692,46.69062082,24.63449564,46.69748834,24.79167131,46.59003239,24.80303949,46.72174665,24.63893682,46.72256229,24.7844077,46.84134829,24.67704144,46.79674636,24.64808747,46.6998683,24.6202194,46.71829173,24.73029649,46.67289744,24.82366259,46.63587723,24.93323531,46.66575324,24.80882471,46.56780604,24.71954391,46.76374092,24.62784976,46.7145642';

  @override
  void initState() {
    super.initState();
//  WidgetsBinding.instance.addPostFrameCallback((_){
// _markers = _generateMarkers();
//  });
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _markers = _generateMarkers();
  }

  Set<Marker> _generateMarkers() {
    var _lat, _lon;
    _markers = {};
    List<String> _split = _randomLocations.split(',').toList();

    for (int i = 0; i < _split.length-1; i + 2) {
      _lat = double.parse(_split.elementAt(i));
      _lon = double.parse(_split.elementAt(++i));

      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(_lat, _lon),
          infoWindow: InfoWindow(
            title: 'Bus Station $i',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }
    return _markers;
  }

    void _onAddMarkerButtonPressed() {
      _markers = {};
      Random _random = new Random();
      
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_random.nextInt(1000).toString()),
        position: _center,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          markers: _markers,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onAddMarkerButtonPressed,
        ),
      ),
    );
  }
}
