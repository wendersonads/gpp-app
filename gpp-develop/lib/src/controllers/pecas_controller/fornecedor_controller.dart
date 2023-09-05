import 'package:gpp/src/models/produto/fornecedor_model.dart';
import 'package:gpp/src/repositories/pecas_repository/fornecedor_repository.dart';

class FornecedorController {
  late final FornecedorRepository fornecedorRepository = FornecedorRepository();

  FornecedorModel fornecedorModel = FornecedorModel();

  Future<void> buscar(String id) async {
    try {
      fornecedorModel =
          await fornecedorRepository.buscarFornecedor(int.parse(id));
    } catch (e) {
      var error = e.toString();
      throw error;
    }
  }

  Future<List> buscarFornecedores(String? nome) async {
    try {
      return await fornecedorRepository.buscarFornecedores(1, pesquisar: nome);
    } catch (e) {
      var error = e.toString();
      throw error;
    }
  }
}
