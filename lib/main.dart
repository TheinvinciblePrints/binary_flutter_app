import 'package:binaryflutterapp/src/enums/connectivity_status.dart';
import 'package:binaryflutterapp/src/repository/user_repository.dart';
import 'package:binaryflutterapp/src/screens/home_screen.dart';
import 'package:binaryflutterapp/src/services/connectivity_service.dart';
import 'package:binaryflutterapp/src/shared/colors.dart';
import 'package:binaryflutterapp/src/shared/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  static String tag = 'home-page';

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: HexColor.hexToColor(AppColors.primaryColor),
        accentColor: HexColor.hexToColor(AppColors.accentColor),
      ),
      home: StreamProvider<ConnectivityStatus>(
        create: (context) {
          return ConnectivityService().connectionStatusController.stream;
        },
        child: HomeScreen(),
      ),
    );
  }
}
