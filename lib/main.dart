import 'dart:async';

import 'package:flutterkaoyaya/common/utils.dart';
import 'package:flutter/material.dart';
import 'index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo12',
        theme: ThemeData(
          primaryColor: Colors.white,
          platform: TargetPlatform.iOS
        ),
        home: SplashScreen());
  }
}


//欢迎界面。
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (context) {
      return new Index();
    }));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Image.asset(
          'assets/images/launchimg.png',
          fit: BoxFit.fill,
          width: Utils.getScreenWidth(context),
          height: Utils.getScreenHeight(context),
        ),
      ),
    );
  }
}
