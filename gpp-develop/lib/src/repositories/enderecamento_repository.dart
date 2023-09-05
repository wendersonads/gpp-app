import 'dart:convert';

import 'package:gpp/src/models/box_enderecamento_model.dart';
import 'package:gpp/src/models/corredor_enderecamento_model.dart';
import 'package:gpp/src/models/estante_enderecamento_model.dart';
import 'package:gpp/src/models/piso_enderecamento_model.dart';
import 'package:gpp/src/models/prateleira_enderecamento_model.dart';

import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';

class EnderecamentoRepository {
  late ApiService api;

  EnderecamentoRepository() {
    this.api = ApiService();
  }

  Future<List<PisoEnderecamentoModel>> buscarPisos() async {
    Response response = await api.get('/piso');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PisoEnderecamentoModel> enderecamentoPiso =
          data.map<PisoEnderecamentoModel>((data) => PisoEnderecamentoModel.fromJson(data)).toList();

      return enderecamentoPiso;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List<CorredorEnderecamentoModel>> buscarCorredor(int idPiso) async {
    Response response = await api.get('/piso/${idPiso}/corredor');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<CorredorEnderecamentoModel> enderecamentoCorredor =
          data.map<CorredorEnderecamentoModel>((data) => CorredorEnderecamentoModel.fromJson(data)).toList();

      return enderecamentoCorredor;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List<EstanteEnderecamentoModel>> buscarEstante(int idCorredor) async {
    Response response = await api.get('/corredor/${idCorredor}/estante');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<EstanteEnderecamentoModel> enderecamentoEstante =
          data.map<EstanteEnderecamentoModel>((data) => EstanteEnderecamentoModel.fromJson(data)).toList();

      return enderecamentoEstante;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List<PrateleiraEnderecamentoModel>> buscarPrateleira(int idEstante) async {
    Response response = await api.get('/estante/${idEstante}/prateleira');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<PrateleiraEnderecamentoModel> enderecamentoPrateleira =
          data.map<PrateleiraEnderecamentoModel>((data) => PrateleiraEnderecamentoModel.fromJson(data)).toList();

      return enderecamentoPrateleira;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<List<BoxEnderecamentoModel>> buscarBox(int idPrateleira) async {
    Response response = await api.get('/prateleira/${idPrateleira}/box');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<BoxEnderecamentoModel> enderecamentoBox =
          data.map<BoxEnderecamentoModel>((data) => BoxEnderecamentoModel.fromJson(data)).toList();

      return enderecamentoBox;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  // excluir e criar Piso

  Future<bool> excluir(PisoEnderecamentoModel pisoModelo) async {
    Response response = await api.delete('/piso/' + pisoModelo.id_piso.toString());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> criar(PisoEnderecamentoModel pisos) async {
    Response response = await api.post('/piso', pisos.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> editar(PisoEnderecamentoModel pisos) async {
    //print(jsonEncode(pisos.toJson()));

    Response response = await api.put('/piso/' + pisos.id_piso.toString(), pisos.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  // excluir e criar Corredor

  Future<bool> excluirCorredor(String idPiso, CorredorEnderecamentoModel corredorModelo) async {
    Response response = await api.delete("/piso/${idPiso}/corredor/${corredorModelo.id_corredor.toString()}");

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> criarCorredor(CorredorEnderecamentoModel corredor, String idPiso) async {
    //print(jsonEncode(corredor.toJson()));
    Response response = await api.post('/piso/' + idPiso + '/corredor', corredor.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> editarCorredor(CorredorEnderecamentoModel corredorModelo) async {
    //print(jsonEncode(pisos.toJson()));

    Response response = await api.put('/corredor/' + corredorModelo.id_corredor.toString(), corredorModelo.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  // excluir e criar Estante

  Future<bool> excluirEstate(String idCorredor, EstanteEnderecamentoModel estanteEnderecamentoModel) async {
    Response response = await api.delete("/corredor/${idCorredor}/estante/${estanteEnderecamentoModel.id_estante.toString()}");

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> criarEstante(EstanteEnderecamentoModel estanteEnderecamentoModel, String idCorredor) async {
    //print(jsonEncode(estanteEnderecamentoModel.toJson()));
    Response response = await api.post('/corredor/' + idCorredor + '/estante', estanteEnderecamentoModel.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> editarEstante(EstanteEnderecamentoModel estanteModelo) async {
    //print(jsonEncode(pisos.toJson()));

    Response response =
        await api.put('/piso/00/corredor/00/estante/' + estanteModelo.id_estante.toString(), estanteModelo.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  // Prateleira

  Future<bool> excluirPrateleira(PrateleiraEnderecamentoModel prateleiraEnderecamentoModel) async {
    Response response = await api.delete('/estante/00/prateleira/' + prateleiraEnderecamentoModel.id_prateleira.toString());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> criarPrateleira(PrateleiraEnderecamentoModel prateleiraEnderecamentoModel, String idEstante) async {
    //print(jsonEncode(prateleiraEnderecamentoModel.toJson()));
    Response response = await api.post('/estante/' + idEstante + '/prateleira', prateleiraEnderecamentoModel.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> editarPrateleira(PrateleiraEnderecamentoModel prateleiraModelo) async {
    //print(jsonEncode(pisos.toJson()));

    Response response = await api.put('/estante/' + prateleiraModelo.id_prateleira.toString(), prateleiraModelo.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  // Box

  Future<bool> excluirBox(String idPrateleira, BoxEnderecamentoModel boxEnderecamentoModel) async {
    Response response =
        await api.delete("/prateleira/${boxEnderecamentoModel.id_prateleira}/box/${boxEnderecamentoModel.id_box.toString()}");

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> criarBox(BoxEnderecamentoModel boxEnderecamentoModel, String idPrateleira) async {
    //print(jsonEncode(boxEnderecamentoModel.toJson()));
    Response response = await api.post("/prateleira/${idPrateleira}/box", boxEnderecamentoModel.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> editarBox(BoxEnderecamentoModel BoxModelo) async {
    //print(jsonEncode(pisos.toJson()));

    Response response =
        await api.put("/prateleira/${BoxModelo.id_prateleira}/box/${BoxModelo.id_box.toString()}", BoxModelo.toJson());

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }
}
