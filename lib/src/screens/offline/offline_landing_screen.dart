import 'package:binaryflutterapp/src/bloc/offline/contacts_bloc.dart';
import 'package:binaryflutterapp/src/config/colors.dart';
import 'package:binaryflutterapp/src/models/oflline/contacts.dart';
import 'package:binaryflutterapp/src/screens/offline/add_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class OfflineScreen extends StatelessWidget {
  //We load our Contacts BLoC that is used to get
  //the stream of Contacts for StreamBuilder
  final ContactsBloc contactsBloc = ContactsBloc();

  //Allows Todo card to be dismissable horizontally
  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
          child: Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
              child: Container(
                  //This is where the magic starts
                  child: getContactsWidget()))),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactScreen()),
          );
        },
        backgroundColor: Hexcolor(AppColors.primaryColor),
        child: const Icon(
          Icons.add,
          color: Colors.white,
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
        return getTodoCardWidget(snapshot);
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
      but returned returned 0 records of Todo from DB.
      If that the case show user that you have empty Todos
      */
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Contacts todo = snapshot.data[itemPosition];
                final Widget dismissibleCard = new Dismissible(
                  background: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Deleting",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    color: Colors.redAccent,
                  ),
                  onDismissed: (direction) {
                    /*The magic
                    delete Todo item by ID whenever
                    the card is dismissed
                    */
                    contactsBloc.deleteContactById(todo.id);
                  },
                  direction: _dismissDirection,
                  key: new ObjectKey(todo),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey[200], width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        leading: InkWell(
                          onTap: () {
                            //Reverse the value
                            todo.isFavourite = !todo.isFavourite;
                            /*
                            Another magic.
                            This will update Todo isDone with either
                            completed or not
                          */
                            contactsBloc.updateContact(todo);
                          },
                          child: Container(
                            //decoration: BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: todo.isFavourite
                                  ? Icon(
                                      Icons.done,
                                      size: 26.0,
                                      color: Colors.indigoAccent,
                                    )
                                  : Icon(
                                      Icons.check_box_outline_blank,
                                      size: 26.0,
                                      color: Colors.tealAccent,
                                    ),
                            ),
                          ),
                        ),
                        title: Text(
                          todo.first_name,
                          style: TextStyle(
                              fontSize: 16.5,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w500,
                              decoration: todo.isFavourite
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                      )),
                );
                return dismissibleCard;
              },
            )
          : Container(
              child: Center(
              //this is used whenever there 0 Todo
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
          ],
        ),
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

  dispose() {
    /*close the stream in order
    to avoid memory leaks
    */
    contactsBloc.dispose();
  }
}
