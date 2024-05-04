import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/LoaginPage.dart';
import '../../../models/user/login.dart';
import '../../../services/personaServices.dart';
import '../../MainMenu/main_menu.dart';
import '../login/login.dart';

class Load extends StatefulWidget {
  const Load({super.key});

  @override
  State<Load> createState() => _LoadState();
}

class _LoadState extends State<Load> {
  @override
  void initState() {
    super.initState();
    searchUser();
  }

  void searchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? email = prefs.getString('user');
    String? password = prefs.getString('password');

    if (email == null || password == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
    UserCredentialsResponse resp = await loginService(
        request: UserCredentials(email: email!, password: password!));

    if (resp.token == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
    prefs.setString('user', email);
    prefs.setString('password', password);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainMenu()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: loadingPage(),
      ),
    );
  }
}
