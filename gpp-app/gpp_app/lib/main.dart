import 'package:flutter/material.dart';
import 'package:flutter_app/view/login_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  //await dotenv.load(fileName: "env");
  runApp(
    const MaterialApp(
      title: 'Login',
      home: LoginView(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
