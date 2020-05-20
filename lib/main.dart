import 'package:binaryflutterapp/src/bloc/mainpage/app_option_bloc.dart';
import 'package:binaryflutterapp/src/config/colors.dart';
import 'package:binaryflutterapp/src/screens/offline/offline_landing_screen.dart';
import 'package:binaryflutterapp/src/screens/online/online_main_screen.dart';
import 'package:binaryflutterapp/src/utils/string_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Hexcolor(AppColors.primaryColor),
        accentColor: Hexcolor(AppColors.accentColor),
      ),
      home: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(StringUtils.app_title),
        ),
        body: FutureBuilder(
          future: bloc.getSharedPrefSavedOption(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data) {
                case 'Offline':
                  return OfflineScreen();
                  break;
                case 'Online':
                  return OnlineScreen();
                  break;
                case 'none':
                  return RadioGroup();
                  break;
                default:
                  return Container();
                  break;
              }
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Container();
            } else {
              return Container();
            }
          }, // access the data in our Stream here
        ),
      ),
    );
  }
}

class RadioGroup extends StatefulWidget {
  @override
  RadioGroupWidget createState() => RadioGroupWidget();

  dispose() {
    /*close the stream in order
    to avoid memory leaks
    */
    bloc.dispose();
  }
}

class RadioGroupWidget extends State<RadioGroup> {
  String savedMode;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.getOption,
        builder: (context, snapshot) {
          return optionDialog();
        });
  }

  Widget _dialogTopView() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Text(
        'Choose an option to proceed',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'helvetica_neue_light',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _dialogCenterView() {
    return Container(
      child: Column(
        children: <Widget>[
          _myRadioButton(
              title: "Offline",
              value: 0,
              onChanged: (newValue) => bloc.updateOption(newValue)
//                      setState(() => _groupValue = newValue),
              ),
          _myRadioButton(
            title: "Online",
            value: 1,
            onChanged: (newValue) => bloc.updateOption(newValue),
          ),
        ],
      ),
    );
  }

  Widget _dialogBottomView() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          color: Hexcolor(AppColors.accentColor),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32.0),
              bottomRight: Radius.circular(32.0)),
        ),
        child: FlatButton(
          onPressed: () {
            if (bloc.getSelectedOption().isEmpty) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Please choose an option to continue'),
              ));
            } else {
              // save to sharedpreference

              bloc.saveOption(bloc.appOptionProvider.selectedOption);
            }
          },
          child: Text(
            "Submit",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: bloc.appOptionProvider.currentOption,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  Widget optionDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _dialogTopView(),
            SizedBox(
              height: 5.0,
            ),
            Divider(
              color: Colors.grey,
              height: 4.0,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: _dialogCenterView(),
            ),
            _dialogBottomView(),
          ],
        ),
      ),
    );
  }
}
