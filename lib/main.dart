import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController mapController;
  bool _visibility = false;
  final LatLng _center = const LatLng(24.774265, 46.738586);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> _markers;
  List<String> _randomLocations =
      '24.86146928,46.69903575,24.88316324,46.69854317,24.93996718,46.76643857,24.6993607,46.56438094,24.69793692,46.69062082,24.63449564,46.69748834,24.79167131,46.59003239,24.80303949,46.72174665,24.63893682,46.72256229,24.7844077,46.84134829,24.67704144,46.79674636,24.64808747,46.6998683,24.6202194,46.71829173,24.73029649,46.67289744,24.82366259,46.63587723,24.93323531,46.66575324,24.80882471,46.56780604,24.71954391,46.76374092,24.62784976,46.7145642'
          .split(',')
          .toList();

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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
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
}

class BusArrivingTime extends StatefulWidget {
  @override
  _BusArrivingTimeState createState() => _BusArrivingTimeState();
}

class _BusArrivingTimeState extends State<BusArrivingTime> {
   
   List<DateTime> _busTimings = List<DateTime>();
  // List<String> _myMockTimings = "2020-02-28 1:00:58.921456 , 2020-02-28 1:16:58.921456, 2020-02-28 1:26:58.921456 , 2020-02-28 1:46:58.921456 , 2020-02-28 2:00:58.921456 , 2020-02-28 2:16:58.921456, 2020-02-28 2:26:58.921456 , 2020-02-28 2:46:58.921456 , 2020-02-28 3:00:58.921456 , 2020-02-28 3:16:58.921456, 2020-02-28 3:26:58.921456 , 2020-02-28 3:46:58.921456 , 2020-02-28 4:00:58.921456 , 2020-02-28 4:16:58.921456, 2020-02-28 4:26:58.921456 , 2020-02-28 4:46:58.921456 , 2020-02-28 5:00:58.921456 , 2020-02-28 5:16:58.921456, 2020-02-28 5:26:58.921456 , 2020-02-28 5:46:58.921456 , 2020-02-28 6:00:58.921456 , 2020-02-28 6:16:58.921456, 2020-02-28 6:26:58.921456 , 2020-02-28 6:46:58.921456 , 2020-02-28 7:00:58.921456 , 2020-02-28 7:16:58.921456, 2020-02-28 7:26:58.921456 , 2020-02-28 7:46:58.921456 , 2020-02-28 8:00:58.921456 , 2020-02-28 8:16:58.921456, 2020-02-28 8:26:58.921456 , 2020-02-28 8:46:58.921456, 2020-02-28 9:00:58.921456 , 2020-02-28 9:16:58.921456, 2020-02-28 9:26:58.921456 , 2020-02-28 9:46:58.921456, 2020-02-28 10:00:58.921456 , 2020-02-28 10:16:58.921456, 2020-02-28 10:26:58.921456 , 2020-02-28 10:46:58.921456, 2020-02-28 11:00:58.921456 , 2020-02-28 11:16:58.921456, 2020-02-28 11:26:58.921456 , 2020-02-28 11:46:58.921456 ".split(',').toList();
  var _currentTime;
  var _nextBus;
  DateTime _startingTime;

  @override
  void initState() {
    _currentTime = DateTime.now(); //take the current time
    print('_currentTime : $_currentTime');//just print it
    _generateBusArrivingTimes(_startingTime); //automatically will be assigned to mockTimes.
    _nextBus = _getNextBusTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
          Text('This bus arrives at : $_nextBus'),
         ],
        ),
      ),
    );
  }

  String _getNextBusTime() {
    for(int i=0; i<_busTimings.length; i++){
      _nextBus = _busTimings.first;// default value is first element.
      if( _busTimings.elementAt(i).isAfter(_currentTime)){
        print('inside IF STATEMENT $i');
        var temp = _busTimings.elementAt(i);
        return DateFormat('kk:mm').format(temp);
      }
    }
    return _nextBus;
  }


  void _generateBusArrivingTimes(DateTime startingTime) {
    DateTime _start;
    _start = _currentTime.subtract(Duration(hours: 2));//just Start before two houres from now. 
    _busTimings.add(_start);
    print('_________start : $_start');
    //each hour has 4 quarters (4*15) = 1 houre, day has 24 houres so.. .(4*24)=96 this means we have 96 quarters per day but we don't want to start at 12 for example and end at 12, we want to start at 12 and end at 11:45 that's why we used 95 (96 - 1 = 95).
    for (int i = 0; i < 95; i++) {
      _start = _start.add( Duration(minutes: 15) ); //add 15 minutes then update the value of _start NOTE: this add is like plus "+"
      _busTimings.add(_start); //NOTE: this add means 'add' to List<>.
    }
    _busTimings.forEach((f)=> print('**$f'));
    print('\n');
  }
}
