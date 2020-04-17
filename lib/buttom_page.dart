import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    debugPrint('_currentTime : $_currentTime');//just print it
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
          Text('This bus arrives at : $_nextBus', style: TextStyle(fontSize: 20),),
         ],
        ),
      ),
    );
  }

  String _getNextBusTime() {
    for(int i=0; i<_busTimings.length; i++){
      if( _busTimings.elementAt(i).isAfter(_currentTime)){
        print('inside IF STATEMENT $i');
        var temp = _busTimings.elementAt(i);
        return DateFormat('kk:mm').format(temp);
      }
      _nextBus = _busTimings.first; //default value if never found next bus time.
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
    // _busTimings.forEach((f)=> print('**$f'));
    // print('\n');
  }
}
