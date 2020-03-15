import 'dart:convert';
import 'dart:ffi';

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  return json.encode(data.toMap());
}

class User {
  dynamic id;
  dynamic email;
  dynamic password;

  User({
    this.id,
    this.email,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json["id"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "password": password,
      };
}
