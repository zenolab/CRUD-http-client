

import 'package:crud_http_client/data/repository/login_repository.dart';

import 'base/base_login_use_case.dart';

class LoginUseCase extends BaseLoginUseCase {

  @override
  Future<String> postRequestAuthentication(String name, String password) async  {
    LoginService loginService = LoginService();
    String data = await loginService.postRequestAuthentication(name, password);
    return data;
  }

}