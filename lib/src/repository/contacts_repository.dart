import 'package:binaryflutterapp/src/database/dao/contacts_dao.dart';
import 'package:binaryflutterapp/src/models/contacts.dart';

class ContactsRepository {
  final contactsDao = ContactsDao();

  Future getAllContacts({String query}) =>
      contactsDao.getContacts(query: query);

  Future insertContact(Contacts contacts) =>
      contactsDao.createContacts(contacts);

  Future updateContact(Contacts contacts) =>
      contactsDao.updateContact(contacts);

  Future deleteContactById(int id) => contactsDao.deleteContact(id);

  //We are not going to use this in the demo
  Future deleteAllContacts() => contactsDao.deleteAllContacts();
}
