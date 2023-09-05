import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpp/src/models/inventario/inventario_local_evento_model.dart';
import 'package:gpp/src/models/inventario/inventario_local_model.dart';
import 'package:gpp/src/models/inventario/inventario_local_peca_model.dart';
import 'package:gpp/src/utils/escala.dart';
import 'package:gpp/src/utils/orientacao.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

GlobalKey<ScaffoldState> drawerKey = new GlobalKey<ScaffoldState>();
var info;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  info = await PackageInfo.fromPlatform();
  await dotenv.load(fileName: "env");
  Widget app = Escala.getFontScale();
  //usePathUrlStrategy();
  /* 
    App principal já chega com o tamanho da fonte assim como a orientação padrão
    setada.
  */

  await _initHive();

  Orientacao.setOrientation(app);
}

Future<void> _initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(InventarioLocalPecaModelAdapter());
  Hive.registerAdapter(InventarioLocalEventoModelAdapter());
  Hive.registerAdapter(InventarioLocalModelAdapter());

  await Hive.openBox<InventarioLocalModel>('inventario');
}
