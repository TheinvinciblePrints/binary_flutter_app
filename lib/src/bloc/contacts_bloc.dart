import 'dart:async';

import 'package:binaryflutterapp/src/models/contacts.dart';
import 'package:binaryflutterapp/src/repository/contacts_repository.dart';

class ContactsBloc {
  //Get instance of the Repository
  final _contactsRepository = ContactsRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _contactController = StreamController<List<Contacts>>.broadcast();
  final _favouriteController = StreamController<List<Contacts>>.broadcast();

  get contacts => _contactController.stream;

  get favouritess => _favouriteController.stream;

  ContactsBloc() {
    getContacts();
  }

  getContacts({String query}) async {
    _contactController.sink.add(await _contactsRepository.getAllContacts());
  }

  searchContacts(String query) async {
    _contactController.sink
        .add(await _contactsRepository.searchContacts(query));
  }

  getContactByID(int id) async {
    _contactController.sink.add(await _contactsRepository.getContactById(id));
  }

  getFavourites() async {
    _favouriteController.sink.add(await _contactsRepository.getFavourites());
  }

  addContacts(Contacts contacts) async {
    await _contactsRepository.insertContact(contacts);
    getContacts();
  }

  updateContact(Contacts contacts) async {
    await _contactsRepository.updateContact(contacts);
    getContacts();
  }

  updateFavourites(Contacts contacts) async {
    await _contactsRepository.updateContact(contacts);
    getFavourites();
  }

  deleteContactById(int id) async {
    _contactsRepository.deleteContactById(id);
    getContacts();
  }

  dispose() {
    _contactController.close();
    _favouriteController.close();
  }
}
