import 'package:binaryflutterapp/src/bloc/offline/contacts_bloc.dart';
import 'package:binaryflutterapp/src/config/assets.dart';
import 'package:binaryflutterapp/src/config/colors.dart';
import 'package:binaryflutterapp/src/models/oflline/contacts.dart';
import 'package:binaryflutterapp/src/screens/offline/edit_contact_screen.dart';
import 'package:binaryflutterapp/src/screens/offline/offline_user_detail_screen.dart';
import 'package:binaryflutterapp/src/widgets/circular_progress.dart';
import 'package:binaryflutterapp/src/widgets/swipe_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ContactsBloc contactsBloc;
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    contactsBloc = ContactsBloc();
    contactsBloc.getContacts();
    super.initState();
  }

  @override
  void dispose() {
    contactsBloc.dispose();
    super.dispose();
  }

  final TextStyle _titleFont = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
  final TextStyle _subtitleFont = const TextStyle(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: new EdgeInsets.only(
                  left: 20.0, right: 20, top: 15, bottom: 10),
              child: new TextField(
                controller: searchController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Search Contacts',
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
            ),
            Expanded(
              child: getContactsWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getContactsWidget() {
    /*The StreamBuilder widget,
    basically this widget will take stream of data (todos)
    and construct the UI (with state) based on the stream
    */
    return StreamBuilder(
      stream: contactsBloc.contacts,
      builder: (BuildContext context, AsyncSnapshot<List<Contacts>> snapshot) {
        return RefreshIndicator(
          onRefresh: () => _onrefresh(),
          child: getTodoCardWidget(snapshot),
        );
      },
    );
  }

  Widget getTodoCardWidget(AsyncSnapshot<List<Contacts>> snapshot) {
    /*Since most of our operations are asynchronous
    at initial state of the operation there will be no stream
    so we need to handle it if this was the case
    by showing users a processing/loading indicator*/
    if (snapshot.hasData) {
      /*Also handles whenever there's stream
      but returned returned 0 records of Contacts from DB.
      If that the case show user that you have empty Contacts
      */
      return snapshot.data.length != 0
          ? RefreshIndicator(
              onRefresh: () async {
                _onrefresh();
              },
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, itemPosition) {
                  Contacts contacts = snapshot.data[itemPosition];
                  return _buildSlideMenuItem(context, itemPosition, contacts);
                },
              ),
            )
          : Container(
              child: Center(
              //this is used whenever there 0
              //in the data base
              child: noContactMessageWidget(),
            ));
    } else {
      return Center(
        /*since most of our I/O operations are done
        outside the main thread asynchronously
        we may want to display a loading indicator
        to let the use know the app is currently
        processing*/
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    //pull todos again
    contactsBloc.getContacts();
    return Container(
      child: Center(
        child: CircularProgress(),
      ),
    );
  }

  Widget noContactMessageWidget() {
    return Center(
      child: Container(
        height: 200,
        child: Column(
          children: <Widget>[
            Icon(
              Icons.list,
              size: 120,
              color: Hexcolor(AppColors.accentColor),
            ),
            Text(
              "Start adding Contacts...",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pictureContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 55.0,
          height: 55.0,
          child: CircleAvatar(
            backgroundColor: Hexcolor(AppColors.primaryColor),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                Assets.iconProfile,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(Contacts contacts) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OfflineUserDetailScreen(
                    contacts: contacts,
                  )),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: 0, right: 3, left: 3),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: _pictureContent(),
              title: Text(
                '${contacts.first_name} ${contacts.last_name}',
                style: _titleFont,
              ),
              subtitle: Text(
                contacts.title,
                style: _subtitleFont,
              ),
              trailing: Padding(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                    child: Icon(
                      contacts.is_favourite ? Icons.star : Icons.star_border,
                      color: contacts.is_favourite ? Colors.black : null,
                    ),
                    onTap: () {
                      contacts.is_favourite = !contacts.is_favourite;
                      contactsBloc.updateContact(contacts);
                    }),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideMenuItem(BuildContext context, index, contacts) {
    return new SlideMenu(
      items: <ActionItems>[
        new ActionItems(
            icon: new IconButton(
              icon: new Icon(Icons.edit),
              onPressed: () {},
              color: Colors.white,
            ),
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditContactScreen(
                    contacts: contacts,
                  ),
                ),
              );
            },
            backgroudColor: Colors.grey),
        new ActionItems(
            icon: new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () {},
              color: Colors.white,
            ),
            onPress: () {
              _showDialog(contacts);
            },
            backgroudColor: Colors.red),
      ],
      child: _buildRow(contacts),
    );
  }

  void _showDialog(Contacts item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Do you want to delete the contact?"),
          content: new Text('${item.first_name} ${item.last_name}'),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                contactsBloc.deleteContactById(item.id);
              },
            ),
          ],
        );
      },
    );
  }

  _onrefresh() async {
    await contactsBloc.refreshContacts();
  }
}
