import 'package:flutter/material.dart';
import 'package:flutter_app/shared/custom_export.dart';
import 'package:flutter_app/view/cadastro_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: const Color.fromARGB(255, 0, 0, 139),
        title: Text(
          'Login Screen',
          style: GoogleFonts.montserrat(fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroView(),
                ),
              );
            },
            icon: const Icon(Icons.person_rounded),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomInput(
              title: 'Login',
              controller: _loginController,
            ),
            CustomInput(
              title: 'Password',
              controller: _passwordController,
              isPassword: true,
            ),
            ActionButton(
              text: 'Login',
              buttonAction: () => loginFunction,
            ),
          ],
        ),
      ),
    );
  }

  loginFunction() {
    if (_loginController.text == 'admin' &&
        _passwordController.text == 'admin') {
      Fluttertoast.showToast(
          msg: 'Login Success', backgroundColor: Colors.green);
    } else {
      final logger = Logger();
      logger.i(_loginController.text);

      Fluttertoast.showToast(msg: 'Login Error', backgroundColor: Colors.red);
    }
  }
}
