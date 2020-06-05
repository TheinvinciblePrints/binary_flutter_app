import 'package:binaryflutterapp/src/database/dao/contacts_dao.dart';
import 'package:binaryflutterapp/src/models/contacts_model.dart';

class ContactsRepository {
  final contactsDao = ContactsDao();

  Future getAllContacts() => contactsDao.getContacts();
  Future getContactsForOnline() => contactsDao.getContactsForOnline();

  Future getFavourites() => contactsDao.getFavouriteContacts();

  Future getContactById(String id) => contactsDao.getContactByID(id);

  Future updateFavourite(Contacts contacts) =>
      contactsDao.updateFavourite(contacts);

  Future searchContacts(String query) => contactsDao.searchContact(query);

  Future insertContact(Contacts contacts) =>
      contactsDao.createContacts(contacts);

  Future updateContact(Contacts contacts) =>
      contactsDao.updateContact(contacts);

  Future deleteContactById(int id) => contactsDao.deleteContact(id);

  //We are not going to use this in the demo
  Future deleteAllContacts() => contactsDao.deleteAllContacts();
}
