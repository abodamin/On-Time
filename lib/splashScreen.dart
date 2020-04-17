import 'package:flutter/material.dart';
import 'package:on_time/main.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 1,
      navigateAfterSeconds: MyApp(),
      title: Text('On Time', style: Theme.of(context).textTheme.display2,),
      image: Image.asset("assets/images/bus.png"),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.green[700]
    );
  }
}