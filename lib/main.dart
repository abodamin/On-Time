import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'buttom_page.dart';

void main()  {
  runApp(
    MainWidget()
    );
  }
class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MyApp()
      );
  }
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Location _location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  GoogleMapController _mapController;
  bool _visibility = false;
  LatLng _center = const LatLng(24.774265, 46.738586);
  LatLng _userLocation;
  Uint8List byteData;
  Set<Marker> _markers; //"points on map"
  Set<Circle> _circle;
  //this is List of Soo  any random locations, so to separeate them we used the method below called "split(',')"
  //to split the whole then put in List example: "1234, 1234, 1234" will be [1234, 1234, 1234] (like arrays)
  List<String> _randomBusLocations =
      '24.86146928,46.69903575,24.88316324,46.69854317,24.93996718,46.76643857,24.6993607,46.56438094,24.69793692,46.69062082,24.63449564,46.69748834,24.79167131,46.59003239,24.80303949,46.72174665,24.63893682,46.72256229,24.7844077,46.84134829,24.67704144,46.79674636,24.64808747,46.6998683,24.6202194,46.71829173,24.73029649,46.67289744,24.82366259,46.63587723,24.93323531,46.66575324,24.80882471,46.56780604,24.71954391,46.76374092,24.62784976,46.7145642'
          .split(',')
          .toList();

  void _onMapCreated(GoogleMapController controller) {
    //we call this method when the map is created to start controlling the map.
    //later we will use variable _mapController to animate map and zoom to user's location.
    _mapController = controller;
  }

  @override
  void initState() {
    //this method is for initilaization.
    getUserLocation(); //here we try to get the user location
    //this method means "First initilize the page then do the code below" , because it doesn't otherwise
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      byteData = await getUserLocationIcon(context); //we must give it Context to create the icon.
    });
    super.initState();// system finish initialization
  }

  @override
  void didChangeDependencies() {
    //we call this method everytime we update widgets
    super.didChangeDependencies();
    _markers = _generateMarkers();
  }

  Set<Marker> _generateMarkers() {
    //in this method we read the locations from variable _randomBusLocations 
    //and we start adding them to _markers so they appear on map
    var _lat, _lon;
    _markers = {};

    for (int i = 0; i < _randomBusLocations.length - 1; i + 2) {
      //list is like this [12, 34, 56, 78, 9 10....]
      //so every PAIR mean Latitude &Longtitude so we take first one and the one after it (i & ++i)
       //because the variable _randomBusLocations is of type String we have to make it double, 
       //that's why  we  call method double.parse. (to convert from String to double)

      _lat = double.parse(_randomBusLocations.elementAt(i));
      _lon = double.parse(_randomBusLocations.elementAt(++i));

      //_markers is still empty list, here we inflate it with data of type Marker().
      // Marker() is built-in Object to represent markers on maps.
      //every Marker must take Id & the following data.
      _markers.add(//here we start adding
        Marker(
          markerId: MarkerId(i.toString()),//we are creating IDs by taking i and convert it to String ("1", "2", "3", ..,etc)
          position: LatLng(_lat, _lon),
          infoWindow: InfoWindow(
            title: 'Bus Station $i',
          ),
          onTap: () {
            setState(() {
              _visibility = !_visibility;
            });
          },
          icon: BitmapDescriptor.defaultMarker,//this is how we choose the normal red marker.
        ),
      );
    }
    return _markers; //return the markers, it is also no need to return it.
  }

//This method builds the Widget (Page)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(//main Widget that has many Widgets inside
        appBar: AppBar(
          title: Text('On Time'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      title: Text("Bus Timings"),
                      content: Text("all busses arrive at same time every 15 minutes"),
                    );
                  }
                );
              })
          ],
          backgroundColor: Colors.green[700],
        ),
        floatingActionButton: FloatingActionButton( //the Botton in corner.
          backgroundColor: Colors.green,
          child: Icon(Icons.my_location), //inside botton put another widget which is the Icon.
          onPressed: () async {
          _circle = {};

          await getUserLocation(); //main thread has to wait until this function end. NOTE that we get userLocation inside this method
          
          //this method is like saying (UPDATE), they just call it setState.
          setState(() {
            //again here we are adding a Mark to list of _markers BUT this marker is user location one.
            _markers.add(
              Marker(
              markerId: MarkerId('userLocation'), //we can use Aaaaannnnnny ID
              position: _userLocation, //this location is from method above getUserLocation
              icon: BitmapDescriptor.fromBytes(byteData), //Taksim
            ));

            //circle around userlocation, it is Built-in Widget.
            _circle.add(
              Circle(
                circleId: CircleId('userCircleId'), //we can use Aaaaannnnnny ID
                center: _userLocation, //same as above
                radius: 500.0, //ow big is the Circle.
                strokeWidth: 3, //the line around circle how thick do u want it.
                strokeColor: Colors.blue, //color of line  around the circle.
                fillColor: Color(0x8ABBDEFB), //color inside the circle
                ),
            );

            //after we got the location and created marker and circle around location, now we move camera to user's location.
            _mapController.animateCamera(CameraUpdate.newCameraPosition(
              //this is Built-in Widget to move camera
              CameraPosition(
                target: _userLocation,
                zoom: 14,
                ),
            ));
          });
        }),

        body: Container(
          child: Stack(
            children: <Widget>[
              //This is the MAP Widget.
              GoogleMap(
                circles: Set.of((_circle != null? [_circle.first] : [] )), //if (_circle != null){ draw the circle as we explained before} else(:) { do nothing }.
                markers: _markers, //list of markers we created.
                onMapCreated: _onMapCreated, //here we start taking control of map.
                initialCameraPosition: CameraPosition(
                  target: _center, //first location is center.
                  zoom: 11.0,
                ),
                padding: EdgeInsets.only(bottom: 100), //we want the tool bar not to be down and covered by that Bus Time Page.
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  child: Visibility(//this Widget make its child appear or disappear, according to variable _visibility.
                    visible: _visibility, //when user click on Marker we update this value to be true or false so it appear or disappear.
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
      ),
    );
  }

  //----------------------------------------
  //THIS METHOD IS FOR GETTING USER LOCATION
  //----------------------------------------
  Future<void> getUserLocation() async {
      
    _serviceEnabled = await _location.serviceEnabled(); //Checks if the location service is enabled.
    if (!_serviceEnabled) { //if it is not enabled
      _serviceEnabled = await _location.requestService(); //request from user to activate location
      if (_serviceEnabled) { //if enabled do nothing
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();//Checks if the app has permission to access location. Returns a [PermissionStatus] object. If the result is [PermissionStatus.DENIED_FOREVER], no dialog will be shown on [requestPermission].
    if (_permissionGranted == PermissionStatus.DENIED) { //if permission denied
      _permissionGranted = await _location.requestPermission(); //ask for permission
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    _locationData = await _location.getLocation(); //Gets the current location of the user. Returns a [LocationData] object.
    if(_userLocation != null ){
    _userLocation = LatLng(_locationData?.latitude, _locationData?.longitude); //if location is not null will use location, but if it is null use the same old value '_center'
    } else {
      _userLocation = _center;
    }
  }
   
   //THIS IS THE ICON OF THE USER'S LOCATION 
   Future<Uint8List> getUserLocationIcon(context) async {
    var temp = await DefaultAssetBundle.of(context).load('assets/images/user_location.png');//this is the path for the icon
    return temp.buffer.asUint8List();
  }
}
