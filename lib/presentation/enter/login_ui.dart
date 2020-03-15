import 'dart:async';

import 'package:crud_http_client/domain/interactors/login_use_case.dart';
import 'package:crud_http_client/domain/interactors/registration_use_case.dart';
import 'package:crud_http_client/presentation/home/tasks_page.dart';
import 'package:crud_http_client/presentation/utils/pref.dart';
import 'package:flutter/material.dart';



const String registerTitle = "REGISTER";
const String logInTitle = "LOG IN";

class EnterPage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<EnterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  String _email;
  String _password;
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    void initState() {
      super.initState();
    }

    //input widget
    Widget _inputField(Icon icon, String hint, TextEditingController controller, bool obsecure) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obsecure,
          style: TextStyle(
            fontSize: 20,
          ),
          decoration: InputDecoration(
              hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              hintText: hint,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 3,
                ),
              ),
              prefixIcon: Padding(
                child: IconTheme(
                  data: IconThemeData(color: Theme.of(context).primaryColor),
                  child: icon,
                ),
                padding: EdgeInsets.only(left: 30, right: 10),
              )),
        ),
      );
    }

    //button widget
    Widget _button(String text, Color splashColor, Color highlightColor, Color fillColor,
        Color textColor, void function()) {
      return RaisedButton(
        highlightElevation: 0.0,
        splashColor: splashColor,
        highlightColor: highlightColor,
        elevation: 0.0,
        color: fillColor,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
        ),
        onPressed: () {
          function();
        },
      );
    }

    void _loginUser() async {
      _email = _emailController.text;
      _password = _passwordController.text;
      _emailController.clear();
      _passwordController.clear();
      await loadUser();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TasksPage(),
        ),
      );
    }

    void _registerUser() async {
      _email = _emailController.text;
      _password = _passwordController.text;
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
      createUser();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TasksPage(),
        ),
      );
    }

    Widget _buildEnterScreen() {
      return Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 140,
                child: Center(
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20, top: 20),
                child: _inputField(Icon(Icons.email), "EMAIL", _emailController, false),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: _inputField(Icon(Icons.lock), "PASSWORD", _passwordController, true),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Login / Register"),
                  Switch(
                    value: _isSwitched,
                    onChanged: (value) {
                      setState(() {
                        _isSwitched = value;
                      });
                    },
                    activeTrackColor: Colors.grey,
                    activeColor: Colors.green,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: _button(_showTitle(), Colors.white, primary, primary, Colors.white,
                      _isSwitched ? _registerUser : _loginUser),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height / 1.1,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
      );
    }

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: <Widget>[
            _buildEnterScreen(),
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ));
  } //End build Widget

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }

  String _showTitle() {
    if (_isSwitched)
      return registerTitle;
    else
      return logInTitle;
  }

 FutureOr<String> createUser() async {
    RegistrationUseCase registrationUseCase = RegistrationUseCase();
    String token = await registrationUseCase.enrollmentUser(_email, _password);
    saveToken(token);
    await saveToken(token );
    return token;
  }

  FutureOr<String> loadUser() async {
    LoginUseCase loginUseCase = LoginUseCase();
    String token = await loginUseCase.postRequestAuthentication(_email, _password);
    saveToken(token);
    await saveToken(token);
    return token;
  }
}
