import 'package:binaryflutterapp/src/shared/colors.dart';
import 'package:binaryflutterapp/src/shared/hex_color.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback action;
  final String message;

  ErrorView({@required this.action, @required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          message,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25),
          child: FloatingActionButton(
            backgroundColor: HexColor.hexToColor(AppColors.primaryColor),
            child: Icon(
              Icons.refresh,
              size: 30,
              color: HexColor.hexToColor(AppColors.accentColor),
            ),
            onPressed: action,
          ),
        ),
      ],
    );
  }
}
