import 'package:binaryflutterapp/src/config/colors.dart';
import 'package:binaryflutterapp/src/screens/offline/offline_landing_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyApp extends StatefulWidget {
  static String tag = 'home-page';
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Hexcolor(AppColors.primaryColor),
        accentColor: Hexcolor(AppColors.accentColor),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder:
            (BuildContext ctxt, AsyncSnapshot<ConnectivityResult> snapShot) {
          if (!snapShot.hasData) return CircularProgressIndicator();
          var result = snapShot.data;
          switch (result) {
            case ConnectivityResult.none:
              print("no net");
              return OfflineLandingScreen();
            case ConnectivityResult.mobile:
            case ConnectivityResult.wifi:
              print("yes net");
//              return OnlineLandingScreen();
              return OfflineLandingScreen();
            default:
              return OfflineLandingScreen();
          }
        });
  }
}
