import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

class Orientacao {
  static setOrientation(Widget app) {
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(app));
    } else {
      runApp(app);
    }
  }
}
