import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school/components/LoadingAlert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/LoginTextField.dart';
import '../../../components/OkDialogAlert.dart';
import '../../../components/StyleButton.dart';
import '../../../models/user/login.dart';
import '../../../services/personaServices.dart';
import '../../MainMenu/main_menu.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController user;
  late TextEditingController password;

  @override
  void initState() {
    super.initState();
    user = TextEditingController();
    //user.text = "Leonel@test.com";
    password = TextEditingController();
    //password.text = "Carlosx94*";
  }

  void makeLogin() async {
    showLoadingAlert(context: context);
    UserCredentialsResponse resp = await loginService(
        request: UserCredentials(email: user.text, password: password.text));
    closeLoadingAlert(context: context);
    if (resp.token == null) {
      showOkAlert(
          context: context,
          title: "Atención",
          message: "Credenciales incorrectas");
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user.text);
    prefs.setString('password', password.text);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MainMenu()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, // Comienzo del gradiente
                end: Alignment.bottomRight, // Fin del gradiente
                colors: [
                  Colors.orange, // Color de inicio del gradiente
                  Colors.yellow, // Color de fin del gradiente
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/xochicalco.png"),
              const SizedBox(
                width: double.infinity,
                height: 10,
              ),
              LoginTextField(
                controller: user,
                title: "Correo",
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(
                height: 20,
              ),
              LoginTextField(
                controller: password,
                title: "Contraseña",
                isPassword: true,
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: makeLogin,
                child: LoginButton(
                  title: "Iniciar Sesión",
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
