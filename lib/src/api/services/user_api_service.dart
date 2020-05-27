import 'dart:convert';

import 'package:binaryflutterapp/src/constants/path_constants.dart';
import 'package:binaryflutterapp/src/models/users.dart';
import 'package:http/http.dart' show Client;

class ApiService {
  static final baseUrl = kBaseAPIURL;
  static final userEndpoint = kBaseEndPoint;
  Client client = Client();

  Future<UsersResponse> getUsers(int page, int row) async {
    final response =
        await client.get("$baseUrl/$userEndpoint?page=$page&row=$row");
    if (response.statusCode == 200) {
      return UsersResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<Data> createUser(Data data) async {
    final response = await client.post(
      "$baseUrl/$userEndpoint",
      headers: {"content-type": "application/json"},
      body: {userToJson(data)},
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      Data serverResponse = Data.fromJson(jsonData);
      return serverResponse;
    } else {
      return null;
    }
  }

  Future<bool> updateUser(Data data, int id) async {
    final response = await client.put(
      "$baseUrl/$userEndpoint/${id}",
      headers: {"content-type": "application/json"},
      body: userToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    final response = await client.delete(
      "$baseUrl/$userEndpoint/${id}",
      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
