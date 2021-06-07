import 'package:chat_app_tutorial/views/signin.dart';
import 'package:chat_app_tutorial/views/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSigIn = true;

  void toggleView() {
    setState(() {
      showSigIn = !showSigIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSigIn) {
      return SignIn(toggleView);
    } else {
      return SignUp(toggleView);
    }
  }
}
