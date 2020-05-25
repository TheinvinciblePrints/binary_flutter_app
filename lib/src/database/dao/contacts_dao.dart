import 'dart:async';

import 'package:binaryflutterapp/src/database/database.dart';
import 'package:binaryflutterapp/src/models/contacts.dart';

class ContactsDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Contacts records
  Future<int> createContacts(Contacts contacts) async {
    final db = await dbProvider.database;
    var result = db.insert(contactsTABLE, contacts.toMap());
    return result;
  }

  //Get All Contacts items
  //Searches if query string was passed
  Future<List<Contacts>> getContacts(
      {List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db
            .rawQuery("SELECT * FROM $contactsTABLE ORDER BY first_name");
    } else {
      result = await db.query(contactsTABLE, columns: columns);
    }

    List<Contacts> contacts = result.isNotEmpty
        ? result.map((item) => Contacts.fromMap(item)).toList()
        : [];
    return contacts;
  }

//  Future<int> getContactByID(int id) async {
//    final db = await dbProvider.database;
//    var result =
//    await db.rawQuery(contactsTABLE, where: 'id = ?', whereArgs: [id]);
//
//    return result;
//  }

  Future<List<Contacts>> getFavouriteContacts() async {
    final db = await dbProvider.database;

    var contacts =
        await db.rawQuery("SELECT * FROM $contactsTABLE WHERE isFavourite = 1");

    List<Contacts> contactList = List<Contacts>();

    contacts.forEach((currentContact) {
      Contacts contact = Contacts.fromMap(currentContact);

      contactList.add(contact);
    });

    return contactList;
  }

  //Update Contacts record
  Future<int> updateContact(Contacts contacts) async {
    final db = await dbProvider.database;

    var result = await db.update(contactsTABLE, contacts.toMap(),
        where: "id = ?", whereArgs: [contacts.id]);

    return result;
  }

  //Delete Contacts records
  Future<int> deleteContact(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(contactsTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllContacts() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      contactsTABLE,
    );

    return result;
  }
}
