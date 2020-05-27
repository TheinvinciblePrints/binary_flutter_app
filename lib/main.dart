import 'package:binaryflutterapp/src/config/colors.dart';
import 'package:binaryflutterapp/src/screens/home_screen.dart';
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
      home: LandingPage(),
    );
  }

//  _hexToColor(String code) =>
//      Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
