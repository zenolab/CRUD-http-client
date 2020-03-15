import 'base/base_registration_use_case.dart';
import 'package:crud_http_client/data/repository/registration_repository.dart';


class RegistrationUseCase implements BaseRegistrationUseCase {
  RegistrationService _registrationService = RegistrationService();

  @override
  Future<String> enrollmentUser(String name, String password) async {
    return await _registrationService.enrollmentUser(name, password);
  }

}