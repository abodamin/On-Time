import 'package:flutter/material.dart';

class BusArrivingTime extends StatefulWidget {
  @override
  _BusArrivingTimeState createState() => _BusArrivingTimeState();
}

class _BusArrivingTimeState extends State<BusArrivingTime> {
  // List<String> _myMockTimings = "2020-02-28 1:00:58.921456 , 2020-02-28 1:16:58.921456, 2020-02-28 1:26:58.921456 , 2020-02-28 1:46:58.921456 , 2020-02-28 2:00:58.921456 , 2020-02-28 2:16:58.921456, 2020-02-28 2:26:58.921456 , 2020-02-28 2:46:58.921456 , 2020-02-28 3:00:58.921456 , 2020-02-28 3:16:58.921456, 2020-02-28 3:26:58.921456 , 2020-02-28 3:46:58.921456 , 2020-02-28 4:00:58.921456 , 2020-02-28 4:16:58.921456, 2020-02-28 4:26:58.921456 , 2020-02-28 4:46:58.921456 , 2020-02-28 5:00:58.921456 , 2020-02-28 5:16:58.921456, 2020-02-28 5:26:58.921456 , 2020-02-28 5:46:58.921456 , 2020-02-28 6:00:58.921456 , 2020-02-28 6:16:58.921456, 2020-02-28 6:26:58.921456 , 2020-02-28 6:46:58.921456 , 2020-02-28 7:00:58.921456 , 2020-02-28 7:16:58.921456, 2020-02-28 7:26:58.921456 , 2020-02-28 7:46:58.921456 , 2020-02-28 8:00:58.921456 , 2020-02-28 8:16:58.921456, 2020-02-28 8:26:58.921456 , 2020-02-28 8:46:58.921456, 2020-02-28 9:00:58.921456 , 2020-02-28 9:16:58.921456, 2020-02-28 9:26:58.921456 , 2020-02-28 9:46:58.921456, 2020-02-28 10:00:58.921456 , 2020-02-28 10:16:58.921456, 2020-02-28 10:26:58.921456 , 2020-02-28 10:46:58.921456, 2020-02-28 11:00:58.921456 , 2020-02-28 11:16:58.921456, 2020-02-28 11:26:58.921456 , 2020-02-28 11:46:58.921456 ".split(',').toList();
  var _nextBus;

  @override
  void initState() {
    _nextBus = _getNextBusTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
          Text('This bus comes after: $_nextBus min', style: TextStyle(fontSize: 20),),
         ],
        ),
      ),
    );
  }

  int _getNextBusTime() {
    int result = 1000;
    int minute = DateTime.now().minute;
    print("_________DATE TIME NOW MINUTE IS: $minute");
    List<int> times = [15, 30, 45, 59]; //q1 = 15, q2 = 30, q3 = 45, q4 = 59.
    for(int i=0; i < times.length; i++){
      int temp = times.elementAt(i) - minute;
      if(temp >= 0 && temp <= result){ //temp is positive & less than 1000
        result = temp;
        return result;
      }
    }
    return result;
  }
}
