import 'dart:async';

import 'package:binaryflutterapp/src/models/oflline/contacts.dart';
import 'package:binaryflutterapp/src/repository/contacts_repository.dart';

class ContactsBloc {
  //Get instance of the Repository
  final _contactsRepository = ContactsRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _contactsController = StreamController<List<Contacts>>.broadcast();

  get contacts => _contactsController.stream;

  ContactsBloc() {
    getContacts();
  }

  getContacts({String query}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _contactsController.sink
        .add(await _contactsRepository.getAllContacts(query: query));
  }

  addContact(Contacts contacts) async {
    await _contactsRepository.insertContact(contacts);
    getContacts();
  }

  updateContact(Contacts contacts) async {
    await _contactsRepository.updateContact(contacts);
    getContacts();
  }

  deleteContactById(int id) async {
    _contactsRepository.deleteContactById(id);
    getContacts();
  }

  refreshContacts() async {
    await getContacts();
  }

  dispose() {
    _contactsController.close();
  }
}
