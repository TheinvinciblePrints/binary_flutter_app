import 'package:binaryflutterapp/src/database/dao/contacts_dao.dart';
import 'package:binaryflutterapp/src/models/contacts.dart';

class ContactsRepository {
  final contactsDao = ContactsDao();

  Future getAllContacts() => contactsDao.getContacts();

  Future getFavourites() => contactsDao.getFavouriteContacts();

  Future getContactById(int id) => contactsDao.getContactByID(id);

  Future searchContacts(String query) => contactsDao.searchContact(query);

  Future insertContact(Contacts contacts) =>
      contactsDao.createContacts(contacts);

  Future updateContact(Contacts contacts) =>
      contactsDao.updateContact(contacts);

  Future deleteContactById(int id) => contactsDao.deleteContact(id);

  //We are not going to use this in the demo
  Future deleteAllContacts() => contactsDao.deleteAllContacts();
}
