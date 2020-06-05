import 'package:binaryflutterapp/src/models/users_model.dart';

class UserResponse {
  List<Data> data;
  int page;
  int row;
  int totalRow;

  UserResponse({this.data, this.page, this.row, this.totalRow});

  @override
  String toString() {
    return 'Users{page: $page, row: $row, totalRow: $totalRow, data: $data}';
  }

  UserResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    page = json['page'];
    row = json['row'];
    totalRow = json['total_row'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['row'] = this.row;
    data['total_row'] = this.totalRow;
    return data;
  }
}
