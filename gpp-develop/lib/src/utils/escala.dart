import 'package:flutter/material.dart';
import 'package:gpp/gpp_app.dart';
import 'package:gpp/gpp_app_mobile.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Escala {
  static Widget getFontScale() {
    if (!kIsWeb) {
      return GppAppMobile();
    } else {
      return GppApp();
    }
  }
}
