import 'dart:async';

import 'package:binaryflutterapp/src/database/database.dart';
import 'package:binaryflutterapp/src/models/contacts.dart';
import 'package:sqflite/sqflite.dart';

class ContactsDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Contacts records
  Future<int> createContacts(Contacts contacts) async {
    final db = await dbProvider.database;
    var result = db.insert(contactsTABLE, contacts.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  //Get All Contacts items
  //Searches if query string was passed
  Future<List<Contacts>> getContacts() async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    result =
        await db.rawQuery("SELECT * FROM $contactsTABLE ORDER BY first_name");
    List<Contacts> contacts = result.isNotEmpty
        ? result.map((item) => Contacts.fromMap(item)).toList()
        : [];
    return contacts;
  }

  Future<List<Contacts>> searchContact(String value) async {
    Database db = await dbProvider.database;
    var items = await db.rawQuery("""SELECT 
              * 
           FROM 
              $contactsTABLE 
           WHERE 
              first_name LIKE '%$value%' or 
              last_name LIKE '%$value%' or 
              title LIKE '%$value%'
            ORDER BY first_name
        """);

    List<Contacts> contactList =
        items.map((item) => Contacts.fromMap(item)).toList();

    return contactList;
  }

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

  Future<List<Contacts>> getContactByID(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.rawQuery("SELECT * FROM $contactsTABLE WHERE id = $id");

    List<Contacts> contactList = List<Contacts>();

    result.forEach((currentContact) {
      Contacts contact = Contacts.fromMap(currentContact);

      contactList.add(contact);
    });
    return contactList;
  }

  //Update Contacts record
  Future<int> updateContact(Contacts contacts) async {
    final db = await dbProvider.database;

    var result = await db.update(contactsTABLE, contacts.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: "id = ?",
        whereArgs: [contacts.id]);

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
