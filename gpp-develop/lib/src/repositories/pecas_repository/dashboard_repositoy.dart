import 'dart:convert';

import 'package:gpp/src/models/dashboard_model.dart';

import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class DashboardRepository {
  late ApiService api;

  DashboardRepository() {
    api = ApiService();
  }

  Future<DashboardModel> buscarDashboard() async {
    Response response = await api.get('/dashboard');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      return DashboardModel.fromJson(data);
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }
}
