import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mock_data/mock_data.dart';

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
  List<String> _arrivingTimes;
   List<DateTime> _myTimings = List<DateTime>();//
  // _arrivingTimes =
  //     "02:30,03:29,03:54,04:36,04:59,05:20,05:30,05:55,06:10,06:20,06:50,07:10,07:21,07:44,07:53,08:05,08:20,08:40,08:50,08:58,09:00,09:08,09:20,09:26,9:33,9:43,9:51,10:00,10:05,10:10,10:11,10:15,10:25,10:56,11:06,11:10,11:20,11:27,11:35,11:40,11:55,11:55,11:59"
  //         .split(',')
  //         .toList();
  List<String> _myMockTimings = "2020-02-28 1:00:58.921456 , 2020-02-28 1:16:58.921456, 2020-02-28 1:26:58.921456 , 2020-02-28 1:46:58.921456 , 2020-02-28 2:00:58.921456 , 2020-02-28 2:16:58.921456, 2020-02-28 2:26:58.921456 , 2020-02-28 2:46:58.921456 , 2020-02-28 3:00:58.921456 , 2020-02-28 3:16:58.921456, 2020-02-28 3:26:58.921456 , 2020-02-28 3:46:58.921456 , 2020-02-28 4:00:58.921456 , 2020-02-28 4:16:58.921456, 2020-02-28 4:26:58.921456 , 2020-02-28 4:46:58.921456 , 2020-02-28 5:00:58.921456 , 2020-02-28 5:16:58.921456, 2020-02-28 5:26:58.921456 , 2020-02-28 5:46:58.921456 , 2020-02-28 6:00:58.921456 , 2020-02-28 6:16:58.921456, 2020-02-28 6:26:58.921456 , 2020-02-28 6:46:58.921456 , 2020-02-28 7:00:58.921456 , 2020-02-28 7:16:58.921456, 2020-02-28 7:26:58.921456 , 2020-02-28 7:46:58.921456 , 2020-02-28 8:00:58.921456 , 2020-02-28 8:16:58.921456, 2020-02-28 8:26:58.921456 , 2020-02-28 8:46:58.921456, 2020-02-28 9:00:58.921456 , 2020-02-28 9:16:58.921456, 2020-02-28 9:26:58.921456 , 2020-02-28 9:46:58.921456, 2020-02-28 10:00:58.921456 , 2020-02-28 10:16:58.921456, 2020-02-28 10:26:58.921456 , 2020-02-28 10:46:58.921456, 2020-02-28 11:00:58.921456 , 2020-02-28 11:16:58.921456, 2020-02-28 11:26:58.921456 , 2020-02-28 11:46:58.921456 ".split(',').toList();
  
  List<DateTime> _mockTimes;
  var _currentTime;
  var _nextBus;
  DateTime _endTime;
  DateTime _startingTime;

  @override
  void initState() {
    //generate Mock Dates as the bus arriving time.
    _currentTime = DateTime.now();
    _startingTime = _currentTime.subtract(Duration(days: 1));
    _endTime = _currentTime.add(Duration(days: 1));
    _generateMockTimes(_startingTime, _endTime); //automatically will be assigned to mockTimes.
    _nextBus = _getNextBusTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('$_currentTime');
    

    return SingleChildScrollView(
      child: Container(
        child: Column(children: <Widget>[
          Text('This bus arrives at : ${_nextBus}'),
        ]),
      ),
    );
  }

  _getNextBusTime() {
    var temp;
    // "2020-02-28 1:00:58.921456"
//     _myMockTimings.forEach((f){
//       String date = f;
// String dateWithT = date.substring(0, 10) + 'T' + date.substring(11);
// DateTime dateTime = DateTime.parse(dateWithT);
// print(dateTime);
//     });

//     for(int i=0; i < _myMockTimings.length; i++ ){
//       temp = DateTime.parse(_myMockTimings.elementAt(i).trim());
//       if( ! _currentTime.isAfter(temp) ){
//         //if true take the previous one
//         _nextBus = temp;
//       }
//     }
    for(int i=0; i<_myTimings.length; i++){
      // print('${_myTimings.elementAt(i)} , type is : ${_myTimings.elementAt(i).runtimeType}');//checked it is all DateTime Type
      if( _myTimings.elementAt(i).isAfter(_currentTime)){
        setState(() {
        //  _nextBus = DateFormat.Hm(_myTimings.elementAt(i));
         return _nextBus = DateFormat('kk:mm').format(_myTimings.elementAt(++i%_myTimings.length));
        // _nextBus = _myTimings.elementAt(i);
        });
      }
    }
    return _nextBus;
  }


  void _generateMockTimes(DateTime startingTime, DateTime endTime) {
    _mockTimes = new List<DateTime>();
    // _myMockTimings.clear();
   //TODO: use DateTame.now() then just take the Date and Append the rest as 00:00. to be used as starting time.
    var _start = DateTime.parse("2020-03-01T14Z"); //just two houres before current time.
    print('_________start : $_start : type is : ${_start.runtimeType}');
    _myTimings.add(_start);
    //this method calls mockDate as many times we want (50) to fill our bus arriving times table.
    for (int i = 0; i < 50; i++) {
      // _mockTimes.add(mockDate(startingTime, endTime));
      var addedTime = _start.add(Duration(minutes: 15 )); //add 15 minutes
      _start = addedTime; //add then assign the new value.
      _myTimings.add(_start);//use new Value of _start.
    }
    // _mockTimes.forEach((f)=> print(f));
    // print('_start : $_start');
    _myTimings.forEach((f)=> print('**$f'));

  }
}
