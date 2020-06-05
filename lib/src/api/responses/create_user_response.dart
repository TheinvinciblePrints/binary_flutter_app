import 'package:binaryflutterapp/src/models/users_model.dart';

class CreateUserResponse {
  Data data;

  CreateUserResponse({this.data});

  CreateUserResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}
