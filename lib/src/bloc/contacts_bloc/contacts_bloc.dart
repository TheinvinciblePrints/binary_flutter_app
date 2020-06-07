import 'package:binaryflutterapp/src/models/contacts_model.dart';
import 'package:binaryflutterapp/src/repository/contacts_repository.dart';
import 'package:rxdart/rxdart.dart';

class ContactsBloc {
  //Get instance of the Repository
  ContactsRepository _contactsRepository;

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  var _contactController;
  var _favouriteController;

  Stream<List<Contacts>> get contacts => _contactController.stream;

  Stream<List<Contacts>> get favourites => _favouriteController.stream;

  ContactsBloc() {
    _contactController = PublishSubject<List<Contacts>>();
    _favouriteController = PublishSubject<List<Contacts>>();
    _contactsRepository = ContactsRepository();
    getContacts();
  }

  getContacts() async {
    _contactController.sink.add(await _contactsRepository.getAllContacts());
  }

  getContactsForOnline() async {
    _contactController.sink
        .add(await _contactsRepository.getContactsForOnline());
  }

  searchContacts(String query) async {
    _contactController.sink
        .add(await _contactsRepository.searchContacts(query));
  }

  getContactByID(String id) async {
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
    await _contactsRepository.updateFavourite(contacts);
    getFavourites();
  }

  deleteContactById(int id) async {
    _contactsRepository.deleteContactById(id);
//    getContacts();
  }

  dispose() {
    _contactController.close();
    _favouriteController.close();
  }
}
