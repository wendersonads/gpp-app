import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/auth/usuario_service.dart';
import '../../shared/components/MaskFormatter.dart';
import '../model/pagina_model.dart';
import '../model/fornecedor_model.dart';
import '../model/usuario_model.dart';
import '../repository/fornecedor_repository.dart';

class FornecedorService extends GetxController {
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
  late MaskFormatter maskFormatter = MaskFormatter();
  String pesquisar = '';
  var carregando = true.obs;
  late FornecedorRepository fornecedorRepository;
  late List<Fornecedor> fornecedores;
  late Pagina pagina;

  FornecedorService() {
    fornecedorRepository = FornecedorRepository();
    fornecedores = <Fornecedor>[].obs;
    pagina = Pagina(total: 0, atual: 1);
  }

  @override
  void onInit() {
    listaFornecedors();
    super.onInit();
  }

  listaFornecedors() async {
    try {
      carregando(true);
      fornecedores = await fornecedorRepository.listaFornecedores();
    } catch (e) {
      null;
    } finally {
      carregando(false);
      update();
    }
  }

  Future<void> criarNovoFornecedor(Fornecedor novoFornecedor) async {
    try {
      print('Fornecedor para salvar: ${novoFornecedor}');

      carregando(true);
      await fornecedorRepository.salvarNovoFornecedor(novoFornecedor);
      listaFornecedors(); // Atualiza a lista após a criação do novo fornecedor
    } catch (e) {
      null;
    } finally {
      carregando(false);
      update();
    }
  }

  Future<void> editarFornecedor(Fornecedor fornecedorEditado) async {
    try {
      print('Fornecedor para editar: ${fornecedorEditado}');

      carregando(true);
      await fornecedorRepository.editarFornecedor(fornecedorEditado);
      listaFornecedors(); //
    } catch (e) {
      null;
    } finally {
      carregando(false);
      update();
    }
  }

  Future<void> deletarFornecedor(int idFornecedor) async {
    try {
      print('Fornecedor para deletar: ${idFornecedor}');

      carregando(true);
      if (idFornecedor != null) {
        await fornecedorRepository.deletarFornecedor(idFornecedor);
      }
      listaFornecedors();
    } catch (e) {
      null;
    } finally {
      carregando(false);
      update();
    }
  }
}
