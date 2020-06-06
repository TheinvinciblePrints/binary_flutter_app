import 'package:binaryflutterapp/src/bloc/edit_user_bloc/edit_user_bloc.dart';
import 'package:binaryflutterapp/src/models/contacts_model.dart';
import 'package:binaryflutterapp/src/repository/user_repository.dart';
import 'package:binaryflutterapp/src/screens/edit_contact_screen.dart';
import 'package:binaryflutterapp/src/shared/assets.dart';
import 'package:binaryflutterapp/src/shared/colors.dart';
import 'package:binaryflutterapp/src/shared/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

typedef OnEditCallback = Function(Contacts contacts);
typedef OnUserEditCallback = Function(Contacts contacts);

class UserDetailScreen extends StatefulWidget {
  final Contacts contacts;

  final OnEditCallback onEdit;
  final OnUserEditCallback onUserEdit;

  UserDetailScreen({@required this.contacts, this.onEdit, this.onUserEdit});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("User Detail"),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 30, left: 5),
          child: _buildBodyUI(context),
        ),
      ),
    );
  }

  Widget _buildBodyUI(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            _headerContent(context),
            SizedBox(
              height: 20,
            ),
            _centerContent(),
            _divider(),
            _bottomContent(),
            _divider(),
          ],
        )
      ],
    );
  }

  Widget _headerContent(BuildContext _context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 85, right: 40),
              child: Container(
                width: 150.0,
                height: 150.0,
                child: CircleAvatar(
                  backgroundColor: HexColor.hexToColor(AppColors.primaryColor),
                  child: CircleAvatar(
                    radius: 71,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(
                      Assets.iconProfile,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlocProvider<EditUserBloc>(
                        create: (BuildContext context) =>
                            EditUserBloc(userRepository: userRepository),
                        child: EditContactScreen(
                          contacts: widget.contacts,
                          onEdit: (Contacts _contacts) {
                            widget.onUserEdit(_contacts);
                          },
                        ),
                      )),
            );
          },
          child: Icon(
            Icons.edit,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget _centerContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '${widget.contacts.first_name} ${widget.contacts.last_name}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          widget.contacts.title,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          widget.contacts.company,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _bottomContent() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Mobile',
              style: TextStyle(
                fontSize: 15,
                color: HexColor.hexToColor(
                  AppColors.primaryColor,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.contacts.mobile,
              style: TextStyle(
                fontSize: 15,
                color: HexColor.hexToColor(
                  AppColors.primaryColor,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 2),
              child: GestureDetector(
                onTap: () {
                  _launchCaller(widget.contacts.mobile);
                },
                child: Icon(
                  Icons.call,
                  color: Colors.black,
                  size: 35,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 30),
              child: GestureDetector(
                onTap: () {
                  _sendText(widget.contacts.mobile);
                },
                child: Container(
                  height: 80,
                  width: 80,
                  child: Icon(
                    Icons.comment,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.only(
        right: 15,
        left: 15,
      ),
      child: Divider(
        thickness: 2,
      ),
    );
  }

  _launchCaller(String number) async {
    String url = "tel:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _sendText(String number) async {
    // Android
    String uri = "sms:$number";
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      String uri = "sms:$number";
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
}
