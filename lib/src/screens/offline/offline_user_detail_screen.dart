import 'package:binaryflutterapp/src/bloc/offline/contacts_bloc.dart';
import 'package:binaryflutterapp/src/config/assets.dart';
import 'package:binaryflutterapp/src/config/colors.dart';
import 'package:binaryflutterapp/src/models/oflline/contacts.dart';
import 'package:binaryflutterapp/src/screens/offline/edit_contact_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class OfflineUserDetailScreen extends StatefulWidget {
  final Contacts contacts;

  OfflineUserDetailScreen({@required this.contacts});

  @override
  _OfflineUserDetailScreenState createState() =>
      _OfflineUserDetailScreenState();
}

class _OfflineUserDetailScreenState extends State<OfflineUserDetailScreen> {
  ContactsBloc contactsBloc;

  @override
  void initState() {
    contactsBloc = ContactsBloc();
    super.initState();
  }

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
          child: Column(
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
          ),
        ),
      ),
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
                  backgroundColor: Hexcolor(AppColors.primaryColor),
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
              _context,
              MaterialPageRoute(
                builder: (_context) => EditContactScreen(
                  contacts: widget.contacts,
                ),
              ),
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
                color: Hexcolor(
                  AppColors.primaryColor,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.contacts.mobile,
              style: TextStyle(
                fontSize: 15,
                color: Hexcolor(
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
