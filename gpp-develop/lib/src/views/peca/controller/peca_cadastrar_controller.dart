import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/controllers/pecas_controller/peca_controller.dart';
import 'package:gpp/src/controllers/pecas_controller/produto_controller.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/pecas/und_medida.dart';
import 'package:gpp/src/views/pecas/unidade.dart';

class PecaCadastrarController extends GetxController {
  late PecaController pecasController;
  late ProdutoController produtoController;

  late UnidadeTipo? selectedUnidadeTipo;
  late UnidadeMedida? selectedUnidadeMedida;
  late PecasModel? pecasModelInserido;

  late final txtIdProduto;
  late final txtNomeProduto;
  late final txtIdFornecedor;
  late final txtNomeFornecedor;

  var carregandoCadastroPeca = false.obs;

  PecaCadastrarController() {
    pecasController = PecaController();
    produtoController = ProdutoController();

    selectedUnidadeTipo = UnidadeTipo.Unidade;
    selectedUnidadeMedida = UnidadeMedida.Centimetros;
    pecasModelInserido = PecasModel();

    txtIdProduto = TextEditingController();
    txtNomeProduto = TextEditingController();
    txtIdFornecedor = TextEditingController();
    txtNomeFornecedor = TextEditingController();
  }

  @override
  void onInit() {
    super.onInit();
  }

  buscaProduto(String codigo) async {
    try {
      await produtoController.buscar(codigo);

      txtNomeProduto.text = produtoController.produto.resumida.toString();
      txtIdFornecedor.text = produtoController.produto.fornecedores!.first.idFornecedor.toString();
      txtNomeFornecedor.text = produtoController.produto.fornecedores!.first.cliente!.nome.toString();

      pecasController.produtoPecaModel.id_produto = int.parse(txtIdProduto.text);
      pecasController.pecasModel.id_fornecedor = produtoController.produto.fornecedores!.first.idFornecedor;
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      update();
    }
  }

  criarPeca() async {
    try {
      pecasController.pecasModel.active = 1;
      pecasController.pecasModel.unidade = pecasController.pecasModel.unidade ?? 1;
      pecasController.pecasModel.unidade_medida = pecasController.pecasModel.unidade_medida ?? 1;
      pecasModelInserido = await pecasController.criarPeca();
    } catch (e) {
    } finally {
      update();
    }
  }

  criarProdutoPeca() async {
    try {
      pecasController.produtoPecaModel.id_peca = pecasModelInserido!.id_peca;

      await pecasController.criarProdutoPeca();
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    }
  }

  InserirDados() async {
    carregandoCadastroPeca(true);

    try {
      if (txtIdProduto.text.isEmpty) {
        Notificacao.snackBar('Necessário informar o produto que será vinculado a peça');

        carregandoCadastroPeca(false);
      } else {
        await criarPeca();
        await criarProdutoPeca();
        Get.toNamed('/pecas-consultar');
        Notificacao.snackBar('Peça cadastrada com sucesso');

        carregandoCadastroPeca(false);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
      carregandoCadastroPeca(false);
    } finally {
      update();
    }
  }

  limparCampos() {
    txtIdProduto.text = '';
    txtNomeProduto.text = '';
    txtIdFornecedor.text = '';
    txtNomeFornecedor.text = '';
  }
}
