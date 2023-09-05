import 'dart:convert';

import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/solicitacao_os/motivo_reprovacao_solicitacao_os_model.dart';
import 'package:gpp/src/models/solicitacao_os/solicitacao_os_model.dart';
import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';
import 'dart:developer';

class SolicitacaoOSRepository {
  late ApiService api;

  SolicitacaoOSRepository() {
    api = ApiService();
  }

  Future<SolicitacaoOSModel> buscarSolicitacao({required int id}) async {
    Response response = await api.get('/solicitacao-os/$id');

    if (response.statusCode == StatusCode.OK) {
      var data = json.decode(response.body);

      SolicitacaoOSModel solicitacao = SolicitacaoOSModel.fromJson(data);

      return solicitacao;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List> buscarSolicitacoes({
    required int pagina,
    String? buscar,
    DateTime? dataInicio,
    DateTime? dataFim,
    int? filial,
    int? situacao,
  }) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'buscar': buscar ?? '',
      'dataInicio': dataInicio != null ? dataInicio.toString() : '',
      'dataFim': dataFim != null ? dataFim.toString() : '',
      'filial': filial != null ? filial.toString() : '',
      'situacao': situacao != null ? situacao.toString() : '',
    };

    Response response =
        await api.get('/solicitacao-os', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = json.decode(response.body);

      List<SolicitacaoOSModel> solicitacoes = data['solicitacao_os']
          .map<SolicitacaoOSModel>(
              (solicitacao) => SolicitacaoOSModel.fromJson(solicitacao))
          .toList();
      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);

      return [solicitacoes, pagina];
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<String> buscarFilialRetransferencia(String? filialDestino) async {
    Map<String, String> queryParameters = {
      'filial_destino': filialDestino != null ? filialDestino : '',
    };

    Response response = await api.get('/solicitacao-os/filial-retransferencia',
        queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = json.decode(response.body);

      return data['filial'];
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> criarSolicitacao(SolicitacaoOSModel solicitacao) async {
    print(jsonEncode(solicitacao.toJson()));

    Response response = await api.post('/solicitacao-os', solicitacao.toJson());

    if (response.statusCode == StatusCode.CREATED) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<String> atualizarSolicitacao(
      int id, SolicitacaoOSModel solicitacao) async {
    Map<String, dynamic> data = {
      "id_solicitacao_os": id,
      "situacao": solicitacao.situacao!,
      "id_motivo_reprovacao": solicitacao.idMotivoReprovacao,
      "observacao_reprovacao": solicitacao.observacaoReprovacao,
      "observacao_aprovacao": solicitacao.observacaoAprovacao,
      "classificacao_produto": solicitacao.classificacaoProduto,
    };

    Response response = await api.put(
      '/solicitacao-os/criar-ordem-servico',
      data,
    );

    if (response.statusCode == StatusCode.OK) {
      var mensagem = json.decode(response.body)['mensagem'];
      return mensagem;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
