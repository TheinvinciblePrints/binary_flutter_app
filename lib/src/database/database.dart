import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final contactsTABLE = 'contacts';

class DatabaseProvider {
  static const String COLUMN_ID = "id";
  static const String COLUMN_UUID = "uuid";
  static const String COLUMN_FIRSTNAME = "first_name";
  static const String COLUMN_LASTNAME = "last_name";
  static const String COLUMN_GENDER = "gender";
  static const String COLUMN_EMAIL = "email";
  static const String COLUMN_DOB = "dob";
  static const String COLUMN_MOBILE = "mobile";
  static const String COLUMN_PHOTONAME = "photoName";
  static const String COLUMN_TITLE = "title";
  static const String COLUMN_COMPANY = "company";
  static const String COLUMN_FAVOURITE = "isFavourite";
  static const String COLUMN_FAVOURITE_INDEX = "favourite_index";
  static const String COLUMN_OPERATION = "operation";

  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //"ReactiveTodo.db is our database instance name
    String path = join(documentsDirectory.path, "binaryDB.db");

    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute(
      "CREATE TABLE $contactsTABLE ("
      "$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
      "$COLUMN_UUID TEXT UNIQUE,"
      "$COLUMN_FIRSTNAME TEXT,"
      "$COLUMN_LASTNAME TEXT,"
      "$COLUMN_GENDER TEXT,"
      "$COLUMN_EMAIL TEXT,"
      "$COLUMN_DOB TEXT,"
      "$COLUMN_MOBILE TEXT,"
      "$COLUMN_PHOTONAME TEXT,"
      "$COLUMN_TITLE TEXT,"
      "$COLUMN_COMPANY TEXT,"
      "$COLUMN_FAVOURITE INTEGER,"
      "$COLUMN_FAVOURITE_INDEX INTEGER,"
      "$COLUMN_OPERATION INTEGER"
      ")",
    );
  }

  void close() async {
    if (this._database != null) {
      await this._database.close();
      this._database = null;
    }
  }
}
