import 'package:gpp/src/models/box_enderecamento_model.dart';
import 'package:gpp/src/models/corredor_enderecamento_model.dart';
import 'package:gpp/src/models/estante_enderecamento_model.dart';
import 'package:gpp/src/models/piso_enderecamento_model.dart';
import 'package:gpp/src/models/prateleira_enderecamento_model.dart';
import 'package:gpp/src/repositories/enderecamento_repository.dart';

class EnderecamentoController {
  EnderecamentoRepository repository = EnderecamentoRepository();
  bool isLoaded = false;

  //pisos
  late PisoEnderecamentoModel pisoModel = PisoEnderecamentoModel();
  late List<PisoEnderecamentoModel> listaPiso = [];

  late CorredorEnderecamentoModel corredorModel = CorredorEnderecamentoModel();
  late List<CorredorEnderecamentoModel> listaCorredor = [];

  late EstanteEnderecamentoModel estanteModel = EstanteEnderecamentoModel();
  late List<EstanteEnderecamentoModel> listaEstante = [];

  late PrateleiraEnderecamentoModel prateleiraModel = PrateleiraEnderecamentoModel();
  late List<PrateleiraEnderecamentoModel> listaPrateleira = [];

  late BoxEnderecamentoModel boxModel = BoxEnderecamentoModel();
  late List<BoxEnderecamentoModel> listaBox = [];

  Future<List<PisoEnderecamentoModel>> buscarTodos(int idFilial) async {
    return await repository.buscarPisos();
  }

  Future<List<CorredorEnderecamentoModel>> buscarCorredor(String idPiso) async {
    return await repository.buscarCorredor(int.parse(idPiso));
  }

  Future<List<EstanteEnderecamentoModel>> buscarEstante(String idCorredor) async {
    //return await repository.buscarEstante(idCorredor);
    return [];
  }

  Future<List<PrateleiraEnderecamentoModel>> buscarPrateleira(String idEstante) async {
    //return await repository.buscarPrateleira(int.parse(idEstante));
    return [];
  }

  Future<List<BoxEnderecamentoModel>> buscarBox(String idPrateleira) async {
    return await repository.buscarBox(int.parse(idPrateleira));
  }

  // criar e excluir Piso
  Future<bool> excluir(PisoEnderecamentoModel pecasModel) async {
    return await repository.excluir(pecasModel);
  }

  Future<bool> criar() async {
    return await repository.criar(pisoModel);
  }

  Future<bool> editar() async {
    return await repository.editar(pisoModel);
  }

  //Criar e excluir Corredor
  Future<bool> excluirCorredor(String idPiso, CorredorEnderecamentoModel corredorModel) async {
    return await repository.excluirCorredor(idPiso, corredorModel);
  }

  Future<bool> criarCorredor(CorredorEnderecamentoModel corredor, String idPiso) async {
    return await repository.criarCorredor(corredor, idPiso);
  }

  Future<bool> editarCorredor() async {
    return await repository.editarCorredor(corredorModel);
  }

  // Estante
  Future<bool> excluirEstante(String idCorredor, EstanteEnderecamentoModel estanteEnderecamentoModel) async {
    return await repository.excluirEstate(idCorredor, estanteEnderecamentoModel);
  }

  Future<bool> criarEstante(EstanteEnderecamentoModel estanteEnderecamentoModel, String IdCorredor) async {
    return await repository.criarEstante(estanteEnderecamentoModel, IdCorredor);
  }

  Future<bool> editarEstante() async {
    return await repository.editarEstante(estanteModel);
  }

  //Prateleira
  Future<bool> excluirPrateleira(PrateleiraEnderecamentoModel prateleiraEnderecamentoModel) async {
    return await repository.excluirPrateleira(prateleiraEnderecamentoModel);
  }

  Future<bool> criarPrateleira(PrateleiraEnderecamentoModel prateleiraEnderecamentoModel, String idEstante) async {
    return await repository.criarPrateleira(prateleiraEnderecamentoModel, idEstante);
  }

  Future<bool> editarPrateleira() async {
    return await repository.editarPrateleira(prateleiraModel);
  }

  // Box
  Future<bool> excluirBox(String idPrateleira, BoxEnderecamentoModel boxEnderecamentoModel) async {
    return await repository.excluirBox(idPrateleira, boxEnderecamentoModel);
  }

  Future<bool> criarBox(BoxEnderecamentoModel boxEnderecamentoModel, String idPrateleira) async {
    return await repository.criarBox(boxEnderecamentoModel, idPrateleira);
  }

  Future<bool> editarBox() async {
    return await repository.editarBox(boxModel);
  }
}
