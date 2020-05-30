import 'package:binaryflutterapp/src/database/database.dart';

class Contacts {
  int id;
  String UUID;
  String first_name;
  String last_name;
  String gender;
  String email;
  String dob;
  String mobile;
  String photoName;
  String title;
  String company;
  bool isFavourite;
  int favourite_index;
  int operation;

  Contacts(
      {this.id,
      this.UUID,
      this.first_name,
      this.last_name,
      this.gender,
      this.email,
      this.dob,
      this.mobile,
      this.photoName,
      this.title,
      this.company,
      this.operation,
      this.favourite_index,
      this.isFavourite});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_UUID: UUID,
      DatabaseProvider.COLUMN_FIRSTNAME: first_name,
      DatabaseProvider.COLUMN_LASTNAME: last_name,
      DatabaseProvider.COLUMN_GENDER: gender,
      DatabaseProvider.COLUMN_EMAIL: email,
      DatabaseProvider.COLUMN_DOB: dob,
      DatabaseProvider.COLUMN_MOBILE: mobile,
      DatabaseProvider.COLUMN_PHOTONAME: photoName,
      DatabaseProvider.COLUMN_TITLE: title,
      DatabaseProvider.COLUMN_COMPANY: company,
      DatabaseProvider.COLUMN_FAVOURITE_INDEX: favourite_index,
      DatabaseProvider.COLUMN_OPERATION: operation,
      DatabaseProvider.COLUMN_FAVOURITE: isFavourite ? 1 : 0
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Contacts.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    UUID = map[DatabaseProvider.COLUMN_UUID];
    first_name = map[DatabaseProvider.COLUMN_FIRSTNAME];
    last_name = map[DatabaseProvider.COLUMN_LASTNAME];
    gender = map[DatabaseProvider.COLUMN_GENDER];
    email = map[DatabaseProvider.COLUMN_EMAIL];
    dob = map[DatabaseProvider.COLUMN_DOB];
    mobile = map[DatabaseProvider.COLUMN_MOBILE];
    photoName = map[DatabaseProvider.COLUMN_PHOTONAME];
    title = map[DatabaseProvider.COLUMN_TITLE];
    company = map[DatabaseProvider.COLUMN_COMPANY];
    favourite_index = map[DatabaseProvider.COLUMN_FAVOURITE_INDEX];
    operation = map[DatabaseProvider.COLUMN_OPERATION];
    isFavourite = map[DatabaseProvider.COLUMN_FAVOURITE] == 1;
  }
}
