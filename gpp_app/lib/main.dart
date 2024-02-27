import 'package:auth_migration/routes/app_routes.dart';
import 'package:auth_migration/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('token');
  await Hive.openBox('usuario');
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
     GetMaterialApp(
      title: 'GPP',
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      getPages: AuthGuard.appRoutes,
    ),
  );
}
