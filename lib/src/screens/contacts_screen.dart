import 'package:binaryflutterapp/src/bloc/contacts_bloc.dart';
import 'package:binaryflutterapp/src/bloc/create_user/create_user_bloc.dart';
import 'package:binaryflutterapp/src/bloc/delete_bloc/delete_user_bloc.dart';
import 'package:binaryflutterapp/src/bloc/edit_user_bloc/edit_user_bloc.dart';
import 'package:binaryflutterapp/src/config/assets.dart';
import 'package:binaryflutterapp/src/config/colors.dart';
import 'package:binaryflutterapp/src/config/hex_color.dart';
import 'package:binaryflutterapp/src/models/contacts_model.dart';
import 'package:binaryflutterapp/src/repository/user_repository.dart';
import 'package:binaryflutterapp/src/screens/add_contact_screen.dart';
import 'package:binaryflutterapp/src/screens/edit_contact_screen.dart';
import 'package:binaryflutterapp/src/screens/user_detail_screen.dart';
import 'package:binaryflutterapp/src/utils/string_utils.dart';
import 'package:binaryflutterapp/src/widgets/circular_progress.dart';
import 'package:binaryflutterapp/src/widgets/network_check.dart';
import 'package:binaryflutterapp/src/widgets/swipe_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ContactsBloc _contactsBloc;
  DeleteUserBloc _deleteUserBloc;
  TextEditingController _searchController = TextEditingController();
  final userRepository = UserRepository();
  NetworkCheck networkCheck = NetworkCheck();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // create instance of the class member variables
    _contactsBloc = ContactsBloc();

    //dispatch query event to retrieve _contact list
    // _onrefresh();

    super.initState();
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
    return BlocProvider<DeleteUserBloc>(
      create: (BuildContext _context) =>
          DeleteUserBloc(userRepository: userRepository),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(StringUtils.app_title),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5, right: 15),
              child: GestureDetector(
                onTap: () {
                  _goToContactPage();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: new EdgeInsets.only(
                    left: 20.0, right: 20, top: 15, bottom: 10),
                child: new TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    _contactsBloc.searchContacts(value);
                  },
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
      ),
    );
  }

  Widget getDBContactsWidget() {
    return StreamBuilder(
      stream: _contactsBloc.contacts,
      builder: (BuildContext context, AsyncSnapshot<List<Contacts>> snapshot) {
        if (snapshot.hasData) {
          return _buildDBContactUI(snapshot.data);
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading items'),
          );
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
//
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
    _contactsBloc.getContacts();
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
              size: 100,
              color: HexColor.hexToColor(AppColors.accentColor),
            ),
            Text(
              "No Contacts found",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
            ),
            FlatButton(
              onPressed: () {
                _goToContactPage();
              },
              child: Text(
                'Add Contact'.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HexColor.hexToColor(AppColors.primaryColor),
                ),
              ),
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

  Widget _buildRow(Contacts contacts, int index) {
    return GestureDetector(
      onTap: () {
        _onTapItem(context, contacts);
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
                '${contacts.title}',
                style: _subtitleFont,
              ),
              trailing: Padding(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                    child: Icon(
                      contacts.isFavourite ? Icons.star : Icons.star_border,
                      color: contacts.isFavourite
                          ? HexColor.hexToColor(AppColors.accentColor)
                          : null,
                    ),
                    onTap: () {
                      contacts.isFavourite = !contacts.isFavourite;

                      if (contacts.isFavourite)
                        contacts.favourite_index = contacts.id;
                      //update item
                      _contactsBloc.updateContact(contacts);
                    }),
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
    _deleteUserBloc = BlocProvider.of<DeleteUserBloc>(context);

    return BlocListener<DeleteUserBloc, DeleteState>(
      listener: (context, state) {
        if (state is DeleteSuccessState) {
          updateDB(state.UUID, contacts.id);
        }
      },
      child: BlocBuilder(
          bloc: _deleteUserBloc,
          builder: (_context, state) {
            if (state is DeleteInitialState) {
              return _slideMenuWidget(context, index, contacts);
            } else if (state is DeleteSubmitState) {
              return Column(
                children: <Widget>[
                  Center(
                    child: CircularProgress(),
                  )
                ],
              );
            } else if (state is DeleteFailureState) {
              return SnackBar(
                content: Text('Failed to delete user'),
              );
            } else {
              return Container();
            }
          }),
    );
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
                onUserEdit: (contacts) {
                  print('edited ${contacts.first_name}');
                  _onrefresh();
                },
              )),
    );
  }

  _onrefresh() async {
    await _contactsBloc.getContacts();
  }

  Widget _slideMenuWidget(BuildContext context, int index, Contacts contacts) {
    return SlideMenu(
      items: <ActionItems>[
        ActionItems(
            icon: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
              color: Colors.white,
            ),
            onPress: () {
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
        ActionItems(
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

  _showDialog(Contacts item, int _index) {
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
              onPressed: () async {
                // Update operation to 3 (Need to delete)
                item.operation = 3;

                Navigator.of(context).pop();

                final internetAvailable = await networkCheck.checkInternet();

                if (internetAvailable != null && internetAvailable) {
                  if (item.UUID != null) {
                    _deleteUserBloc.add(DeleteSubmitInput(uuid: item.UUID));
                  } else {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Empty UUID'),
                    ));
                    return;
                  }
                } else {
                  _contactsBloc.updateContact(item);
                  _onrefresh();
                }
              },
            ),
          ],
        );
      },
    );
  }

  updateDB(String UUID, int contactId) {
    if (UUID != null) {
      _contactsBloc.deleteContactById(contactId);
      _onrefresh();
    }
  }

  _goToContactPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider<CreateUserBloc>(
                create: (BuildContext context) =>
                    CreateUserBloc(userRepository: userRepository),
                child: AddContactScreen(
                  onSave: (Contacts contacts) {
                    _onrefresh();
                  },
                ),
              )),
    );
  }
}
