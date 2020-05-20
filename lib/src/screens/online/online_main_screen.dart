import 'package:flutter/material.dart';

class OnlineScreen extends StatelessWidget {
  static const String _title = 'Online Screen';

  @override
  Widget build(BuildContext context) {
    return OnlineStatefulWidget();
  }
}

class OnlineStatefulWidget extends StatefulWidget {
  OnlineStatefulWidget({Key key}) : super(key: key);

  @override
  _OnlineStatefulWidgetState createState() => _OnlineStatefulWidgetState();
}

class _OnlineStatefulWidgetState extends State<OnlineStatefulWidget> {
  int _count = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('You have pressed the button $_count times.')),
    );
  }
}
