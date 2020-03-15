import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crud_http_client/data/utils/avaiablility_network.dart';
import 'package:crud_http_client/domain/services/login_services.dart';

import '../network/network_config.dart';
import 'package:http/http.dart' as http;


class LoginService with BaseLoginService  {
  static const String _tokenEndPoint = "/auth";
  bool _connected;

  ///Authenticate
  Future<String> postRequestAuthentication(String name, String password) async {
    String _url = baseUrl + _tokenEndPoint;
    String _requestBody = '{"email":"$name","password":"$password"}';

    try {
      await checkConnectivity().then((internet) => _connected = internet);
      if (_connected) {
        var response = await http
            .post(_url,
            body: _requestBody,
            headers: {'Content-Type': 'application/json'},
            encoding: Encoding.getByName('utf-8'));
        return _handleResponse(response);
      } else {
        return "Not accessible internet";
      }
    } catch (e) {
      print('Exception ${e.runtimeType}.');
      rethrow; // Allow callers to see the exception.
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode < 400) {
      if (jsonDecode(response.body)['token'] == null) return "Wrong response format";
      return _getBearerToken(response.body);
    } else {
      print('Error occured while communication with Server');
      print('StatusCode : ${response.statusCode}');
      return response.statusCode;
    }
  }

  String _getBearerToken(String body) {
    var parserJson = json.decode(body);
    String token = parserJson['token'];
    return token;
  }
}


