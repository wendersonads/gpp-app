import 'package:auth_migration/core/util/string_util.dart';
import 'package:auth_migration/domain/service/login_service.dart';
import 'package:auth_migration/view/home/home_screen.dart';
import 'package:auth_migration/view/register/register_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final LoginService _loginService = LoginService();

  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _enabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 50, right: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'LOGIN',
                style: TextStyle(fontSize: 35),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: 'CPF',
                  suffixIcon: Icon(
                    Icons.person,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    // Defina a cor desejada para a borda em foco
                  ),
                  iconColor: Colors.black,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Senha',
                  suffixIcon: Icon(Icons.password),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  _enabled ? loginAction() : null;
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons
                        .login), // Substitua "Icons.login" pelo ícone que você deseja usar
                    SizedBox(width: 8), // Espaço entre o ícone e o texto
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  toRegister();
                },
                child: const Text('CREATE ACCOUNT'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginAction() async {
    _screenState(false);
    String usr = _usernameController.text;
    String pwd = _passwordController.text;
    if (StringUtil.isEmpty(usr) || StringUtil.isEmpty(pwd)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Invalid login or password!'),
        ),
      );
    } else {
      bool result = await _loginService.tryLogin(usr, pwd);
      if (result) {
        _usernameController.clear();
        _passwordController.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Login error!'),
          ),
        );
      }
    }
    _screenState(true);
  }

  toRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  _screenState(bool state) {
    setState(() {
      _enabled = state;
    });
  }
}
