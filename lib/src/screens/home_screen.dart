import 'package:binaryflutterapp/src/bloc/delete_bloc/delete_user_bloc.dart';
import 'package:binaryflutterapp/src/bloc/mainpage/page_option_bloc.dart';
import 'package:binaryflutterapp/src/bloc/user_bloc/user_bloc.dart';
import 'package:binaryflutterapp/src/repository/user_repository.dart';
import 'package:binaryflutterapp/src/screens/contacts_screen.dart';
import 'package:binaryflutterapp/src/screens/favourites_screen.dart';
import 'package:binaryflutterapp/src/shared/colors.dart';
import 'package:binaryflutterapp/src/shared/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  //We load our Contacts BLoC that is used to get
  //the stream of Contacts for StreamBuilder
//  final AppOptionBloc appOptionBloc;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _toggleTexts = ['All', 'Favourites'];
  PageOptionBloc pageOptionBloc;
  final userRepository = UserRepository();

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
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
          stream: pageOptionBloc.getPage,
          builder: (_context, snapshot) {
            return Column(
              children: <Widget>[
                _bodyUI(context),
                _toggleButtons(),
              ],
            );
            return Container();
          }),
    );
  }

  Widget _toggleButtons() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 8),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ToggleButtons(
                  borderColor: HexColor.hexToColor(AppColors.primaryColor),
                  fillColor: Colors.grey[45],
                  borderWidth: 1.5,
                  selectedBorderColor:
                      HexColor.hexToColor(AppColors.primaryColor),
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

  Widget _bodyUI(BuildContext context) {
    return Expanded(
      child:
          pageChooser(pageOptionBloc.pageOptionProvider.returnedindex, context),
    );
  }

  pageChooser(int page, BuildContext context) {
    switch (page) {
      case 0:
        return MultiBlocProvider(
          providers: [
            BlocProvider<DeleteUserBloc>(
              create: (BuildContext _context) =>
                  DeleteUserBloc(userRepository: userRepository),
            ),
            BlocProvider<UserBloc>(
              create: (BuildContext context) =>
                  UserBloc(userRepository: userRepository),
            ),
          ],
          child: ContactScreen(),
        );
        break;
      case 1:
        return FavouriteScreen();
        break;
    }
  }
}
