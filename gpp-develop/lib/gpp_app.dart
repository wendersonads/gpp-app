import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/routes/app_routes.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/not_found/view/notfound_view.dart';

class GppApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GppAppState();
}

class _GppAppState extends State<GppApp> {
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPP - Gerenciamento de Peças e Pedidos',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: primaryColor,
          fontFamily: 'Mada',
          inputDecorationTheme: const InputDecorationTheme(
            iconColor: Colors.grey,
            floatingLabelStyle: TextStyle(color: Color.fromRGBO(4, 4, 145, 1)),
          )),
      initialRoute: '/login',
      getPages: appRoutes,
      unknownRoute: GetPage(name: '/notfound', page: () => NotFoundView()),
    );
  }
}
