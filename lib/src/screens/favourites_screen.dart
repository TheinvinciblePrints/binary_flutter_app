import 'package:binaryflutterapp/src/config/assets.dart';
import 'package:binaryflutterapp/src/config/colors.dart';
import 'package:binaryflutterapp/src/models/contacts.dart';
import 'package:binaryflutterapp/src/screens/edit_contact_screen.dart';
import 'package:binaryflutterapp/src/screens/user_detail_screen.dart';
import 'package:binaryflutterapp/src/widgets/circular_progress.dart';
import 'package:binaryflutterapp/src/widgets/swipe_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _onrefresh();
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
              child: getDBContactsWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDBContactsWidget() {
//    return BlocBuilder<ContactBloc, List<Contacts>>(
//      builder: (_, contactList) {
//        return _buildDBContactUI(contactList);
//      },
//    );
  }

  Widget _buildDBContactUI(List<Contacts> contactList) {
    if (contactList.length != 0) {
      return RefreshIndicator(
        onRefresh: () async {
          _onrefresh();
        },
        child: ListView.builder(
          itemCount: contactList.length,
          itemBuilder: (context, itemPosition) {
            Contacts contacts = contactList[itemPosition];
            return _buildSlideMenuItem(context, itemPosition, contacts);
          },
        ),
      );
    } else {
      return Center(
        /*since most of our I/O operations are done
        outside the main thread asynchronously
        we may want to display a loading indicator
        to let the use know the app is currently
        processing*/
        child: noContactMessageWidget(),
      );
    }
  }

  Widget loadingData() {
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
              Icons.star_border,
              size: 120,
              color: Hexcolor(AppColors.accentColor),
            ),
            Text(
              "No Favourites yet",
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

  Widget _buildRow(Contacts contacts, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserDetailScreen(
                    contacts: contacts,
                    contactIndex: index,
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
                child: Icon(
                  contacts.isFavourite ? Icons.star : Icons.star_border,
                  color: contacts.isFavourite
                      ? Hexcolor(AppColors.accentColor)
                      : null,
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideMenuItem(
      BuildContext context, int index, Contacts contacts) {
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
                    contactIndex: index,
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
              _showDialog(contacts, index);
            },
            backgroudColor: Colors.red),
      ],
      child: _buildRow(contacts, index),
    );
  }

  void _showDialog(Contacts item, int _index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
              "Do you want to remove ${item.first_name} ${item.last_name} as favourite?"),
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
                item.isFavourite = !item.isFavourite;

//                DatabaseProvider.db.update(item).then(
//                      (storedContact) =>
//                          BlocProvider.of<ContactBloc>(context).add(
//                        UpdateContacts(_index, item),
//                      ),
//                    );
                _onrefresh();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _onrefresh() async {
//    await DatabaseProvider.db.getFavouriteContacts().then(
//      (contactList) {
//        BlocProvider.of<ContactBloc>(context).add(SetContacts(contactList));
//      },
//    );
  }
}
