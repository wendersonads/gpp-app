import 'package:flutter/material.dart';
import 'package:flutter_app/view/login_view.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Login',
      home: LoginView(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
