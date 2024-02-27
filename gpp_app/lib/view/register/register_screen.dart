import 'package:auth_migration/core/util/string_util.dart';
import 'package:auth_migration/domain/model/dto/register_dto.dart';
import 'package:auth_migration/domain/model/register_model.dart';
import 'package:auth_migration/domain/service/register_service.dart';
import 'package:auth_migration/shared/components/Notificacao.dart';
import 'package:auth_migration/view/login/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  

  final RegisterService _registerService = RegisterService();

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
                'CADASTRO',
                style: TextStyle(fontSize: 35),
              ),
               const SizedBox(
                height: 40,
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Nome'),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(hintText: 'Usuário'),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(hintText: 'Senha'),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {
                  registerAction();
                },
                child: const Text('CADASTRAR'),
              ),
              TextButton(
                onPressed: () {
                  _enabled ? toLogin() : null;
                },
                child: const Text('VOLTAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  registerAction() async {
    _screenState(false);
    String usr = _usernameController.text;
    String pwd = _passwordController.text;
    String nm = _nameController.text;
    if (StringUtil.isEmpty(usr) || StringUtil.isEmpty(pwd)) {
      Notificacao.snackBar('Todos os campos devem ser preenchidos!', tipoNotificacao: TipoNotificacaoEnum.error);
    } else {
      bool result = await _registerService.tryRegister(nm,usr, pwd);
      if (result) {
        _usernameController.clear();
        _passwordController.clear();
        _nameController.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    }
    _screenState(true);
  }

  toLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  _screenState(bool state) {
    setState(() {
      _enabled = state;
    });
  }
}
