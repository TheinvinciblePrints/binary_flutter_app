import 'package:binaryflutterapp/src/bloc/contacts_bloc.dart';
import 'package:binaryflutterapp/src/bloc/edit_user_bloc/edit_user_bloc.dart';
import 'package:binaryflutterapp/src/config/assets.dart';
import 'package:binaryflutterapp/src/config/colors.dart';
import 'package:binaryflutterapp/src/config/hex_color.dart';
import 'package:binaryflutterapp/src/models/contacts_model.dart';
import 'package:binaryflutterapp/src/repository/user_repository.dart';
import 'package:binaryflutterapp/src/screens/edit_contact_screen.dart';
import 'package:binaryflutterapp/src/screens/user_detail_screen.dart';
import 'package:binaryflutterapp/src/utils/string_utils.dart';
import 'package:binaryflutterapp/src/widgets/circular_progress.dart';
import 'package:binaryflutterapp/src/widgets/swipe_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  TextEditingController searchController = new TextEditingController();
  ContactsBloc _contactsBloc;
  final userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _contactsBloc = ContactsBloc();
//    _onrefresh();
  }

  @override
  void dispose() {
    _contactsBloc.dispose();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(StringUtils.favourites_title),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
        child: getFavouriteContactsWidget(),
      ),
    );
  }

  Widget getFavouriteContactsWidget() {
//    return BlocBuilder<ContactBloc, List<Contacts>>(
//      builder: (_, contactList) {
//        return _buildDBContactUI(contactList);
//      },
//    );
//    return BlocBuilder(
//      bloc: _contactsBloc,
//      builder: (context, state) {
//        if (state is LoadingContactState) {
//          return CircularProgress();
//        } else if (state is EmptyContactState) {
//          return noContactMessageWidget();
//        } else if (state is LoadedContactState) {
//          return _buildDBContactUI(context, state.list);
//        }
//        return Container();
//      },
//    );
    return StreamBuilder(
      stream: _contactsBloc.favouritess,
      builder: (BuildContext _context, AsyncSnapshot<List<Contacts>> snapshot) {
        if (snapshot.hasData) {
          return _buildDBContactUI(_context, snapshot.data);
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
      },
    );
  }

  Widget _buildDBContactUI(BuildContext context, List<Contacts> _contactList) {
    if (_contactList.length != 0) {
      return ReorderableListView(
        header: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'You can drag and drop to rearrange list of favourite',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        onReorder: (oldIndex, newIndex) {
          _updateMyItems(_contactList, oldIndex, newIndex);
        },
        children: [
          for (final item in _contactList)
            ListTile(
              key: ValueKey(item),
              onTap: () {
                _onTapItem(context, item);
              },
              title: _buildSlideMenuItem(context, item),
            ),
        ],
      );
    } else {
      return Center(
        /*since most of our I/O operations are done
        outside the main thread asynchronously
        we may want to display a loading indicator
        to let the user know the app is currently
        processing*/
        child: noContactMessageWidget(),
      );
    }
  }

  Widget loadingData() {
    _contactsBloc.getFavourites();
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
              color: HexColor.hexToColor(AppColors.accentColor),
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
      children: <Widget>[
        Container(
          width: 55.0,
          height: 55.0,
          child: CircleAvatar(
            backgroundColor: HexColor.hexToColor(AppColors.primaryColor),
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
    return Column(
      children: <Widget>[
        ListTile(
          key: ValueKey(contacts),
          leading: _pictureContent(),
          title: Text(
            '${contacts.first_name} ${contacts.last_name}',
            style: _titleFont,
          ),
          subtitle: Text(
            contacts.title,
            style: _subtitleFont,
          ),
          trailing: Icon(
            contacts.isFavourite ? Icons.star : Icons.star_border,
            color: contacts.isFavourite
                ? HexColor.hexToColor(AppColors.accentColor)
                : null,
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildSlideMenuItem(BuildContext context, Contacts contacts) {
    return SlideMenu(
      items: <ActionItems>[
        ActionItems(
            icon: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
              color: Colors.white,
            ),
            onPress: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => EditContactScreen(
//                    contacts: contacts,
//                    onEdit: (contacts) {
//                      if (contacts != null) {
//                        _onrefresh();
//                      }
//                    },
//                  ),
//                ),
//              );
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider<EditUserBloc>(
                          create: (BuildContext context) =>
                              EditUserBloc(userRepository: userRepository),
                          child: EditContactScreen(
                            contacts: contacts,
                            onEdit: (Contacts contacts) {
                              _onrefresh();
                            },
                          ),
                        )),
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
              _showDeleteDialog(contacts);
            },
            backgroudColor: Colors.red),
      ],
      child: _buildRow(contacts),
    );
  }

  void _showDeleteDialog(Contacts item) {
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

                _contactsBloc.updateFavourites(item);
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
    _contactsBloc.getFavourites();
  }

  void _updateMyItems(List<Contacts> contactList, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    setState(() {
      Contacts contacts = contactList[oldIndex];

      contactList.removeAt(oldIndex);
      contactList.insert(newIndex, contacts);
      contacts.favourite_index = newIndex;

      _contactsBloc.updateContact(contacts);
    });
  }

  void _onTapItem(BuildContext context, Contacts contacts) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserDetailScreen(
                contact_id: contacts.id,
                onEdit: (contacts) {
                  _onrefresh();
                },
              )),
    );
  }
}
