import 'package:binaryflutterapp/src/bloc/online/page_option_bloc.dart';
import 'package:binaryflutterapp/src/config/colors.dart';
import 'package:binaryflutterapp/src/screens/online/all_users_screen.dart';
import 'package:binaryflutterapp/src/screens/online/favourites_screen.dart';
import 'package:binaryflutterapp/src/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class OnlineLandingScreen extends StatefulWidget {
  @override
  _OnlineLandingScreenState createState() => _OnlineLandingScreenState();
}

class _OnlineLandingScreenState extends State<OnlineLandingScreen> {
  final List<String> _toggleTexts = ['All', 'Favourites'];
  PageOptionBloc pageOptionBloc;

  @override
  void initState() {
    pageOptionBloc = PageOptionBloc();
    super.initState();
  }

  @override
  void dispose() {
    pageOptionBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(StringUtils.online_title),
      ),
      resizeToAvoidBottomPadding: false,
      body: StreamBuilder(
          stream: pageOptionBloc.getPage,
          builder: (context, snapshot) {
            return Column(
              children: <Widget>[
                _bodyUI(),
                _toggleButtons(),
              ],
            );
            return Container();
          }),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Hexcolor(AppColors.primaryColor),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _toggleButtons() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 15),
          padding:
              EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ToggleButtons(
                  borderColor: Colors.black,
                  fillColor: Colors.grey,
                  borderWidth: 1.5,
                  selectedBorderColor: Colors.black,
                  selectedColor: Colors.black,
                  borderRadius: BorderRadius.circular(0),
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: Align(
                        alignment: Alignment.center,
                        child: _toggleItems(_toggleTexts[0]),
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: Align(
                        alignment: Alignment.center,
                        child: _toggleItems(_toggleTexts[1]),
                      ),
                    )
                  ],
                  onPressed: (int index) {
                    pageOptionBloc.updateOption(index);
                  },
                  isSelected: pageOptionBloc.isSelected(),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _toggleItems(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _bodyUI() {
    return Expanded(
      child: pageChooser(pageOptionBloc.pageOptionProvider.returnedindex),
    );
  }

  pageChooser(int page) {
    switch (page) {
      case 0:
        return AllUserScreen();
        break;
      case 1:
        return OnlineFavouriteScreen();
        break;
    }
  }
}
