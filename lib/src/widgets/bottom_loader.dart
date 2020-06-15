import 'package:flutter/material.dart';

class BottomLoader extends StatelessWidget {
  final isSearching;

  BottomLoader({this.isSearching});

  @override
  Widget build(BuildContext context) {
    if (!isSearching) {
      return Container(
        alignment: Alignment.center,
        child: Center(
          child: SizedBox(
            width: 33,
            height: 33,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
