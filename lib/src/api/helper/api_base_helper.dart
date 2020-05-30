import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:binaryflutterapp/src/api/exceptions/app_exceptions.dart';
import 'package:binaryflutterapp/src/api/responses/create_user_response.dart';
import 'package:binaryflutterapp/src/api/responses/delete_user_response.dart';
import 'package:binaryflutterapp/src/api/responses/update_user_response.dart';
import 'package:binaryflutterapp/src/constants/path_constants.dart';
import 'package:http/http.dart' as http;

class ApiBaseHelper {
  static final _baseUrl = kBaseAPIURL;
  static final userEndpoint = kBaseEndPoint;

  Future<dynamic> get(String url) async {
    print('Api Get, url ${_baseUrl + userEndpoint + url}');
    var responseJson;
    try {
      final response = await http.get(_baseUrl + userEndpoint + url);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api get received!');
    return responseJson;
  }

  Future<CreateUserResponse> post(dynamic data) async {
    print('Api Post, url ${_baseUrl + userEndpoint}');

    var serverResponse;
    try {
      var body = json.encode(data);
      print('Post params:  $body');

      final response = await http.post(_baseUrl + userEndpoint,
          headers: {"Content-Type": "application/json"}, body: body);

      var jsonData = json.decode(response.body);
      print('Post response:  $jsonData');

      if (response.statusCode == 200) {
        serverResponse = CreateUserResponse.fromJson(jsonData);
      } else {
        throw Exception("Failed to save data");
      }
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return serverResponse;
  }

  Future<UpdateUserResponse> put(String id, dynamic data) async {
    print('Api Post, url ${_baseUrl + userEndpoint + id}');
    var serverResponse;
    try {
      var body = json.encode(data);
      print('Post params:  $body');
      final response = await http.put(_baseUrl + userEndpoint + id,
          headers: {"Content-Type": "application/json"}, body: body);

      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        serverResponse = UpdateUserResponse.fromJson(jsonData);
      } else {
        throw Exception("Failed to update data");
      }
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api put.');
    print(serverResponse.toString());
    return serverResponse;
  }

  Future<DeleteUserResponse> delete(String url) async {
    print('Api delete, url ${_baseUrl + userEndpoint + url}');
    var serverResponse;

    try {
      final response = await http.delete(_baseUrl + userEndpoint + url);
      var jsonData = json.decode(response.body);
      serverResponse = DeleteUserResponse.fromJson(jsonData);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api delete.');
    return serverResponse;
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      print(responseJson);
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occurred while communicating with server with statusCode : ${response.statusCode}');
  }
}
