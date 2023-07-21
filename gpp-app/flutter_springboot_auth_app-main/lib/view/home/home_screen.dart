import 'package:auth_migration/core/auth/token_service.dart';
import 'package:auth_migration/domain/model/token_model.dart';
import 'package:auth_migration/domain/service/api_service.dart';
import 'package:auth_migration/domain/service/auth_service.dart';
import 'package:auth_migration/view/login/login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TokenService _tokenService = TokenService();
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  String apiName = '';

  String accessToken = '';
  String refreshToken = '';

  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _enabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 50, right: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(apiName),
              ElevatedButton(
                onPressed: () {
                  _enabled ? getName() : null;
                },
                child: const Text('GET DATA'),
              ),
              TextButton(
                onPressed: () {
                  _enabled ? readTokens() : null;
                },
                child: const Text('READ TOKENS'),
              ),
              Text(accessToken),
              Text(refreshToken)
            ],
          ),
        ),
      ),
    );
  }

  getName() async {
    _screenState(false);
    String result = await _apiService.getName();
    setState(() {
      apiName = result;
    });
    _screenState(true);
  }

  readTokens() {
    _screenState(false);
    Token token = _tokenService.get();
    accessToken = token.accessToken;
    refreshToken = token.refreshToken;
    setState(() {});
    _screenState(true);
  }

  logout() {
    _screenState(false);
    _authService.logOut();
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
