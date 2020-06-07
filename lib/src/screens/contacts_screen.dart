import 'package:binaryflutterapp/src/bloc/contacts_bloc/contacts_bloc.dart';
import 'package:binaryflutterapp/src/bloc/create_user_bloc/create_user_bloc.dart';
import 'package:binaryflutterapp/src/bloc/delete_bloc/delete_user_bloc.dart';
import 'package:binaryflutterapp/src/bloc/edit_user_bloc/edit_user_bloc.dart';
import 'package:binaryflutterapp/src/bloc/user_bloc/user_bloc.dart';
import 'package:binaryflutterapp/src/bloc/user_bloc/user_event.dart';
import 'package:binaryflutterapp/src/bloc/user_bloc/user_state.dart';
import 'package:binaryflutterapp/src/enums/connectivity_status.dart';
import 'package:binaryflutterapp/src/models/contacts_model.dart';
import 'package:binaryflutterapp/src/models/users_model.dart';
import 'package:binaryflutterapp/src/repository/user_repository.dart';
import 'package:binaryflutterapp/src/screens/add_contact_screen.dart';
import 'package:binaryflutterapp/src/screens/edit_contact_screen.dart';
import 'package:binaryflutterapp/src/screens/user_detail_screen.dart';
import 'package:binaryflutterapp/src/shared/assets.dart';
import 'package:binaryflutterapp/src/shared/colors.dart';
import 'package:binaryflutterapp/src/shared/hex_color.dart';
import 'package:binaryflutterapp/src/utils/image_utility.dart';
import 'package:binaryflutterapp/src/utils/string_utils.dart';
import 'package:binaryflutterapp/src/widgets/bottom_loader.dart';
import 'package:binaryflutterapp/src/widgets/circular_progress.dart';
import 'package:binaryflutterapp/src/widgets/error_view.dart';
import 'package:binaryflutterapp/src/widgets/network_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ContactsBloc _contactsBloc;
  DeleteUserBloc _deleteUserBloc;
  UserBloc _userBloc;
  TextEditingController _searchController = TextEditingController();
  final userRepository = UserRepository();
  NetworkCheck networkCheck = NetworkCheck();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isOnline = false;
  bool isRefreshed;
  bool hasReachedMax = false;
  bool isApiLoaded;

  var connectionStatus;
  ScrollController _apiListScrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    _apiListScrollController.addListener(_onScroll);
    _contactsBloc = ContactsBloc();
    _userBloc = BlocProvider.of<UserBloc>(context);
    isRefreshed = false;
    isApiLoaded = false;
//    bloc.fetchUsers();
//    _userBloc.add(UsersFetched());
    print('methodCalled: initState');
    super.initState();
  }

  @override
  void dispose() {
    print('methodCalled: dispose');
    _contactsBloc.dispose();
    _apiListScrollController.dispose();
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
    print('methodCalled: mainBuild');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(StringUtils.app_title),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5, right: 15),
            child: GestureDetector(
              onTap: () {
                _goToAddContactPage();
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
              child: contactWidget(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget contactWidget(BuildContext context) {
    print('methodCalled: contactWidget');

    connectionStatus = Provider.of<ConnectivityStatus>(context);

    if (connectionStatus != null) {
      if (connectionStatus != ConnectivityStatus.Offline) {
        isOnline = true;

        return apiCallWidget();
      } else {
        isOnline = false;
        if (!isRefreshed) {
          toast("You are offline", Toast.LENGTH_SHORT, ToastGravity.TOP,
              Colors.red);
        }
        _contactsBloc.getContacts();
        return StreamBuilder(
          stream: _contactsBloc.contacts,
          builder:
              (BuildContext context, AsyncSnapshot<List<Contacts>> snapshot) {
            if (snapshot.hasData) {
              return _buildDBContactUI(context, snapshot.data);
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
    } else {
      return Container();
    }
  }

  Widget _buildDBContactUI(BuildContext context, List<Contacts> contactList) {
    if (contactList.length != 0) {
      return dbContactListWidget(contactList);
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

  Widget _buildApiContactUI(
      BuildContext context, List<Contacts> contactList, List<Data> data) {
    if (contactList.length != 0) {
      return apiContactListWidget(contactList, data);
    } else {
      return Container();
    }
  }

  Widget loadingData() {
    return Container(
      child: Center(
        child: CircularProgress(),
      ),
    );
  }

  Widget loadingUsersData() {
    _userBloc.add(UsersFetched());
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
                _goToAddContactPage();
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

  Widget _pictureContent(Contacts contacts) {
    AssetImage assetimage = AssetImage(Assets.iconProfile);
    Image staticImage = Image(image: assetimage, width: 100.0, height: 100.0);
    return Container(
      width: 55.0,
      height: 55.0,
      decoration: BoxDecoration(
        // Circle shape
        shape: BoxShape.circle,
        color: Colors.white,
        // The border you want
        border: Border.all(
          width: 2.0,
          color: HexColor.hexToColor(AppColors.primaryColor),
        ),
      ),
      child: contacts.photoName == null
          ? staticImage
          : CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: new BorderRadius.all(new Radius.circular(40.0)),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 62.0,
                  backgroundImage: MemoryImage(
                      ImageUtility.dataFromBase64String(contacts.photoName)),
                ),
              ),
            ),
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
              leading: _pictureContent(contacts),
              title: Text(
                '${contacts.first_name} ${contacts.last_name}',
                style: _titleFont,
              ),
              subtitle: Text(
                '${contacts.mobile}',
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

                      contacts.isFavourite
                          ? contacts.favourite_index = contacts.id
                          : contacts.favourite_index = 0;

                      //update item
                      _contactsBloc.updateContact(contacts);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideMenuItem(
      BuildContext context, int index, Contacts contacts) {
    isRefreshed = true;
    _deleteUserBloc = BlocProvider.of<DeleteUserBloc>(context);

    return BlocListener<DeleteUserBloc, DeleteState>(
      listener: (context, state) {
        if (state is DeleteSuccessState) {
          _onrefresh();
          updateDB(context, state.UUID, contacts.id);
        }
      },
      child: BlocBuilder(
          bloc: _deleteUserBloc,
          builder: (_context, state) {
            if (state is DeleteInitialState) {
              return _slideMenuWidget(context, index, contacts);
            } else if (state is DeleteSubmitState) {
              print('deleteIndex: $index');
              return Center(
                child: CircularProgressIndicator(),
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

  Widget _buildApiSlideMenuItem(BuildContext context, List<Data> data) {
    _contactsBloc.getContacts();
    return StreamBuilder(
      stream: _contactsBloc.contacts,
      builder: (BuildContext context, AsyncSnapshot<List<Contacts>> snapshot) {
        if (snapshot.hasData) {
          return _buildApiContactUI(context, snapshot.data, data);
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

  void _onTapItem(BuildContext context, Contacts contacts) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserDetailScreen(
                contacts: contacts,
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

  Future<void> _onrefresh() async {
    isRefreshed = true;
    await _contactsBloc.getContacts();
  }

  Widget _slideMenuWidget(BuildContext context, int index, Contacts contacts) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.28,
      child: _buildRow(contacts, index),
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.black45,
          icon: Icons.edit,
          onTap: () {
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
        ),
        IconSlideAction(
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            if (connectionStatus != null &&
                connectionStatus != ConnectivityStatus.Offline) {
              if (contacts.operation == 0) {
                _showDialog(contacts, index);
              }
            } else {
              //Offline
              // operation = 1 means user added contact in offline mode
              if (contacts.operation == 1) {
                _showDialog(contacts, index);
              } else {
                _showSnackBar(_scaffoldKey,
                    'You cannot delete this contact in offline mode');
              }
            }
          },
        ),
      ],
    );
//    return SlideMenu(
//      items: <ActionItems>[
//        ActionItems(
//            icon: IconButton(
//              icon: Icon(Icons.edit),
//              onPressed: () {},
//              color: Colors.white,
//            ),
//            onPress: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                    builder: (context) => BlocProvider<EditUserBloc>(
//                          create: (BuildContext context) =>
//                              EditUserBloc(userRepository: userRepository),
//                          child: EditContactScreen(
//                            contacts: contacts,
//                            onEdit: (Contacts contacts) {
//                              _onrefresh();
//                            },
//                          ),
//                        )),
//              );
//            },
//            backgroudColor: Colors.grey),
//        ActionItems(
//            icon: new IconButton(
//              icon: new Icon(Icons.delete),
//              onPressed: () {},
//              color: Colors.white,
//            ),
//            onPress: () {
//              _showDialog(contacts, index);
//            },
//            backgroudColor: Colors.red),
//      ],
//      child: _buildRow(contacts, index),
//    );
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
                Navigator.of(context).pop();

                if (connectionStatus != null &&
                    connectionStatus != ConnectivityStatus.Offline) {
                  // Update operation to 3 (Need to delete)
                  item.operation = 3;
                  _deleteUserBloc.add(DeleteSubmitInput(uuid: item.UUID));
                } else {
                  //Offline
                  if (item.operation == 1) {
                    // Update operation to 3 (Need to delete)
                    item.operation = 3;
                    _contactsBloc.updateContact(item);
                    _onrefresh();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  updateDB(BuildContext context, String UUID, int contactId) {
    if (UUID != null) {
      _contactsBloc.deleteContactById(contactId);
      _onrefresh();
    }
  }

  _goToAddContactPage() {
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

  _showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('$message'),
    ));
  }

//  void saveToDB(BuildContext context, List<Data> data) {
//    List<Contacts> contactList;
//    for (int index = 0; index < data.length; index++) {
//      Data _data = data[index];
//      contactList = new List<Contacts>();
//
//      Contacts contacts = Contacts(
//        UUID: _data.id,
//        first_name: _data.firstName,
//        last_name: _data.lastName,
//        gender: _data.gender,
//        dob: _data.dateOfBirth,
//        mobile: _data.phoneNo,
//        email: _data.email,
//        title: '',
//        company: '',
//        operation: 0,
//        isFavourite: false,
//      );
//
//      contactList.add(contacts);
//      _contactsBloc.addContacts(contacts);
//
////      _buildSlideMenuItem(context, index, contacts);
//    }
//
//    contactListWidget(contactList);
////    _onrefresh();
//  }

  Function toast(
      String msg, Toast toast, ToastGravity toastGravity, Color colors) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toast,
        gravity: toastGravity,
        timeInSecForIos: 1,
        backgroundColor: colors,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget dbContactListWidget(List<Contacts> _contactList) {
//    print('dbListLength: ${_contactList.length}');
    return ListView.builder(
      itemCount: _contactList.length,
      itemBuilder: (context, itemPosition) {
        Contacts contacts = _contactList[itemPosition];
        return _buildSlideMenuItem(context, itemPosition, contacts);
      },
    );
  }

  Widget apiContactListWidget(List<Contacts> _contactList, List<Data> data) {
//    return ListView.builder(
//      itemCount: _contactList.length,
//      itemBuilder: (context, itemPosition) {
//        Contacts contacts = _contactList[itemPosition];
//        return _buildSlideMenuItem(context, itemPosition, contacts);
//      },
//    );
    isApiLoaded = true;
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return index >= _contactList.length
            ? BottomLoader()
            : _buildSlideMenuItem(context, index, _contactList[index]);
      },
      itemCount: hasReachedMax ? _contactList.length : _contactList.length + 1,
      controller: _apiListScrollController,
    );
  }

  void _onScroll() {
    final maxScroll = _apiListScrollController.position.maxScrollExtent;
    final currentScroll = _apiListScrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      if (isOnline) {
        _userBloc.add(UsersFetched());
      }
    }
  }

  void refreshApiList() {
    _userBloc.add(UsersFetched());
  }

  Widget apiCallWidget() {
    if (!isApiLoaded) {
      _userBloc.add(UsersFetched());
    }
    return BlocBuilder(
        bloc: _userBloc,
        builder: (_context, state) {
          if (state is UserSuccess) {
            if (state.data.isEmpty) {
              return Center(
                child: Text('No users'),
              );
            }
            hasReachedMax = state.hasReachedMax;
            return _buildApiSlideMenuItem(context, state.data);
          } else if (state is UserInitial) {
            return loadingUsersData();
          } else if (state is UserFailure) {
            return ErrorView(
              message: 'Failed to load data',
              action: refreshApiList,
            );
          } else {
            return loadingData();
          }
        });
  }
}
