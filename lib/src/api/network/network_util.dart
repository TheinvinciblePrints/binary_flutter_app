import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class APIRequest {
  static APIRequest _instance = new APIRequest.internal();

  APIRequest.internal();

  factory APIRequest() {
    return _instance;
  }

  final JsonDecoder _decoder = new JsonDecoder();

  Map<String, String> get headers {
    return {HttpHeaders.contentTypeHeader: "application/json"};
  }

  Future<dynamic> get(String url) async {
    print("url :$url");
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = response.body;
      print(res);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        return Future.error("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, {Map body}) async {
    print("url :$url");
    print("headers: $headers");
    print("param :$body");
    return http
        .post(url, body: json.encode(body), headers: headers)
        .then((http.Response response) {
      final String res = response.body;
      print(res);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        return Future.error("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }
}
