import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/entrada/movimento_entrada_controller.dart';
import 'package:gpp/src/controllers/pecas_controller/fornecedor_controller.dart';
import 'package:gpp/src/models/entrada/item_movimento_entrada_model.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/models/produto_peca_model.dart';
import 'package:gpp/src/repositories/PecaRepository.dart';
import 'package:gpp/src/repositories/pecas_repository/produto_repositoy.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:get/get.dart';

class EntradaManualController extends GetxController {
  late GlobalKey<FormState> filtroFormKey;
  late GlobalKey<FormState> notaFiscalForm;

  List<String> pedidos = [];

  late TextEditingController controllerIdFornecedor;
  late FornecedorController fornecedorController;
  late List<PecasModel> pecasBusca;
  late List<PecasEntradaManual> pecasPopUp;
  late PecaRepository pecaRepository;
  late ProdutoRepository produtoRepository;
  var carregandoFornecedor = false.obs;
  var carregandoPecas = false.obs;
  var carregandoEntrada = false.obs;
  var carregandoPecasEntrada = true.obs;
  late List<ItemMovimentoEntradaModel> listaMovimento;
  var marcados = 0;

  late TextEditingController controllerIdProduto;
  late TextEditingController controllerIdPeca;

  late TextEditingController controllerNotaFiscal;
  late TextEditingController controllerSerie;

  late MovimentoEntradaController movimentoEntradaController;

  EntradaManualController() {
    controllerIdFornecedor = TextEditingController();
    controllerIdProduto = TextEditingController();
    controllerIdPeca = TextEditingController();
    fornecedorController = FornecedorController();
    filtroFormKey = GlobalKey<FormState>();
    notaFiscalForm = GlobalKey<FormState>();
    pecaRepository = PecaRepository();
    pecasPopUp = <PecasEntradaManual>[].obs;
    pecasBusca = <PecasModel>[].obs;
    listaMovimento = <ItemMovimentoEntradaModel>[].obs;
    produtoRepository = ProdutoRepository();
    controllerNotaFiscal = TextEditingController();
    controllerSerie = TextEditingController();
    movimentoEntradaController = MovimentoEntradaController();
  }

  buscarFornecedor() async {
    try {
      carregandoFornecedor(true);
      await fornecedorController.buscar(controllerIdFornecedor.text);
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoFornecedor(false);
      update();
    }
  }

  buscarFornecedores(String? nome) async {
    try {
      List<dynamic> fornecedores =
          await fornecedorController.buscarFornecedores(nome);

      // A primeira posição dessa lista contém os fornecedores de fato.
      return fornecedores[0];
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      update();
    }
  }

  buscarPecas() async {
    pecasBusca.clear();
    if (controllerIdPeca.text.toString() == '' ||
        controllerIdProduto.text.toString() == '') {
      if (controllerIdPeca.text != '') {
        await buscarPecasPorId();
      } else if (controllerIdProduto.text != '') {
        await buscarPecasPorProduto();
      }
    } else {
      Notificacao.snackBar("Somente um filtro de pesquisa por vez!");
    }
    controllerIdPeca.text = '';
    controllerIdProduto.text = '';
    update();
  }

  buscarPecasPorProduto() async {
    try {
      carregandoPecas(true);
      if (controllerIdProduto.text != '' && controllerIdFornecedor.text != '') {
        List<ProdutoPecaModel> produtoPeca =
            await produtoRepository.buscarProdutoPecasFornecedor(
                int.parse(controllerIdProduto.text),
                int.parse(controllerIdFornecedor.text));

        for (var item in produtoPeca) {
          item.peca!.produto = item.produto ?? null;
          pecasBusca.add(item.peca!);
        }
      }
      gerarPecas();
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoPecas(false);
      update();
    }
  }

  buscarPecasPorId() async {
    try {
      carregandoPecas(true);
      if (controllerIdPeca.text != '' && controllerIdFornecedor.text != '') {
        pecasBusca.add(await pecaRepository.buscarPecaFornecedor(
            int.parse(controllerIdPeca.text),
            int.parse(controllerIdFornecedor.text)));
      }
      gerarPecas();
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoPecas(false);
      update();
    }
  }

  gerarPecas() {
    pecasBusca.forEach((element) {
      pecasPopUp.add(PecasEntradaManual(marcado: false, peca: element));
    });
  }

  marcarTodosCheckbox(bool value) {
    if (value) {
      marcados = pecasBusca.length;
    } else {
      marcados = 0;
    }
    for (var itemPedido in pecasPopUp) {
      itemPedido.marcado = value;
    }
  }

  marcarCheckbox(index, value) {
    if (value) {
      marcados++;
    } else {
      marcados--;
    }
    pecasPopUp[index].marcado = value;
  }

  adicionarPecasParaEntrada() {
    carregandoPecasEntrada(true);
    bool notifica = true;

    for (var item in pecasPopUp) {
      if (item.marcado!) {
        if (listaMovimento.any(
            (element) => element.pecaModel!.id_peca == item.peca!.id_peca)) {
          notifica = false;
        } else {
          ItemMovimentoEntradaModel itemMovimento =
              new ItemMovimentoEntradaModel();
          itemMovimento.pecaModel = item.peca!;
          itemMovimento.valor_unitario = 0.0;
          listaMovimento.add(itemMovimento);
        }
      }
    }

    Get.back();
    notifica
        ? Notificacao.snackBar("Todas as peças adicionadas com sucesso!")
        : Notificacao.snackBar(
            "Algumas peças não foram adicionadas porque já estão na lista");
    carregandoPecasEntrada(false);
    update();
  }

  removerPecasEntrada(ItemMovimentoEntradaModel item) {
    carregandoPecasEntrada(true);
    listaMovimento.remove(item);
    Notificacao.snackBar("Peça Removida com sucesso!");
    carregandoPecasEntrada(false);
    update();
  }

  lancarEntrada() async {
    carregandoEntrada(true);
    bool success = false;
    if (controllerNotaFiscal.text == '' || controllerSerie.text == '') {
      Notificacao.snackBar('Numero da Nota Fiscal e Série são obrigatórios!');
    } else if (listaMovimento.isEmpty) {
      Notificacao.snackBar(
          'É necessário adicionar as peças para dar a entrada!');
    } else {
      movimentoEntradaController.movimentoEntradaModel?.num_nota_fiscal =
          int.parse(controllerNotaFiscal.text);
      movimentoEntradaController.movimentoEntradaModel?.serie =
          controllerSerie.text;

      success = movimentoEntradaController
          .manualItensEntradaToItensEntrada(listaMovimento);
      if (success) {
        try {
          if (await movimentoEntradaController.createManual()) {
            Notificacao.snackBar('Entrada realizada com sucesso');
          }
        } catch (e) {
          Notificacao.snackBar(e.toString());
        }
      } else {
        Notificacao.snackBar(
            'Existem items com a quantidade recebida ou quantidade pedida não informada!');
      }
    }
    carregandoEntrada(false);

    update();
    return success;
  }
}

class PecasEntradaManual {
  bool? marcado = false;
  late PecasModel? peca;
  PecasEntradaManual({
    this.marcado,
    this.peca,
  });
}
