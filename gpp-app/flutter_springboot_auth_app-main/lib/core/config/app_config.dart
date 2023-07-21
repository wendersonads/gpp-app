import 'dart:convert';

import 'package:auth_migration/core/util/object_util.dart';
import 'package:flutter/services.dart';

class AppConfig {
  final String apiUrl;

  AppConfig({required this.apiUrl});

  static AppConfig? _instance;

  static Future<AppConfig?> loadEnv() async {
    if (ObjectUtil.isNull(_instance)) {
      final json =
          jsonDecode(await rootBundle.loadString('assets/config.json'));
      _instance = AppConfig(apiUrl: json['url']);
      return _instance;
    }
    return _instance;
  }
}
