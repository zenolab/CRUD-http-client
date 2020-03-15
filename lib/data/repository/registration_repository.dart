import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:crud_http_client/data/network/network_config.dart';
import 'package:crud_http_client/data/utils/avaiablility_network.dart';
import 'package:crud_http_client/domain/services/registration_services.dart';



class RegistrationService with BaseRegistrationService {
  static const String _tokenEndPoint = "/users";
  bool _connected;

  @override
  Future<String> enrollmentUser(String name, String password) async {
    String url = baseUrl + _tokenEndPoint;
    String _requestBody = '{"email":"$name","password":"$password"}';
    final _contentType = {'Content-Type': 'application/json'};

    await checkConnectivity().then((internet) => _connected = internet);
    if (_connected) {
     return await post(url,
          body: _requestBody, headers: _contentType, encoding: Encoding.getByName('utf-8'))
          .then((response) {
        if (response.statusCode >= 400 || response.body == null) {
          throw new Exception("Error while fetching data. Status code: ${response.statusCode}");
        }
        return  _getBearerToken(response.body);
      }).catchError((error) {
        print("Error: $error");
        throw "Error connection : " + error;
      });
    } else {
      print("Not accessible internet");
      return "Not accessible internet";
    }
  }

  String _getBearerToken(var body) {
    print("--RegistrationService _getBearerToken token $body");
    var parserJson = json.decode(body);
    String token = parserJson['token'];
    return token;
  }
}

