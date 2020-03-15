import 'base/base_services.dart';

mixin  BaseRegistrationService implements BaseService {

  Future<String> enrollmentUser(String name, String password);

}