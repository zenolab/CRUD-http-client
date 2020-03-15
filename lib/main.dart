import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'presentation/enter/login_ui.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          hintColor: Color(0xFFe8d8be),
          primaryColor: Color(0xFFb3a394),
          fontFamily: "Montserrat",
          canvasColor: Colors.transparent),
      home: EnterPage (),

    );
  }
}