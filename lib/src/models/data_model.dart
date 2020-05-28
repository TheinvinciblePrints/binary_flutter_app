import 'dart:convert';

String userToJson(Data data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class Data {
  String id;
  String firstName;
  String lastName;
  String email;
  String gender;
  String dateOfBirth;
  String phoneNo;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.gender,
      this.dateOfBirth,
      this.phoneNo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    phoneNo = json['phone_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['phone_no'] = this.phoneNo;
    return data;
  }
}
