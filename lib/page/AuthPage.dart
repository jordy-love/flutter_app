import 'package:flutter/material.dart';
import 'package:flutter_app/page/Join.dart';
import 'package:flutter_app/page/Login.dart';
import 'package:flutter_app/provider/FirebaseProvider.dart';
import 'package:provider/provider.dart';

AuthPageState pageState;

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() {
    pageState = AuthPageState();
    return pageState;
  }
}

class AuthPageState extends State<AuthPage> {
  FirebaseProvider fp;

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    if (fp.getUser() != null) { // && fp.getUser().isEmailVerified == true) {
      return JoinPage();
    } else {
      return LoginPage(); //signIn
    }
  }
}