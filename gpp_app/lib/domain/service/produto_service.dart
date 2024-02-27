import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/auth/usuario_service.dart';
import '../../shared/components/MaskFormatter.dart';
import '../model/pagina_model.dart';
import '../model/produto_model.dart';
import '../model/usuario_model.dart';
import '../repository/produto_repository.dart';

class ProdutoService extends GetxController {
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
  late MaskFormatter maskFormatter = MaskFormatter();
  String pesquisar = '';
  var carregando = true.obs;
  late ProdutoRepository produtoRepository;
  late List<Produto> produtos;
  late Pagina pagina;

  ProdutoService() {
    produtoRepository = ProdutoRepository();
    produtos = <Produto>[].obs;
    pagina = Pagina(total: 0, atual: 1);
  }

  @override
  void onInit() {
    listaProdutos();
    super.onInit();
  }

  listaProdutos() async {
    try {
      carregando(true);
      produtos = await produtoRepository.listaProdutos();
    } catch (e) {
      null;
    } finally {
      carregando(false);
      update();
    }
  }

  Future<void> criarNovoProduto(Produto novoProduto) async {
    try {
      print('Produto para salvar: ${novoProduto}');

      carregando(true);
      await produtoRepository.salvarNovoProduto(novoProduto);
      listaProdutos(); // Atualiza a lista após a criação do novo produto
    } catch (e) {
      null;
    } finally {
      carregando(false);
      update();
    }
  }

  Future<void> editarProduto(Produto produtoEditado) async {
    try {
      print('Produto para editar: ${produtoEditado}');

      carregando(true);
      await produtoRepository.editarProduto(produtoEditado);
      listaProdutos(); //
    } catch (e) {
      null;
    } finally {
      carregando(false);
      update();
    }
  }

  Future<void> deletarProduto(int idProduto) async {
    try {
      print('Produto para deletar: ${idProduto}');

      carregando(true);
      if (idProduto != null) {
        await produtoRepository.deletarProduto(idProduto);
      }
      listaProdutos();
    } catch (e) {
      null;
    } finally {
      carregando(false);
      update();
    }
  }
}
