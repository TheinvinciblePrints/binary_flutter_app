import 'package:binaryflutterapp/src/dao/contacts_dao.dart';
import 'package:binaryflutterapp/src/models/oflline/contacts.dart';

class ContactsRepository {
  final contactsDao = ContactsDao();

  Future getAllContacts({String query}) =>
      contactsDao.getContacts(query: query);

  Future insertContact(Contacts todo) => contactsDao.createContacts(todo);

  Future updateContact(Contacts todo) => contactsDao.updateContact(todo);

  Future deleteContactById(int id) => contactsDao.deleteContact(id);

  //We are not going to use this in the demo
  Future deleteAllContacts() => contactsDao.deleteAllContacts();
}
