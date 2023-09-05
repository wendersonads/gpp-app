import 'dart:convert';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:http/http.dart';
import 'package:gpp/src/models/solicitacao_os/motivo_reprovacao_solicitacao_os_model.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';

class MotivoReprovacaoOsRepository {
  late ApiService api;

  MotivoReprovacaoOsRepository() {
    api = ApiService();
  }

  Future<List<MotivoReprovacaoSolicitacaoOsModel>>
      buscaMotivosReprovacao() async {
    Response response = await api.get('/motivo-reprovacao-solicitacao-os');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<MotivoReprovacaoSolicitacaoOsModel> motivosReprovacao = data
          .map<MotivoReprovacaoSolicitacaoOsModel>(
              (data) => MotivoReprovacaoSolicitacaoOsModel.fromJson(data))
          .toList();

      return motivosReprovacao;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }
}
