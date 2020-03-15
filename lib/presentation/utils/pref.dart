import 'package:shared_preferences/shared_preferences.dart';

Future<String> getLocalToken() async  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('stringValue');
    print("--SP Load  token is $stringValue");
    return stringValue;
}

saveToken(String token) async {
    print("--SP Enter Page token is $token");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stringValue', token);
}

removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isValue = prefs.containsKey('stringValue');
    if (isValue) prefs.remove("stringValue");
}