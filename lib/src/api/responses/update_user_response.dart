import 'package:binaryflutterapp/src/models/data_model.dart';

class UpdateUserResponse {
  Data data;

  UpdateUserResponse({this.data});

  UpdateUserResponse.fromJson(Map<String, dynamic> json) {
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
